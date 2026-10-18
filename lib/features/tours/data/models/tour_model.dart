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
}
