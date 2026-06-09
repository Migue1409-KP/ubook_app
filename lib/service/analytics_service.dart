import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;

  FirebaseAnalytics? get _analyticsOrNull {
    if (Firebase.apps.isEmpty) return null;
    return _analytics ??= FirebaseAnalytics.instance;
  }

  FirebaseAnalyticsObserver? get observer {
    final analytics = _analyticsOrNull;
    if (analytics == null) return null;
    return _observer ??= FirebaseAnalyticsObserver(analytics: analytics);
  }

  Future<void> setCurrentUser(User? user) async {
    final analytics = _analyticsOrNull;
    if (analytics == null) return;
    await analytics.setUserId(id: user?.uid);
    await analytics.setUserProperty(
      name: 'auth_state',
      value: user == null ? 'signed_out' : 'signed_in',
    );
  }

  Future<void> logScreen(String screenName) {
    final analytics = _analyticsOrNull;
    if (analytics == null) return Future.value();
    return analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  Future<void> logLogin({required String method}) {
    return _logEvent('login_success', {'method': method});
  }

  Future<void> logRegister({required String method}) {
    return _logEvent('register_success', {'method': method});
  }

  Future<void> logLogout() {
    return _logEvent('logout');
  }

  Future<void> logMenuSelection(String item) {
    return _logEvent('menu_item_selected', {'item': item});
  }

  Future<void> logDashboardAction({
    required String action,
    required String target,
  }) {
    return _logEvent('dashboard_card_opened', {
      'action': action,
      'target': target,
    });
  }

  Future<void> logTeacherSaved({
    required bool isEditing,
    required int subjectCount,
    required bool isActive,
  }) {
    return _logEvent(isEditing ? 'teacher_updated' : 'teacher_created', {
      'subject_count': subjectCount,
      'is_active': isActive,
    });
  }

  Future<void> logTeacherDeleted() {
    return _logEvent('teacher_deleted');
  }

  Future<void> logSubjectCreated({
    required int credits,
    required int prerequisiteCount,
  }) {
    return _logEvent('subject_created', {
      'credits': credits,
      'prerequisite_count': prerequisiteCount,
    });
  }

  Future<void> logSubjectUpdated({
    required int credits,
    required int prerequisiteCount,
  }) {
    return _logEvent('subject_updated', {
      'credits': credits,
      'prerequisite_count': prerequisiteCount,
    });
  }

  Future<void> logSubjectDeleted() {
    return _logEvent('subject_deleted');
  }

  Future<void> logCareerCreated({
    required int semesters,
    required int credits,
    int? modalityId,
  }) {
    return _logEvent('career_created', {
      'semesters': semesters,
      'credits': credits,
      'modality_id': modalityId,
    });
  }

  Future<void> logCareerUpdated({
    required int semesters,
    required int credits,
    int? modalityId,
  }) {
    return _logEvent('career_updated', {
      'semesters': semesters,
      'credits': credits,
      'modality_id': modalityId,
    });
  }

  Future<void> logCareerDeleted() {
    return _logEvent('career_deleted');
  }

  Future<void> logPqrsCreated({required String tipo, required String estado}) {
    return _logEvent('pqrs_created', {'type': tipo, 'status': estado});
  }

  Future<void> logPqrsUpdated({required String tipo, required String estado}) {
    return _logEvent('pqrs_updated', {'type': tipo, 'status': estado});
  }

  Future<void> logPqrsStatusChanged(String estado) {
    return _logEvent('pqrs_status_changed', {'status': estado});
  }

  Future<void> logProcessCreated({
    required String processType,
    required bool isActive,
    required int requiredDocumentCount,
  }) {
    return _logEvent('process_created', {
      'process_type': processType,
      'is_active': isActive,
      'required_document_count': requiredDocumentCount,
    });
  }

  Future<void> logProcessUpdated({
    required String processType,
    required bool isActive,
    required int requiredDocumentCount,
  }) {
    return _logEvent('process_updated', {
      'process_type': processType,
      'is_active': isActive,
      'required_document_count': requiredDocumentCount,
    });
  }

  Future<void> logProcessDeleted({required String processType}) {
    return _logEvent('process_deleted', {'process_type': processType});
  }

  Future<void> logProcessRestored({required String processType}) {
    return _logEvent('process_restored', {'process_type': processType});
  }

  Future<void> logAttachmentUploaded({
    required String fileType,
    int? fileSize,
  }) {
    return _logEvent('attachment_uploaded', {
      'file_type': fileType,
      'file_size': fileSize,
    });
  }

  Future<void> logAttachmentOpened({
    required String fileType,
    required String storage,
  }) {
    return _logEvent('attachment_opened', {
      'file_type': fileType,
      'storage': storage,
    });
  }

  Future<void> logAttachmentDeleted({required String fileType}) {
    return _logEvent('attachment_deleted', {'file_type': fileType});
  }

  Future<void> logNotificationCreated({
    required String type,
    required String status,
  }) {
    return _logEvent('notification_created', {'type': type, 'status': status});
  }

  Future<void> logNotificationRead({required String type}) {
    return _logEvent('notification_read', {'type': type});
  }

  Future<void> logNotificationsMarkedRead({required int count}) {
    return _logEvent('notifications_marked_read', {'count': count});
  }

  Future<void> logReviewCreated({
    required String entityType,
    required int rating,
  }) {
    return _logEvent('review_created', {
      'entity_type': entityType,
      'rating': rating,
    });
  }

  Future<void> logSubjectTeacherAssigned({required String source}) {
    return _logEvent('subject_teacher_assigned', {'source': source});
  }

  Future<void> logSubjectTeacherRemoved({required String source}) {
    return _logEvent('subject_teacher_removed', {'source': source});
  }

  Future<void> _logEvent(
    String name, [
    Map<String, Object?> parameters = const {},
  ]) {
    final analytics = _analyticsOrNull;
    if (analytics == null) return Future.value();

    final cleanParameters = <String, Object>{};
    for (final entry in parameters.entries) {
      final value = entry.value;
      if (value == null) continue;
      cleanParameters[entry.key] = switch (value) {
        String() || num() => value,
        bool() => value ? 'true' : 'false',
        _ => value.toString(),
      };
    }

    return analytics.logEvent(
      name: name,
      parameters: cleanParameters.isEmpty ? null : cleanParameters,
    );
  }
}
