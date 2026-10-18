import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/deal_model.dart';

class DealRepository {
  final ApiClient _apiClient;

  DealRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<DealModel>> getDeals() async {
    final response = await _apiClient.get(ApiConstants.deals);
    if (response is List) {
      return response.map((item) => DealModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<DealModel> createDeal(DealModel deal) async {
    final response = await _apiClient.post(
      ApiConstants.deals,
      body: deal.toJson(),
    );
    if (response is Map<String, dynamic>) {
      // Also register or update customer record in /api/customers/
      try {
        await _apiClient.post(
          ApiConstants.customers,
          body: {
            'name': deal.customerName,
            'phone': deal.phoneNumber,
            'passport': deal.passportNumber,
            'source': 'Mobile App',
          },
        );
      } catch (_) {}
      return DealModel.fromJson(response);
    }
    return deal;
  }
}
