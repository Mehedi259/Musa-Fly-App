import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/flight_model.dart';

class FlightRepository {
  final ApiClient _apiClient;

  FlightRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<FlightModel>> getFlights() async {
    final response = await _apiClient.get(ApiConstants.flights);
    if (response is List) {
      return response.map((item) => FlightModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<FlightModel>> searchFlights({
    String? origin,
    String? destination,
    DateTime? date,
  }) async {
    final allFlights = await getFlights();
    return allFlights.where((flight) {
      bool matchesOrigin = true;
      bool matchesDest = true;
      if (origin != null && origin.isNotEmpty) {
        matchesOrigin = flight.origin.toLowerCase().contains(origin.toLowerCase()) ||
            flight.originCode.toLowerCase() == origin.toLowerCase();
      }
      if (destination != null && destination.isNotEmpty) {
        matchesDest = flight.destination.toLowerCase().contains(destination.toLowerCase()) ||
            flight.destinationCode.toLowerCase() == destination.toLowerCase();
      }
      return matchesOrigin && matchesDest;
    }).toList();
  }
}
