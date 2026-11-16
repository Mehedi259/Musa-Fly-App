import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two languages MusaFly ships in.
enum AppLanguage {
  english('en', 'English', 'English'),
  bangla('bn', 'বাংলা', 'Bangla');

  const AppLanguage(this.code, this.nativeName, this.englishName);

  final String code;

  /// Name written in the language itself — what the picker shows.
  final String nativeName;

  final String englishName;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) =>
      AppLanguage.values.firstWhere((l) => l.code == code, orElse: () => AppLanguage.english);
}

/// Holds the chosen language and whether the picker has been answered yet.
class LocaleProvider extends ChangeNotifier {
  static const _langKey = 'app_language_code';
  static const _pickedKey = 'app_language_chosen';

  AppLanguage _language = AppLanguage.english;
  bool _hasChosen = false;
  bool _ready = false;

  AppLanguage get language => _language;
  bool get hasChosen => _hasChosen;
  bool get isReady => _ready;
  bool get isBangla => _language == AppLanguage.bangla;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _language = AppLanguage.fromCode(prefs.getString(_langKey));
      _hasChosen = prefs.getBool(_pickedKey) ?? false;
    } catch (_) {
      // First run on a device with no storage access — fall back to English.
      _language = AppLanguage.english;
      _hasChosen = false;
    }
    _ready = true;
    notifyListeners();
  }

  Future<void> select(AppLanguage language, {bool markChosen = true}) async {
    _language = language;
    if (markChosen) _hasChosen = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_langKey, language.code);
      if (markChosen) await prefs.setBool(_pickedKey, true);
    } catch (_) {
      // Preference won't persist; the in-memory choice still applies.
    }
  }
}
