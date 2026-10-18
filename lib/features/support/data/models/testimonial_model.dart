class TestimonialModel {
  final int id;
  final String name;
  final String location;
  final String? image;
  final int rating;
  final String text;
  final String? date;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.location,
    this.image,
    required this.rating,
    required this.text,
    this.date,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Traveler',
      location: json['location'] ?? '',
      image: json['image'],
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating'].toString()) ?? 5,
      text: json['text'] ?? '',
      date: json['date'],
    );
  }
}
