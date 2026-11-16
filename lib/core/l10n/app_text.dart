import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'app_locale.dart';
import 'strings_common.dart';
import '../../features/home/presentation/home_strings.dart';
import '../../features/flights/presentation/flights_strings.dart';
import '../../features/tours/presentation/journeys_strings.dart';
import '../../features/deals/presentation/services_strings.dart';

/// Every string table in the app, merged in order. Feature tables are kept
/// in their own files so separate pieces of work never edit the same map.
final Map<String, String> _en = {
  ...commonEn,
  ...homeEn,
  ...flightsEn,
  ...servicesEn,
  ...journeysEn,
};

final Map<String, String> _bn = {
  ...commonBn,
  ...homeBn,
  ...flightsBn,
  ...servicesBn,
  ...journeysBn,
};

/// Looks a key up in the active language, falling back to English and then to
/// the key itself, so a missing translation shows something readable rather
/// than blowing up.
String translate(String key, AppLanguage language) {
  final table = language == AppLanguage.bangla ? _bn : _en;
  return table[key] ?? _en[key] ?? key;
}

extension AppTextX on BuildContext {
  /// `context.tr('home.greeting')`
  String tr(String key) {
    try {
      return translate(key, watch<LocaleProvider>().language);
    } catch (_) {
      return translate(key, read<LocaleProvider>().language);
    }
  }

  /// Reads the language without subscribing — for callbacks and one-off reads.
  String trOnce(String key) => translate(key, read<LocaleProvider>().language);

  /// Picks between two literals when a string is too local to deserve a key.
  String pick(String english, String bangla) {
    try {
      return watch<LocaleProvider>().isBangla ? bangla : english;
    } catch (_) {
      return read<LocaleProvider>().isBangla ? bangla : english;
    }
  }

  String pickOnce(String english, String bangla) =>
      read<LocaleProvider>().isBangla ? bangla : english;

  bool get isBangla {
    try {
      return watch<LocaleProvider>().isBangla;
    } catch (_) {
      return read<LocaleProvider>().isBangla;
    }
  }
}
