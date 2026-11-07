import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    await _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('musafly_current_user');
      if (userString != null && userString.isNotEmpty) {
        _currentUser = UserModel.fromJson(jsonDecode(userString));
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('musafly_current_user', jsonEncode(user.toJson()));
    } catch (_) {}
  }

  Future<bool> signInWithGoogle({
    required String email,
    required String name,
    String? photoUrl,
    String? googleId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _repository.authenticateGoogle(
        email: email,
        name: name,
        photoUrl: photoUrl,
        googleId: googleId,
      );

      if (user != null) {
        _currentUser = user;
        await _saveUser(user);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> signOut() async {
    _currentUser = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('musafly_current_user');
    } catch (_) {}
    notifyListeners();
  }
}

