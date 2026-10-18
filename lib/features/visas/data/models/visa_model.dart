class VisaModel {
  final int id;
  final String country;
  final String visaType;
  final String processingTime;
  final double price;
  final String? requirements;
  final String? image;

  VisaModel({
    required this.id,
    required this.country,
    required this.visaType,
    required this.processingTime,
    required this.price,
    this.requirements,
    this.image,
  });

  factory VisaModel.fromJson(Map<String, dynamic> json) {
    return VisaModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      country: json['country'] ?? 'Country',
      visaType: json['visa_type'] ?? 'Tourist Visa',
      processingTime: json['processing_time'] ?? '5-7 Working Days',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      requirements: json['requirements'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'visa_type': visaType,
      'processing_time': processingTime,
      'price': price,
      'requirements': requirements,
    };
  }

  List<String> get requirementList {
    if (requirements == null || requirements!.isEmpty) {
      return [
        'Valid Passport (minimum 6 months validity)',
        'Recent passport-sized photo (white background)',
        'National ID / Iqama copy',
        'Bank Statement (last 3-6 months)',
      ];
    }
    return requirements!
        .split(RegExp(r'[\r\n]+'))
        .map((s) => s.replaceAll(RegExp(r'^[✅•\-\*]\s*'), '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  String get formattedProcessingTime {
    if (processingTime.toLowerCase().contains('day') ||
        processingTime.toLowerCase().contains('hour')) {
      return processingTime;
    }
    return '$processingTime Working Days';
  }

  String get displayImage {
    if (image != null && image!.isNotEmpty) return image!;
    final lower = country.toLowerCase();
    if (lower.contains('malaysia')) {
      return 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?q=80&w=800';
    } else if (lower.contains('singapore')) {
      return 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?q=80&w=800';
    } else if (lower.contains('uae') || lower.contains('dubai')) {
      return 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=800';
    } else if (lower.contains('oman')) {
      return 'https://images.unsplash.com/photo-1547304638-aa0a7b5aae3d?q=80&w=800';
    }
    return 'https://images.unsplash.com/photo-1566552881560-0be862a7c445?q=80&w=800';
  }
}
