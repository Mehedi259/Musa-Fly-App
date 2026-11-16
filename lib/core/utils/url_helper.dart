import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_strings.dart';
import '../l10n/app_text.dart';

class UrlHelper {
  /// Robust WhatsApp launcher with 4-tier fallbacks:
  /// 1. Direct native WhatsApp app URI (whatsapp://send?phone=...)
  /// 2. Direct launch without canLaunchUrl check (bypasses Android 11+ package visibility blocks)
  /// 3. Universal wa.me web link (https://wa.me/...)
  /// 4. api.whatsapp.com fallback
  static Future<bool> launchWhatsApp({String? customMessage, BuildContext? context}) async {
    final isBn = context != null && context.isBangla;
    final text = customMessage ??
        (isBn
            ? "আসসালামু আলাইকুম মুসাফ্লাই! আপনাদের ট্রাভেল সার্ভিস সম্পর্কে বিস্তারিত জানতে চাচ্ছি।"
            : "Hello MusaFly! I'd like to get more information about your travel services.");
    final phone = AppStrings.rawPhoneNumber; // 96895923226
    final encoded = Uri.encodeComponent(text);

    // Tier 1: Try native scheme if supported
    final nativeUri = Uri.parse('whatsapp://send?phone=$phone&text=$encoded');
    try {
      if (await canLaunchUrl(nativeUri)) {
        final ok = await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
        if (ok) return true;
      }
    } catch (_) {}

    // Tier 2: Force attempt native scheme directly
    try {
      final ok = await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      if (ok) return true;
    } catch (_) {}

    // Tier 3: Standard wa.me link
    final waMeUri = Uri.parse('https://wa.me/$phone?text=$encoded');
    try {
      final ok = await launchUrl(waMeUri, mode: LaunchMode.externalApplication);
      if (ok) return true;
    } catch (_) {}

    // Tier 4: api.whatsapp.com fallback
    final apiUri = Uri.parse('https://api.whatsapp.com/send?phone=$phone&text=$encoded');
    try {
      return await launchUrl(apiUri, mode: LaunchMode.externalApplication);
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
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
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
      query: queryParams.isEmpty ? null : queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
    );

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      developer.log('Error sending email: $e', name: 'UrlHelper');
      return false;
    }
  }

  static Future<bool> openWebPage(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return await launchUrl(uri);
    } catch (e) {
      developer.log('Error opening web page: $e', name: 'UrlHelper');
      return false;
    }
  }

  static Future<bool> openWeb(String url) => openWebPage(url);
}
