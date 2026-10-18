import 'package:intl/intl.dart';

class DealModel {
  final int? id;
  final String customerName;
  final String phoneNumber;
  final String address;
  final String passportNumber;
  final String? email;
  final String serviceCategory;
  final String routeDestination;
  final DateTime travelDate;
  final String? airlineName;
  final String leadSource;
  final double dealPrice;
  final String currency;
  final DateTime? createdAt;

  DealModel({
    this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.passportNumber,
    this.email,
    required this.serviceCategory,
    required this.routeDestination,
    required this.travelDate,
    this.airlineName,
    this.leadSource = 'Mobile App',
    required this.dealPrice,
    this.currency = 'USD',
    this.createdAt,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id'],
      customerName: json['customer_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      passportNumber: json['passport_number'] ?? '',
      email: json['email'],
      serviceCategory: json['service_category'] ?? '',
      routeDestination: json['route_destination'] ?? '',
      travelDate: DateTime.tryParse(json['travel_date']?.toString() ?? '') ?? DateTime.now(),
      airlineName: json['airline_name'],
      leadSource: json['lead_source'] ?? 'Mobile App',
      dealPrice: double.tryParse(json['deal_price']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] ?? 'USD',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'phone_number': phoneNumber,
      'address': address,
      'passport_number': passportNumber,
      if (email != null && email!.isNotEmpty) 'email': email,
      'service_category': serviceCategory,
      'route_destination': routeDestination,
      'travel_date': DateFormat('yyyy-MM-dd').format(travelDate),
      if (airlineName != null && airlineName!.isNotEmpty) 'airline_name': airlineName,
      'lead_source': leadSource,
      'deal_price': dealPrice.toStringAsFixed(2),
      'currency': currency,
    };
  }
}
