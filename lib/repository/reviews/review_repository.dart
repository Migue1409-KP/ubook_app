import '../../model/reviews/review.dart';
import '../../model/reviews/review_entity_types.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  });

  Future<Review> createReview(Review review);
}

class InMemoryReviewRepository implements ReviewRepository {
  InMemoryReviewRepository._internal();

  static final InMemoryReviewRepository instance =
      InMemoryReviewRepository._internal();

  final List<Review> _reviews = <Review>[
    // Teacher dummies
    Review(
      id: 'REV-TEA-001',
      entityId: 'DUMMY-TCH',
      entityType: ReviewEntityTypes.teacher,
      userId: 'USR-001',
      rating: 5,
      title: 'Excelente profesor',
      content: 'Explica con ejemplos claros y siempre responde dudas en clase.',
      createdAt: DateTime(2026, 2, 11),
      updatedAt: DateTime(2026, 2, 11),
    ),
    Review(
      id: 'REV-TEA-002',
      entityId: 'TCH-001',
      entityType: ReviewEntityTypes.teacher,
      userId: 'USR-002',
      rating: 4,
      title: 'Muy buen dominio del tema',
      content: 'Buena metodologia y evaluaciones alineadas al contenido.',
      createdAt: DateTime(2026, 1, 28),
      updatedAt: DateTime(2026, 1, 28),
    ),
    Review(
      id: 'REV-TEA-003',
      entityId: 'TCH-002',
      entityType: ReviewEntityTypes.teacher,
      userId: 'USR-003',
      rating: 4,
      title: 'Clases dinamicas',
      content: 'Mantiene al grupo participando y comparte recursos utiles.',
      createdAt: DateTime(2026, 1, 15),
      updatedAt: DateTime(2026, 1, 15),
    ),

    // Subject dummies
    Review(
      id: 'REV-SUB-001',
      entityId: 'SUB-001',
      entityType: ReviewEntityTypes.subject,
      userId: 'USR-004',
      rating: 5,
      title: 'Materia muy completa',
      content: 'El contenido es retador y practico al mismo tiempo.',
      createdAt: DateTime(2026, 2, 5),
      updatedAt: DateTime(2026, 2, 5),
    ),
    Review(
      id: 'REV-SUB-002',
      entityId: 'SUB-002',
      entityType: ReviewEntityTypes.subject,
      userId: 'USR-005',
      rating: 4,
      title: 'Buena estructura',
      content: 'La materia esta bien organizada por unidades y objetivos.',
      createdAt: DateTime(2026, 1, 26),
      updatedAt: DateTime(2026, 1, 26),
    ),
    Review(
      id: 'REV-SUB-003',
      entityId: 'SUB-003',
      entityType: ReviewEntityTypes.subject,
      userId: 'USR-006',
      rating: 3,
      title: 'Interesante pero exigente',
      content: 'Requiere mucha practica fuera de clase.',
      createdAt: DateTime(2026, 1, 10),
      updatedAt: DateTime(2026, 1, 10),
    ),

    // Educational center dummies
    Review(
      id: 'REV-EDU-001',
      entityId: 'EDU-001',
      entityType: ReviewEntityTypes.educationalCenter,
      userId: 'USR-007',
      rating: 5,
      title: 'Excelente ambiente academico',
      content: 'Instalaciones cuidadas y buen acompañamiento estudiantil.',
      createdAt: DateTime(2026, 2, 9),
      updatedAt: DateTime(2026, 2, 9),
    ),
    Review(
      id: 'REV-EDU-002',
      entityId: 'EDU-002',
      entityType: ReviewEntityTypes.educationalCenter,
      userId: 'USR-008',
      rating: 4,
      title: 'Buen centro educativo',
      content: 'La oferta academica es amplia y los servicios funcionan bien.',
      createdAt: DateTime(2026, 1, 30),
      updatedAt: DateTime(2026, 1, 30),
    ),
    Review(
      id: 'REV-EDU-003',
      entityId: 'EDU-003',
      entityType: ReviewEntityTypes.educationalCenter,
      userId: 'USR-009',
      rating: 4,
      title: 'Recomendado',
      content: 'Buen nivel docente y actividades extracurriculares activas.',
      createdAt: DateTime(2026, 1, 12),
      updatedAt: DateTime(2026, 1, 12),
    ),

    // Career dummies
    Review(
      id: 'REV-CAR-001',
      entityId: 'CAR-001',
      entityType: ReviewEntityTypes.career,
      userId: 'USR-010',
      rating: 5,
      title: 'Carrera actualizada',
      content: 'Plan de estudio moderno y con enfoque en practica real.',
      createdAt: DateTime(2026, 2, 3),
      updatedAt: DateTime(2026, 2, 3),
    ),
    Review(
      id: 'REV-CAR-002',
      entityId: 'CAR-002',
      entityType: ReviewEntityTypes.career,
      userId: 'USR-011',
      rating: 4,
      title: 'Buena proyeccion laboral',
      content: 'Tiene materias claves para el mercado actual.',
      createdAt: DateTime(2026, 1, 24),
      updatedAt: DateTime(2026, 1, 24),
    ),
    Review(
      id: 'REV-CAR-003',
      entityId: 'CAR-003',
      entityType: ReviewEntityTypes.career,
      userId: 'USR-012',
      rating: 4,
      title: 'Buen enfoque academico',
      content: 'Combina teoria y practica de forma equilibrada.',
      createdAt: DateTime(2026, 1, 8),
      updatedAt: DateTime(2026, 1, 8),
    ),
  ];

  @override
  Future<List<Review>> getReviews({
    required String entityId,
    required String entityType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    // TODO: cuando se conecte backend, filtrar tambien por entityId.
    final reviews =
        _reviews
            .where((review) => review.entityType == entityType)
            .toList(growable: false)
          ..sort((a, b) {
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });

    return List<Review>.unmodifiable(reviews);
  }

  @override
  Future<Review> createReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _reviews.insert(0, review);
    return review;
  }
}
