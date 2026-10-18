import 'package:flutter/material.dart';
import '../../data/models/flight_model.dart';
import '../../data/repositories/flight_repository.dart';

enum FlightSearchTripType { oneWay, roundTrip }

class FlightProvider extends ChangeNotifier {
  final FlightRepository _repository;

  FlightProvider({FlightRepository? repository})
      : _repository = repository ?? FlightRepository();

  List<FlightModel> _flights = [];
  List<FlightModel> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Search Form State
  String _originCode = 'DAC';
  String _originCity = 'Dhaka';
  String _destCode = 'DXB';
  String _destCity = 'Dubai';
  DateTime _departureDate = DateTime.now().add(const Duration(days: 3));
  DateTime? _returnDate = DateTime.now().add(const Duration(days: 10));
  int _passengers = 1;
  FlightSearchTripType _tripType = FlightSearchTripType.oneWay;
  String _travelClass = 'Economy';

  // Getters
  List<FlightModel> get flights => _flights;
  List<FlightModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get originCode => _originCode;
  String get originCity => _originCity;
  String get destCode => _destCode;
  String get destCity => _destCity;
  DateTime get departureDate => _departureDate;
  DateTime? get returnDate => _returnDate;
  int get passengers => _passengers;
  FlightSearchTripType get tripType => _tripType;
  String get travelClass => _travelClass;

  void setOrigin(String code, String city) {
    _originCode = code;
    _originCity = city;
    notifyListeners();
  }

  void setDestination(String code, String city) {
    _destCode = code;
    _destCity = city;
    notifyListeners();
  }

  void swapAirports() {
    final tempCode = _originCode;
    final tempCity = _originCity;
    _originCode = _destCode;
    _originCity = _destCity;
    _destCode = tempCode;
    _destCity = tempCity;
    notifyListeners();
  }

  void setDepartureDate(DateTime date) {
    _departureDate = date;
    if (_returnDate != null && _returnDate!.isBefore(_departureDate)) {
      _returnDate = _departureDate.add(const Duration(days: 7));
    }
    notifyListeners();
  }

  void setReturnDate(DateTime? date) {
    _returnDate = date;
    notifyListeners();
  }

  void setPassengers(int count) {
    if (count >= 1 && count <= 9) {
      _passengers = count;
      notifyListeners();
    }
  }

  void setTripType(FlightSearchTripType type) {
    _tripType = type;
    notifyListeners();
  }

  void setTravelClass(String travelClass) {
    _travelClass = travelClass;
    notifyListeners();
  }

  Future<void> fetchFlights() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _flights = await _repository.getFlights();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> executeSearch() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchFlights(
        origin: _originCode,
        destination: _destCode,
        date: _departureDate,
      );
      // If direct match is empty, show all available flights as recommendations
      if (_searchResults.isEmpty && _flights.isNotEmpty) {
        _searchResults = List.from(_flights);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
