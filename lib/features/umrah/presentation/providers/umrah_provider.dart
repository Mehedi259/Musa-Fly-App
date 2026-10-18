import 'package:flutter/material.dart';
import '../../data/models/umrah_model.dart';
import '../../data/repositories/umrah_repository.dart';

class UmrahProvider extends ChangeNotifier {
  final UmrahRepository _repository;

  UmrahProvider({UmrahRepository? repository})
      : _repository = repository ?? UmrahRepository();

  List<UmrahModel> _packages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UmrahModel> get packages => _packages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPackages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _packages = await _repository.getUmrahPackages();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
