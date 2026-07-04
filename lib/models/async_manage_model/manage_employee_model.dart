class ManageEmployeeModel {
  final int employeeIds;
  final int updateStatus;

  ManageEmployeeModel({required this.employeeIds, required this.updateStatus});

  factory ManageEmployeeModel.fromServer(Map<String, dynamic> json) {
    return ManageEmployeeModel(
      employeeIds: json['id'] as int,
      updateStatus: (json['updateStatus'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toLocal() {
    return {'id': employeeIds, 'update_status': updateStatus};
  }
}
