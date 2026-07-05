class EmployeeModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  EmployeeModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> map) {
    return EmployeeModel(
      firstName: map['firstName']?.toString() ?? "",
      lastName: map['lastName']?.toString() ?? "",
      phoneNumber: map['phoneNumber']?.toString() ?? "",
    );
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      firstName: map['first_name']?.toString() ?? "",
      lastName: map['last_name']?.toString() ?? "",
      phoneNumber: map['phone_number']?.toString() ?? "",
    );
  }
}
