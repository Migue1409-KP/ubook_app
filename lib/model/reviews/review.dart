import 'dart:convert';

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
  final String? metadataJson;

  Review({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.userId,
    required this.rating,
    required this.title,
    this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    int? createdAtMs,
    int? updatedAtMs,
    String? metadataJson,
  }) : createdAtMs = createdAtMs ?? createdAt?.millisecondsSinceEpoch,
       updatedAtMs = updatedAtMs ?? updatedAt?.millisecondsSinceEpoch,
       metadataJson = metadataJson ?? _encodeMetadata(metadata);

  DateTime? get createdAt => createdAtMs == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(createdAtMs!);

  DateTime? get updatedAt => updatedAtMs == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(updatedAtMs!);

  @ignore
  Map<String, dynamic>? get metadata => _decodeMetadata(metadataJson);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      userId: json['user_id'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAt: _readDate(json['created_at']),
      updatedAt: _readDate(json['updated_at']),
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

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }

  static String? _encodeMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata.isEmpty) return null;
    return jsonEncode(metadata);
  }

  static Map<String, dynamic>? _decodeMetadata(String? metadataJson) {
    if (metadataJson == null || metadataJson.isEmpty) return null;
    final decoded = jsonDecode(metadataJson);
    return decoded is Map<String, dynamic> ? decoded : null;
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
