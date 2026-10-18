import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/umrah_model.dart';

class UmrahRepository {
  final ApiClient _apiClient;

  UmrahRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<UmrahModel>> getUmrahPackages() async {
    final response = await _apiClient.get(ApiConstants.umrah);
    if (response is List) {
      return response.map((item) => UmrahModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
