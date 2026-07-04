class LoanUpdate {
  final int? id;
  final String? fileNumber;
  final double amount;
  final String? createdAt;
  final double? documentCharge;
  final int? interestRateId;
  final int customerId;
  final int employeeId;
  final int installmentId;
  final String? rejectionNote;
  final String status;
  int? sync;
  final int updateStatus;

  LoanUpdate({
    this.id,
    this.fileNumber,
    required this.amount,
    this.createdAt,
    this.documentCharge,
    this.interestRateId,
    required this.customerId,
    required this.employeeId,
    required this.installmentId,
    this.rejectionNote,
    required this.status,
    this.sync,
    required this.updateStatus,
  });

  factory LoanUpdate.fromServer(Map<String, dynamic> json) {
    return LoanUpdate(
      // id: json['id'] as int,
      fileNumber: json['file_number'] as String?,
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] as String?,
      documentCharge: (json['document_charge'] as num?)?.toDouble(),
      interestRateId: json['interest_rate_id'] as int?,
      customerId: json['customer_id'] as int,
      employeeId: json['employee_id'] as int,
      installmentId: json['installment_id'] as int,
      rejectionNote: json['rejection_note'] as String?,
      status: json['status'] as String,
      sync: json['sync'] as int?,
      updateStatus: (json['update_status'] ?? 0) as int,
    );
  }

  // factory LoanUpdate.fromMap(Map<String, dynamic> map) {
  //   return LoanUpdate(
  //     id: map['id'] as int,
  //     fileNumber: map['file_number'] as String?,
  //     amount: (map['amount'] as num).toDouble(),
  //     createdAt: map['created_at'] as String?,
  //     documentCharge: (map['document_charge'] as num?)?.toDouble(),
  //     interestRateId: map['interest_rate_id'] as int?,
  //     customerId: map['customer_id'] as int,
  //     employeeId: map['employee_id'] as int,
  //     installmentId: map['installment_id'] as int,
  //     rejectionNote: map['rejection_note'] as String?,
  //     status: map['status'] as String,
  //     sync: map['sync'] as int?,
  //     updateStatus: map['update_status'] as int,
  //   );
  // }

  Map<String, dynamic> toUpdateDatabase() {
    return {
      'file_number': fileNumber,
      'amount': amount,
      'created_at': createdAt,
      'document_charge': documentCharge,
      'interest_rate_id': interestRateId,
      'customer_id': customerId,
      'employee_id': employeeId,
      'installment_id': installmentId,
      'rejection_note': rejectionNote,
      'status': status,
      'update_status': updateStatus,
    };
  }

  Map<String, dynamic> toLocal() {
    return {
      'file_number': fileNumber,
      'amount': amount,
      'created_at': createdAt,
      'document_charge': documentCharge,
      'interest_rate_id': interestRateId,
      'customer_id': customerId,
      'employee_id': employeeId,
      'installment_id': installmentId,
      'rejection_note': rejectionNote,
      'status': status,
      'sync': sync,
      'update_status': updateStatus,
    };
  }
}
