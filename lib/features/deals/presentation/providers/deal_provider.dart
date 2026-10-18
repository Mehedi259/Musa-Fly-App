import 'package:flutter/material.dart';
import '../../data/models/deal_model.dart';
import '../../data/repositories/deal_repository.dart';

class DealProvider extends ChangeNotifier {
  final DealRepository _repository;

  DealProvider({DealRepository? repository})
      : _repository = repository ?? DealRepository();

  List<DealModel> _deals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DealModel> get deals => _deals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDeals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _deals = await _repository.getDeals();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createBookingDeal(DealModel deal) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await _repository.createDeal(deal);
      _deals.insert(0, created);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
