class FlightModel {
  final int id;
  final String airline;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String? image;

  FlightModel({
    required this.id,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    this.image,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      airline: json['airline'] ?? 'Airline',
      origin: json['origin'] ?? 'Origin',
      destination: json['destination'] ?? 'Destination',
      departureTime: DateTime.tryParse(json['departure_time']?.toString() ?? '') ?? DateTime.now(),
      arrivalTime: DateTime.tryParse(json['arrival_time']?.toString() ?? '') ??
          DateTime.now().add(const Duration(hours: 4)),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'origin': origin,
      'destination': destination,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'price': price,
    };
  }

  // Extract airport code helper e.g. "Dhaka (DAC)" -> "DAC"
  String get originCode {
    final match = RegExp(r'\((.*?)\)').firstMatch(origin);
    return match?.group(1) ?? (origin.length >= 3 ? origin.substring(0, 3).toUpperCase() : origin);
  }

  String get destinationCode {
    final match = RegExp(r'\((.*?)\)').firstMatch(destination);
    return match?.group(1) ??
        (destination.length >= 3 ? destination.substring(0, 3).toUpperCase() : destination);
  }

  String get originCity {
    return origin.split('(').first.trim();
  }

  String get destinationCity {
    return destination.split('(').first.trim();
  }
}
