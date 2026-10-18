import 'package:flutter/material.dart';
import '../../data/models/faq_model.dart';
import '../../data/models/testimonial_model.dart';
import '../../data/repositories/support_repository.dart';

class SupportProvider extends ChangeNotifier {
  final SupportRepository _repository;

  SupportProvider({SupportRepository? repository})
      : _repository = repository ?? SupportRepository();

  List<FaqModel> _faqs = [];
  List<TestimonialModel> _testimonials = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'all';

  List<FaqModel> get faqs => _faqs;
  List<TestimonialModel> get testimonials => _testimonials;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchSupportData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getFaqs(),
        _repository.getTestimonials(),
      ]);
      _faqs = results[0] as List<FaqModel>;
      _testimonials = results[1] as List<TestimonialModel>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
