class Review {
  final String id;
  final String entityId;
  final String entityType;
  final String userId;
  final int rating;
  final String title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const Review({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.userId,
    required this.rating,
    required this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_id': entityId,
      'entity_type': entityType,
      'user_id': userId,
      'rating': rating,
      'title': title,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  Review copyWith({
    String? id,
    String? entityId,
    String? entityType,
    String? userId,
    int? rating,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Review(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, entityType: $entityType, entityId: $entityId, userId: $userId, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
