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
      id: json['customerNIC'] as int,
      name:
          json['businessName'] != null &&
              (json['businessName'] as String).isNotEmpty
          ? "${json['businessName'][0].toUpperCase()}${json['businessName'].substring(1).toLowerCase()}"
          : "N/A",
      // name: json['businessName'] ?? "N/A",
      email: json['businessEmail'] ?? "N/A",
      phoneNumber: json['contactNumber'] ?? "N/A",
      address: json['businessAddress'] ?? "N/A",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerNIC': id,
      'businessEmail': email,
      'businessName': name,
      'contactNumber': phoneNumber,
      'businessAddress': address,
    };
  }
}
