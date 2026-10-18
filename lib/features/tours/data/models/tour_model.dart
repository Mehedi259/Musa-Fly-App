class TourModel {
  final int id;
  final String destination;
  final String duration;
  final double price;
  final String inclusions;
  final String? image;

  TourModel({
    required this.id,
    required this.destination,
    required this.duration,
    required this.price,
    required this.inclusions,
    this.image,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      destination: json['destination'] ?? 'Holiday Destination',
      duration: json['duration'] ?? 'Flexible Days',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      inclusions: json['inclusions'] ?? '',
      image: json['image'] ?? json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'duration': duration,
      'price': price,
      'inclusions': inclusions,
    };
  }

  List<String> get inclusionList {
    if (inclusions.isEmpty) return [];
    return inclusions.split(RegExp(r'[,•\n]')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  String get displayImage {
    if (image != null && image!.isNotEmpty) return image!;
    final lower = destination.toLowerCase();
    if (lower.contains('dubai')) {
      return 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=800';
    } else if (lower.contains('maldives')) {
      return 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=800';
    } else if (lower.contains('switzerland') || lower.contains('alps')) {
      return 'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?q=80&w=800';
    } else if (lower.contains('cox')) {
      return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=800';
    }
    return 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?q=80&w=800';
  }
}
