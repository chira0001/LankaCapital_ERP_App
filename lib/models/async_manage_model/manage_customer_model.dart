class ManageCustomerModel {
  final int customerIds;
  final int updateStatus;

  ManageCustomerModel({required this.customerIds, required this.updateStatus});

  factory ManageCustomerModel.fromServer(Map<String, dynamic> json) {
    return ManageCustomerModel(
      customerIds: json['id'] as int,
      updateStatus: (json['updateStatus'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toLocal() {
    return {'id': customerIds, 'update_status': updateStatus};
  }
}
