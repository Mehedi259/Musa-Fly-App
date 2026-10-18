import 'package:flutter/material.dart';
import '../../data/models/tour_model.dart';
import '../../data/repositories/tour_repository.dart';

class TourProvider extends ChangeNotifier {
  final TourRepository _repository;

  TourProvider({TourRepository? repository})
      : _repository = repository ?? TourRepository();

  List<TourModel> _tours = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TourModel> get tours => _tours;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTours() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tours = await _repository.getTours();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
