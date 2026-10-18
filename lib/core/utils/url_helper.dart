import 'dart:developer' as developer;
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_strings.dart';

class UrlHelper {
  static Future<bool> launchWhatsApp({String? customMessage}) async {
    final text = customMessage ??
        "Hello MusaFly! I'd like to get more information about your travel services.";
    final uri = Uri.parse(
      'https://wa.me/${AppStrings.rawPhoneNumber}?text=${Uri.encodeComponent(text)}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      developer.log('Error launching WhatsApp: $e', name: 'UrlHelper');
      return false;
    }
  }

  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(' ', '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      developer.log('Error making phone call: $e', name: 'UrlHelper');
      return false;
    }
  }

  static Future<bool> sendEmail(String email, {String? subject, String? body}) async {
    final Map<String, String> queryParams = {};
    if (subject != null) queryParams['subject'] = subject;
    if (body != null) queryParams['body'] = body;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      developer.log('Error sending email: $e', name: 'UrlHelper');
      return false;
    }
  }

  static Future<bool> openWeb(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      developer.log('Error opening web: $e', name: 'UrlHelper');
      return false;
    }
  }
}
