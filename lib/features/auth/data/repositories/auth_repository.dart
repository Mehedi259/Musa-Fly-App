import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<UserModel?> authenticateGoogle({
    required String email,
    required String name,
    String? photoUrl,
    String? googleId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.googleAuth,
      body: {
        'email': email,
        'name': name,
        'photo_url': photoUrl ?? '',
        'google_id': googleId ?? '',
      },
    );

    if (response is Map<String, dynamic> && response['user'] != null) {
      return UserModel.fromJson(response['user'] as Map<String, dynamic>);
    }
    return null;
  }
}

