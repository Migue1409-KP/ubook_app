/// Constantes de Firebase para acceso a Firestore y Storage
class FirebaseConstants {
  FirebaseConstants._();

  // Firestore Collections
  static const String subjectsCollection = 'subjects';
  static const String reviewsCollection = 'reviews';
  static const String usersCollection = 'users';
  static const String attachmentsCollection = 'attachments';
  static const String processesCollection = 'processes';

  // Firebase Storage Paths
  static const String subjectsBasePath = 'subjects';
  static const String syllabusPath = 'syllabi';
  static const String attachmentsPath = 'attachments';
  static const String usersPath = 'users';
  static const String avatarsPath = 'avatars';

  // Firestore Document Fields
  static const String idField = 'id';
  static const String nameField = 'name';
  static const String emailField = 'email';
  static const String lastUpdateField = 'last_update';
  static const String isSyncField = 'is_sync';
  static const String createdAtField = 'created_at';
  static const String updatedAtField = 'updated_at';
  static const String userIdField = 'user_id';
  static const String entityIdField = 'entity_id';
  static const String entityTypeField = 'entity_type';
}
