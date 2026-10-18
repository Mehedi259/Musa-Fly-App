import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/tour_model.dart';

class TourRepository {
  final ApiClient _apiClient;

  TourRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<TourModel>> getTours() async {
    final response = await _apiClient.get(ApiConstants.tours);
    if (response is List) {
      return response.map((item) => TourModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
