class CollectionsModel {
  final String? id;
  final String fileNumber;
  final int installmentNumber;
  final double paidAmount;
  final double dueAmount;
  final DateTime? paidAt;
  final int? employeeId;

  CollectionsModel({
    this.id,
    required this.fileNumber,
    required this.installmentNumber,
    required this.paidAmount,
    required this.dueAmount,
    this.paidAt,
    this.employeeId,
  });

  factory CollectionsModel.fromDatabase(Map<String, dynamic> map) {
    return CollectionsModel(
      id: map['receipt_id']?.toString(),
      fileNumber: map['file_number'] as String,
      installmentNumber: map['installment_number'] as int,
      paidAmount: (map['paid_amount'] as num).toDouble(),
      dueAmount: (map['due_amount'] as num).toDouble(),
      paidAt: map['paid_at'] != null
          ? DateTime.parse(map['paid_at'] as String)
          : null,
      employeeId: map['collected_by'] as int?,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'file_number': fileNumber,
      'installment_number': installmentNumber,
      'paid_amount': paidAmount,
      'due_amount': dueAmount,
      'collected_by': employeeId,
    };
  }

  Map<String, dynamic> toServer() {
    return {
      'fileNumber': fileNumber,
      'installmentNumber': installmentNumber,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'employeeId': employeeId,
    };
  }

  Map<String, dynamic> toSync() {
    return {
      'id':id,
      'fileNumber': fileNumber,
      'installmentNumber': installmentNumber,
      'paidAmount': paidAmount,
      'paidAt': paidAt,
      'dueAmount': dueAmount,
      'employeeId': employeeId,
    };
  }
}
