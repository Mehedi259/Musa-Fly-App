import 'dart:io';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.notifications);
    if (response is List) {
      return response
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<bool> registerDeviceToken({
    required String token,
    String? email,
    String? platform,
  }) async {
    try {
      final actualPlatform = platform ?? (Platform.isIOS ? 'ios' : 'android');
      await _apiClient.post(
        ApiConstants.registerDevice,
        body: {
          'token': token,
          'platform': actualPlatform,
          if (email != null && email.isNotEmpty) 'user_email': email,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}

