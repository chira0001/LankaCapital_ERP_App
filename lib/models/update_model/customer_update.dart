class CustomerUpdate {
  final int nic;
  final String address;
  final String email;
  final String name;
  final String phoneNumber;
  int? sync;
  final int updateStatus;

  CustomerUpdate({
    required this.nic,
    required this.address,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.sync,
    required this.updateStatus,
  });

  factory CustomerUpdate.fromServer(Map<String, dynamic> json) {
    return CustomerUpdate(
      nic: json['nic'] as int,
      address: json['address'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      updateStatus: (json['update_status'] ?? 0) as int,
    );
  }

  // factory CustomerUpdate.fromDatabase(Map<String, dynamic> json) {
  //   return CustomerUpdate(
  //     nic: json['nic'] as int,
  //     address: json['address'] as String,
  //     email: json['email'] as String,
  //     name: json['name'] as String,
  //     phoneNumber: json['phone_number'] as String,
  //     sync: json['sync'] as int,
  //     updateStatus: json['update_status'] as int,
  //   );
  // }

  Map<String, dynamic> toUpdateDatabase() {
    return {
      'address': address,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'update_status': updateStatus,
    };
  }

  Map<String, dynamic> toLocal() {
    return {
      'nic': nic,
      'address': address,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'sync': sync,
      'update_status': updateStatus,
    };
  }

}
