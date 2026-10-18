import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _flightDateFormat = DateFormat('EEE, dd MMM yyyy');
  static final DateFormat _flightTimeFormat = DateFormat('hh:mm a');
  static final DateFormat _shortDate = DateFormat('dd MMM');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');

  static String formatFlightDate(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString()).toLocal();
      return _flightDateFormat.format(date);
    } catch (_) {
      return dateString.toString();
    }
  }

  static String formatFlightTime(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString()).toLocal();
      return _flightTimeFormat.format(date);
    } catch (_) {
      return dateString.toString();
    }
  }

  static String formatShortDate(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString()).toLocal();
      return _shortDate.format(date);
    } catch (_) {
      return dateString.toString();
    }
  }

  static String toIsoDate(DateTime date) {
    return _isoDate.format(date);
  }

  static String calculateDuration(dynamic startStr, dynamic endStr) {
    if (startStr == null || endStr == null) return '';
    try {
      final start = DateTime.parse(startStr.toString());
      final end = DateTime.parse(endStr.toString());
      final diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${minutes}m';
    } catch (_) {
      return '';
    }
  }
}
