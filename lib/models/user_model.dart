class User {
  final int? id;
  final String email;
  final String name;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
    };
  }
}
