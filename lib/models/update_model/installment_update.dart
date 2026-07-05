class InstallmentUpdate {
  final int id;
  final int value;
  final int status;

  InstallmentUpdate({
    required this.id,
    required this.value,
    required this.status,
  });

  factory InstallmentUpdate.fromServer(Map<String, dynamic> json) {
    return InstallmentUpdate(
      id: json['id'] as int,
      value: json['value'] as int,
      status: json['status'] as int
    );
  }

  factory InstallmentUpdate.fromDatabase(Map<String, dynamic> json) {
    return InstallmentUpdate(
      id: json['id'] as int,
      value: json['value'] as int,
      status: json['update_status'] as int
    );
  }
}
