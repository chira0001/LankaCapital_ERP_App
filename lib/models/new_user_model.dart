class NewUserModel {
  final int customerId;
  final String email;
  final String name;
  final String phoneNumber;
  final String address;
  final double amount;
  final int employeeId;
  final int installmentId;
  // final String type;

  NewUserModel({
    required this.customerId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.amount,
    required this.employeeId,
    required this.installmentId,
  });

  Map<String, dynamic> toServer() {
    return {
      'customerId': customerId,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      "loanAmount": amount,
      "employeeId": employeeId,
      "installmentId": installmentId,
    };
  }
}
