import '../../model/notification/notification_model.dart';

// La app arranca sin seed. Las notificaciones se generan desde eventos reales
// (registrar docente, crear asignatura, crear reseña, etc.) via NotificationService.
List<NotificationModel> buildDefaultNotificationSeed() => [];
