import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/notification/notification_model.dart';
import 'notification_service.dart';

/// Identificador del canal de notificaciones de Android. Debe coincidir con el
/// declarado en AndroidManifest.xml
/// (`com.google.firebase.messaging.default_notification_channel_id`).
const String _androidChannelId = 'high_importance_channel';

/// Topic al que se suscriben todos los dispositivos. Permite enviar una
/// notificación a todos desde la consola de Firebase (Mensajería → "Enviar a
/// un tema" → `all`) sin gestionar tokens individuales.
const String _broadcastTopic = 'all';

/// Handler de mensajes recibidos con la app en segundo plano o cerrada.
///
/// Debe ser una función de nivel superior y estar anotada con
/// `@pragma('vm:entry-point')` porque Flutter la ejecuta en un isolate
/// independiente. En este isolate NO existen los singletons de la app
/// (base de datos Floor, providers, etc.), por lo que aquí no guardamos nada
/// en la campanita local: cuando el mensaje trae bloque `notification`, FCM
/// muestra el aviso en la bandeja del sistema automáticamente.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Mantener mínimo: el isolate puede terminar en cualquier momento.
  debugPrint('FCM background message: ${message.messageId}');
}

/// Servicio central de notificaciones push (Firebase Cloud Messaging).
///
/// Convive con el sistema de notificaciones local existente: cada push
/// recibida se registra también en la campanita local mediante
/// [NotificationService.push].
class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<User?>? _authSub;

  /// Inicializa el canal de Android, los listeners de mensajes y la gestión de
  /// tokens. Debe llamarse una sola vez tras `Firebase.initializeApp` y tras
  /// registrar el [firebaseMessagingBackgroundHandler].
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _setupLocalNotifications();
    await _requestPermission();

    // Foreground: FCM no dibuja la notificación automáticamente, lo hacemos
    // nosotros con flutter_local_notifications y la guardamos en la campanita.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // La app estaba en segundo plano y el usuario tocó la notificación.
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    // La app estaba cerrada y se abrió tocando la notificación.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpened(initialMessage);
    }

    // Suscripción para difusión desde la consola de Firebase.
    await _subscribeToBroadcastTopic();

    // Imprime el token de este dispositivo en los logs. Útil para enviar
    // "mensajes de prueba" dirigidos desde la consola de Firebase.
    try {
      final token = await _messaging.getToken();
      debugPrint('═══════════ FCM TOKEN ═══════════');
      debugPrint(token);
      debugPrint('═════════════════════════════════');
    } catch (e) {
      debugPrint('No se pudo obtener el token FCM: $e');
    }

    // Mantener el token sincronizado con el usuario autenticado.
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        unawaited(_syncToken(user.uid));
      }
    });
    _tokenRefreshSub = _messaging.onTokenRefresh.listen((token) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        unawaited(_saveTokenToFirestore(uid, token));
      }
    });
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Aquí se podría navegar según response.payload en el futuro.
        debugPrint('Notificación local tocada: ${response.payload}');
      },
    );

    const channel = AndroidNotificationChannel(
      _androidChannelId,
      'Notificaciones importantes',
      description: 'Canal usado para las notificaciones push de UBook.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'UBook';
    final body = notification?.body ?? message.data['body'] ?? '';

    // 1) Mostrar el banner del sistema (la app está en primer plano).
    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          'Notificaciones importantes',
          channelDescription:
              'Canal usado para las notificaciones push de UBook.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['route'] as String?,
    );

    // 2) Registrarla en la campanita local existente.
    await NotificationService.push(
      title: title,
      message: body,
      type: _typeFromData(message.data['type'] as String?),
    );
  }

  void _onMessageOpened(RemoteMessage message) {
    // Punto de extensión: navegar a una pantalla según message.data['route'].
    debugPrint('Notificación abierta: ${message.data}');
  }

  Future<void> _subscribeToBroadcastTopic() async {
    try {
      await _messaging.subscribeToTopic(_broadcastTopic);
    } catch (e) {
      debugPrint('No se pudo suscribir al topic "$_broadcastTopic": $e');
    }
  }

  Future<void> _syncToken(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(uid, token);
      }
    } catch (e) {
      debugPrint('No se pudo obtener el token FCM: $e');
    }
  }

  /// Guarda el token en `users/{uid}/fcmTokens/{token}` para poder enviar
  /// notificaciones dirigidas en el futuro (p. ej. con Cloud Functions).
  Future<void> _saveTokenToFirestore(String uid, String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('fcmTokens')
          .doc(token)
          .set({
            'token': token,
            'platform': Platform.isAndroid ? 'android' : 'other',
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint('No se pudo guardar el token FCM en Firestore: $e');
    }
  }

  /// Elimina el token del usuario en Firestore. Llamar al cerrar sesión para
  /// dejar de enviar push dirigidas a este dispositivo.
  Future<void> removeTokenForUser(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('fcmTokens')
          .doc(token)
          .delete();
    } catch (e) {
      debugPrint('No se pudo eliminar el token FCM: $e');
    }
  }

  NotificationType _typeFromData(String? raw) {
    return NotificationType.values.firstWhere(
      (t) => t.name == raw,
      orElse: () => NotificationType.other,
    );
  }

  void dispose() {
    _tokenRefreshSub?.cancel();
    _authSub?.cancel();
  }
}
