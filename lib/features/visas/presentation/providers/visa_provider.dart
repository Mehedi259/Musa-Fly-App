import 'package:flutter/material.dart';
import '../../data/models/visa_model.dart';
import '../../data/repositories/visa_repository.dart';

class VisaProvider extends ChangeNotifier {
  final VisaRepository _repository;

  VisaProvider({VisaRepository? repository})
      : _repository = repository ?? VisaRepository();

  List<VisaModel> _visas = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  List<VisaModel> get visas => _visas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  Future<void> fetchVisas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _visas = await _repository.getVisas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
