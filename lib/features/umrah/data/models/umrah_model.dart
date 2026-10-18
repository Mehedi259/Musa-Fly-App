class UmrahModel {
  final int id;
  final String packageName;
  final double price;
  final String inclusions;
  final String? image;

  UmrahModel({
    required this.id,
    required this.packageName,
    required this.price,
    required this.inclusions,
    this.image,
  });

  factory UmrahModel.fromJson(Map<String, dynamic> json) {
    return UmrahModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      packageName: json['package_name'] ?? 'Umrah Package',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      inclusions: json['inclusions'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'package_name': packageName,
      'price': price,
      'inclusions': inclusions,
    };
  }

  List<String> get inclusionList {
    if (inclusions.isEmpty) return [];
    return inclusions.split(RegExp(r'[,•\n]')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  // Extract duration string if present in package_name, e.g. "Economy Umrah (14 Days)" -> "14 Days"
  String get duration {
    final match = RegExp(r'\((.*?)\)').firstMatch(packageName);
    return match?.group(1) ?? 'Custom Duration';
  }

  String get cleanTitle {
    return packageName.split('(').first.trim();
  }

  String get displayImage {
    if (image != null && image!.isNotEmpty) return image!;
    final lower = packageName.toLowerCase();
    if (lower.contains('vip')) {
      return 'https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?q=80&w=800';
    } else if (lower.contains('premium')) {
      return 'https://images.unsplash.com/photo-1591143223000-e14529f52f36?q=80&w=800';
    }
    return 'https://images.unsplash.com/photo-1565552643952-255964893798?q=80&w=800';
  }
}
