import 'package:nkrs_app/models/user_loan_model.dart';

class User {
  final int nic;
  final String email;
  final String name;
  final String phoneNumber;
  final String address;
  final int? sync;
  final List<UserLoanModel>? loans;

  User({
    required this.nic,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.sync,
    this.loans,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nic: json['nic'] as int,
      email: json['email'].toString(),
      name: json['name'].toString(),
      phoneNumber: json['phoneNumber'].toString(),
      address: json['address'].toString(),
      loans:
          (json['loans'] as List<dynamic>?)
              ?.map((e) => UserLoanModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory User.fromMapUser(Map<String, dynamic> map) {
    return User(
      nic: map['nic'] as int,
      email: map['email'].toString(),
      name: map['name'].toString(),
      phoneNumber: map['phone_number'].toString(),
      address: map['address'].toString(),
      sync: map['sync'] as int,
      loans: (map['loans'] as List<UserLoanModel>?) ?? [],
    );
  }
}
