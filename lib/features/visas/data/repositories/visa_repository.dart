import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/visa_model.dart';

class VisaRepository {
  final ApiClient _apiClient;

  VisaRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<VisaModel>> getVisas() async {
    final response = await _apiClient.get(ApiConstants.visas);
    if (response is List) {
      return response.map((item) => VisaModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
