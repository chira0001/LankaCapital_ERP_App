class ManageLoanModel {
  final String loanIds;
  final int updateStatus;

  ManageLoanModel({required this.loanIds, required this.updateStatus});

  factory ManageLoanModel.fromServer(Map<String, dynamic> json) {
    return ManageLoanModel(
      loanIds: json['id'] as String,
      updateStatus: (json['updateStatus'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toLocal() {
    return {'id': loanIds, 'update_status': updateStatus};
  }
}
