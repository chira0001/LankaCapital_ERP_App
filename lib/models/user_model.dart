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
      id: json['customerNIC'] as int,
      email: json['businessEmail'] as String,
      name: json['businessName'] as String,
      phoneNumber: json['contactNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerNIC': id,
      'businessEmail': email,
      'businessName': name,
      'contactNumber': phoneNumber,
    };
  }
}
