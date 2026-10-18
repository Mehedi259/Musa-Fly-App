import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _usdFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static final NumberFormat _bdtFormat = NumberFormat.currency(
    symbol: '৳',
    decimalDigits: 0,
  );

  static final NumberFormat _omrFormat = NumberFormat.currency(
    symbol: 'OMR ',
    decimalDigits: 2,
  );

  static String formatUsd(dynamic amount) {
    if (amount == null) return '\$0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    return _usdFormat.format(val);
  }

  static String formatBdt(dynamic amount) {
    if (amount == null) return '৳0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    return _bdtFormat.format(val);
  }

  static String formatOmr(dynamic amount) {
    if (amount == null) return 'OMR 0.00';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    return _omrFormat.format(val);
  }

  static String formatSmart(dynamic amount, {String defaultCurrency = 'USD'}) {
    if (amount == null) return '\$0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    if (defaultCurrency.toUpperCase() == 'BDT' || val > 3000) {
      return _bdtFormat.format(val);
    }
    return _usdFormat.format(val);
  }

  // Convert USD to approximate BDT for display helper
  static String convertUsdToBdt(dynamic usdAmount) {
    if (usdAmount == null) return '';
    final val = double.tryParse(usdAmount.toString()) ?? 0.0;
    final bdt = val * 118.0; // standard approx rate
    return _bdtFormat.format(bdt);
  }
}
