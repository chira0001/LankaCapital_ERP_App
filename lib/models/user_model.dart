class User {
  final int? id;
  final String email;
  final String name;
  final String phoneNumber;
  final String address;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json['customerNIC'] as int,
  //     email: json['businessEmail'] as String,
  //     name: json['businessName'] as String,
  //     phoneNumber: json['contactNumber'] as String,
  //     address: json['businessAddress'] as String,
  //   );
  // }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['nic'] as num?)?.toInt(),
      name: json['name'] ?? "N/A",
      email: json['email'] ?? "N/A",
      phoneNumber: json['phoneNumber'] ?? "N/A",
      address: json['address'] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nic': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
