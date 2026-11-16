import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/currency_formatter.dart';
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
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _baggage = '30 KG';
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
  int get passengers => _adults + _children + _infants;
  int get adults => _adults;
  int get children => _children;
  int get infants => _infants;
  String get baggage => _baggage;
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
      _adults = count;
      _children = 0;
      _infants = 0;
      notifyListeners();
    }
  }

  void setTravelers({required int adults, int children = 0, int infants = 0}) {
    _adults = adults < 1 ? 1 : adults;
    _children = children < 0 ? 0 : children;
    _infants = infants < 0 ? 0 : infants;
    notifyListeners();
  }

  void setBaggage(String baggage) {
    _baggage = baggage;
    notifyListeners();
  }

  String buildWhatsAppMessage({
    String? airline,
    String? price,
    bool isBangla = false,
  }) {
    if (isBangla) {
      final tripLabel = _tripType == FlightSearchTripType.roundTrip
          ? 'রাউন্ড ট্রিপ (যাওয়া-আসা)'
          : 'ওয়ান ওয়ে (একমুখী)';

      const bnMonths = [
        '',
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর',
      ];

      final depDayBn = CurrencyFormatter.toBanglaDigits(_departureDate.day.toString());
      final depYearBn = CurrencyFormatter.toBanglaDigits(_departureDate.year.toString());
      final depDateStr = '$depDayBn ${bnMonths[_departureDate.month]} $depYearBn';

      String? retDateStr;
      if (_returnDate != null) {
        final retDayBn = CurrencyFormatter.toBanglaDigits(_returnDate!.day.toString());
        final retYearBn = CurrencyFormatter.toBanglaDigits(_returnDate!.year.toString());
        retDateStr = '$retDayBn ${bnMonths[_returnDate!.month]} $retYearBn';
      }

      final travelersParts = <String>[];
      if (_adults > 0) {
        travelersParts.add('${CurrencyFormatter.toBanglaDigits(_adults.toString())} জন প্রাপ্তবয়স্ক');
      }
      if (_children > 0) {
        travelersParts.add('${CurrencyFormatter.toBanglaDigits(_children.toString())} জন শিশু');
      }
      if (_infants > 0) {
        travelersParts.add('${CurrencyFormatter.toBanglaDigits(_infants.toString())} জন নবজাতক');
      }
      final travelersStr = travelersParts.join(', ');

      final baggageBn = CurrencyFormatter.toBanglaDigits(_baggage)
          .replaceAll('KG', 'কেজি')
          .replaceAll('kg', 'কেজি');

      final classBn = _travelClass.toLowerCase() == 'business'
          ? 'বিজনেস'
          : (_travelClass.toLowerCase() == 'first' ? 'ফার্স্ট ক্লাস' : 'ইকোনমি');

      final originBn = _cityBangla(_originCity);
      final destBn = _cityBangla(_destCity);

      final buffer = StringBuffer();
      buffer.writeln('✈️ *মুসাফ্লাই - ফ্লাইট বুকিং অনুসন্ধান*');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('• *রুট:* $originBn ($_originCode) ➔ $destBn ($_destCode)');
      buffer.writeln('• *যাত্রার ধরন:* $tripLabel');
      buffer.writeln('• *যাত্রার তারিখ:* $depDateStr');
      if (_tripType == FlightSearchTripType.roundTrip && retDateStr != null) {
        buffer.writeln('• *ফেরার তারিখ:* $retDateStr');
      }
      buffer.writeln('• *যাত্রী সংখ্যা:* $travelersStr');
      buffer.writeln('• *লাগেজ:* $baggageBn');
      buffer.writeln('• *কেবিন ক্লাস:* $classBn');
      if (airline != null && airline.isNotEmpty) {
        buffer.writeln('• *পছন্দের এয়ারলাইন:* $airline');
      }
      if (price != null && price.isNotEmpty) {
        buffer.writeln('• *আনুমানিক ভাড়া:* $price');
      }
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('অনুগ্রহ করে বর্তমান সিট প্রাপ্যতা ও সেরা ভাড়ার রেটটি জানান। ধন্যবাদ!');
      return buffer.toString();
    }

    // Default English
    final tripLabel = _tripType == FlightSearchTripType.roundTrip ? 'Round Trip' : 'One Way';
    final depDateStr = DateFormat('dd MMM yyyy').format(_departureDate);
    final retDateStr = _returnDate != null ? DateFormat('dd MMM yyyy').format(_returnDate!) : 'N/A';

    final buffer = StringBuffer();
    buffer.writeln('✈️ *MusaFly Flight Booking Inquiry*');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('• *Route:* $_originCity ($_originCode) ➔ $_destCity ($_destCode)');
    buffer.writeln('• *Trip Type:* $tripLabel');
    buffer.writeln('• *Departure:* $depDateStr');
    if (_tripType == FlightSearchTripType.roundTrip) {
      buffer.writeln('• *Return:* $retDateStr');
    }
    buffer.writeln('• *Travelers:* $_adults Adult(s)${_children > 0 ? ', $_children Child(ren)' : ''}${_infants > 0 ? ', $_infants Infant(s)' : ''}');
    buffer.writeln('• *Baggage:* $_baggage');
    buffer.writeln('• *Cabin Class:* $_travelClass');
    if (airline != null && airline.isNotEmpty) {
      buffer.writeln('• *Preferred Airline:* $airline');
    }
    if (price != null && price.isNotEmpty) {
      buffer.writeln('• *Estimated Fare:* $price');
    }
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Please check seat availability and share the best fare rates. Thank you!');
    return buffer.toString();
  }

  String _cityBangla(String city) {
    switch (city.toLowerCase().trim()) {
      case 'dhaka': return 'ঢাকা';
      case 'dubai': return 'দুবাই';
      case 'muscat': return 'মাস্কাট';
      case 'chittagong': return 'চট্টগ্রাম';
      case 'sylhet': return 'সিলেট';
      case "cox's bazar": return 'কক্সবাজার';
      case 'salalah': return 'সালালাহ';
      case 'jeddah': return 'জেদ্দা';
      case 'medina': return 'মদিনা';
      case 'doha': return 'দোহা';
      case 'sharjah': return 'শারজাহ';
      default: return city;
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
