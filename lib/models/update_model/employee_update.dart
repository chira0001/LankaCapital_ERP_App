class EmployeeUpdate {
  final int id;
  final int nic;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String phoneNumber;
  int? sync;
  final int? updateStatus;

  EmployeeUpdate({
    required this.id,
    required this.nic,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.phoneNumber,
    this.updateStatus,
    this.sync,
  });

  factory EmployeeUpdate.fromServer(Map<String, dynamic> json) {
    return EmployeeUpdate(
      id: json['id'] as int,
      nic: json['nic'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String,
      updateStatus: (json['update_status'] ?? 0) as int,
    );
  }

  // factory EmployeeUpdate.fromDatabase(Map<String, dynamic> json) {
  //   return EmployeeUpdate(
  //     id: json['id'] as int,
  //     nic: json['nic'] as int,
  //     firstName: json['first_name'] as String,
  //     lastName: json['last_name'] as String,
  //     email: json['email'] as String,
  //     address: json['address'] as String,
  //     phoneNumber: json['phone_number'] as String,
  //     sync: json['sync'] as int,
  //     updateStatus: json['update_status'] as int,
  //   );
  // }

  Map<String, dynamic> toUpdateDatabase() {
    return {
      'nic': nic,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'update_status': updateStatus,
    };
  }

  Map<String, dynamic> toLocal() {
    return {
      'id': id,
      'nic': nic,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'sync': sync,
      'update_status': updateStatus,
    };
  }
}
