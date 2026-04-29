import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(tableName: 'reviews')
@immutable
class Review {
  @PrimaryKey()
  final String id;

  final String entityId;
  final String entityType;
  final String userId;
  final int rating;
  final String title;
  final String? content;
  final int? createdAtMs;
  final int? updatedAtMs;
  final String? metadata;

  const Review({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.userId,
    required this.rating,
    required this.title,
    this.content,
    this.createdAtMs,
    this.updatedAtMs,
    this.metadata,
  });

  DateTime? get createdAt =>
      createdAtMs == null ? null : DateTime.fromMillisecondsSinceEpoch(createdAtMs!);

  DateTime? get updatedAt =>
      updatedAtMs == null ? null : DateTime.fromMillisecondsSinceEpoch(updatedAtMs!);

  factory Review.fromJson(Map<String, dynamic> json) {
    var createdAtValue = json['created_at'];
    var updatedAtValue = json['updated_at'];
    
    int? createdAtMs;
    int? updatedAtMs;
    
    if (createdAtValue != null) {
        createdAtMs = createdAtValue is String
          ? DateTime.parse(createdAtValue).millisecondsSinceEpoch
          : (createdAtValue as DateTime).millisecondsSinceEpoch;
    }
    
    if (updatedAtValue != null) {
        updatedAtMs = updatedAtValue is String
          ? DateTime.parse(updatedAtValue).millisecondsSinceEpoch
          : (updatedAtValue as DateTime).millisecondsSinceEpoch;
    }
    
    return Review(
      id: json['id'] as String,
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAtMs: createdAtMs,
      updatedAtMs: updatedAtMs,
      metadata: json['metadata'] as String?,
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
    int? createdAtMs,
    int? updatedAtMs,
    String? metadata,
  }) {
    return Review(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.entityId == entityId &&
        other.entityType == entityType &&
        other.userId == userId &&
        other.rating == rating &&
        other.title == title &&
        other.content == content &&
        other.createdAtMs == createdAtMs &&
        other.updatedAtMs == updatedAtMs &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        entityId.hashCode ^
        entityType.hashCode ^
        userId.hashCode ^
        rating.hashCode ^
        title.hashCode ^
        content.hashCode ^
        createdAtMs.hashCode ^
        updatedAtMs.hashCode ^
        metadata.hashCode;
  }

  @override
  String toString() {
    return 'Review(id: $id, entityId: $entityId, entityType: $entityType, userId: $userId, rating: $rating, title: $title, content: $content, createdAtMs: $createdAtMs, updatedAtMs: $updatedAtMs, metadata: $metadata)';
  }
}
