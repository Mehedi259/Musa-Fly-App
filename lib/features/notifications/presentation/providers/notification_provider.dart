import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/notification_repository.dart';
import '../../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepository _repository;

  NotificationProvider({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  Set<int> _readIds = {};

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !_readIds.contains(n.id)).length;

  Future<void> init() async {
    await _loadReadIds();
    await fetchNotifications();
  }

  Future<void> _loadReadIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList('read_notification_ids') ?? [];
      _readIds = savedList.map((e) => int.tryParse(e) ?? 0).where((id) => id > 0).toSet();
    } catch (_) {}
  }

  Future<void> _saveReadIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'read_notification_ids',
        _readIds.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _repository.getNotifications();
      _notifications = list;
      for (var n in _notifications) {
        n.isRead = _readIds.contains(n.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(int id) {
    if (!_readIds.contains(id)) {
      _readIds.add(id);
      for (var n in _notifications) {
        if (n.id == id) {
          n.isRead = true;
          break;
        }
      }
      _saveReadIds();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      _readIds.add(n.id);
      n.isRead = true;
    }
    _saveReadIds();
    notifyListeners();
  }

  Future<bool> registerDevice(String token, {String? email}) async {
    return await _repository.registerDeviceToken(token: token, email: email);
  }
}

