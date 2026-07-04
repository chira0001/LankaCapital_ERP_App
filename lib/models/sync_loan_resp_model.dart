class SyncLoanRespModel {
  final int id;
  final String loanUUID;
  final String status;

  SyncLoanRespModel({
    required this.id,
    required this.loanUUID,
    required this.status,
  });

  factory SyncLoanRespModel.fromJson(Map<String, dynamic> json) {
    return SyncLoanRespModel(
      id: json['id'] as int,
      loanUUID: json['uuid'] as String,
      status: json['status'] as String,
    );
  }
}
