import '../../../core/constants/api_constants.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String? image;
  final String badgeText;
  final String targetType;
  final String? targetId;
  final String? externalLink;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.image,
    required this.badgeText,
    required this.targetType,
    this.targetId,
    this.externalLink,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      image: ApiConstants.formatImageUrl(json['image'] as String?),
      badgeText: json['badge_text'] as String? ?? 'বিশেষ অফার',
      targetType: json['target_type'] as String? ?? 'all',
      targetId: json['target_id']?.toString(),
      externalLink: json['external_link'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'image': image,
      'badge_text': badgeText,
      'target_type': targetType,
      'target_id': targetId,
      'external_link': externalLink,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

