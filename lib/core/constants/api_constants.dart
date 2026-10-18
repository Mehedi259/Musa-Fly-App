class ApiConstants {
  // Base URL pointing to the MusaFly backend server
  static const String baseUrl = 'http://46.225.103.236:8001/api';
  static const String mediaBaseUrl = 'http://46.225.103.236:8001';

  // Endpoints
  static const String flights = '/flights/';
  static const String tours = '/tours/';
  static const String visas = '/visas/';
  static const String umrah = '/umrah/';
  static const String deals = '/deals/';
  static const String customers = '/customers/';
  static const String faqs = '/faqs/';
  static const String testimonials = '/testimonials/';
  static const String inventory = '/inventory/';
  static const String dashboardStats = '/dashboard/stats/';
  static const String campaigns = '/marketing/campaigns/';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Helper to ensure full URL for media
  static String formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    if (url.startsWith('/')) {
      return '$mediaBaseUrl$url';
    }
    return '$mediaBaseUrl/$url';
  }
}
