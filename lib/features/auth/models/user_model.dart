class UserModel {
  final int id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? googleId;
  final String? phone;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.googleId,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      googleId: json['google_id'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'google_id': googleId,
      'phone': phone,
    };
  }
}

