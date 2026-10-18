import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/faq_model.dart';
import '../models/testimonial_model.dart';

class SupportRepository {
  final ApiClient _apiClient;

  SupportRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiClient.get(ApiConstants.faqs);
    if (response is List) {
      return response.map((item) => FaqModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<TestimonialModel>> getTestimonials() async {
    final response = await _apiClient.get(ApiConstants.testimonials);
    if (response is List) {
      return response.map((item) => TestimonialModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
