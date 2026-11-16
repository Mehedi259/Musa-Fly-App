import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _bdtFormat = NumberFormat.currency(
    symbol: '৳',
    decimalDigits: 0,
  );

  static final NumberFormat _integerFormat = NumberFormat('#,##0');
  static final NumberFormat _decimalFormat = NumberFormat('#,##0.00');

  /// Converts English numeric digits (0-9) to standard Bengali digits (০-৯).
  static String toBanglaDigits(String input) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var result = input;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(en[i], bn[i]);
    }
    return result;
  }

  /// Primary formatter for Omani Rial (OMR).
  /// Integers format as 'OMR 125', decimals format as 'OMR 85.50'.
  static String formatOmr(dynamic amount, {bool banglaDigits = false}) {
    if (amount == null) return banglaDigits ? 'OMR ০' : 'OMR 0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    String formatted;
    if (val % 1 == 0) {
      formatted = _integerFormat.format(val.toInt());
    } else {
      formatted = _decimalFormat.format(val);
    }
    if (banglaDigits) {
      formatted = toBanglaDigits(formatted);
    }
    return 'OMR $formatted';
  }

  /// Formats with BDT currency symbol (৳).
  static String formatBdt(dynamic amount, {bool banglaDigits = false}) {
    if (amount == null) return banglaDigits ? '৳০' : '৳0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    final formatted = _bdtFormat.format(val);
    return banglaDigits ? toBanglaDigits(formatted) : formatted;
  }

  /// Convert OMR amount to approximate Bangladeshi Taka (BDT).
  /// Exchange rate: 1 OMR ≈ 315 BDT.
  static String convertOmrToBdt(dynamic omrAmount, {bool banglaDigits = false}) {
    if (omrAmount == null) return '';
    final val = double.tryParse(omrAmount.toString()) ?? 0.0;
    final bdt = val * 315.0;
    final formatted = '৳${_integerFormat.format(bdt.round())}';
    return banglaDigits ? toBanglaDigits(formatted) : formatted;
  }

  /// Primary smart formatter across the MusaFly app.
  /// Defaults to OMR (Omani Rial).
  static String formatSmart(
    dynamic amount, {
    String defaultCurrency = 'OMR',
    bool banglaDigits = false,
  }) {
    if (amount == null) return banglaDigits ? 'OMR ০' : 'OMR 0';
    final val = double.tryParse(amount.toString()) ?? 0.0;
    if (defaultCurrency.toUpperCase() == 'BDT') {
      return formatBdt(val, banglaDigits: banglaDigits);
    }
    return formatOmr(val, banglaDigits: banglaDigits);
  }

  /// Backward compatibility shims
  static String formatUsd(dynamic amount) => formatOmr(amount);
  static String convertUsdToBdt(dynamic usdAmount, {bool banglaDigits = false}) =>
      convertOmrToBdt(usdAmount, banglaDigits: banglaDigits);
}
