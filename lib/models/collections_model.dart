class CollectionsModel {
  final String receiptId;
  final String fileNumber;
  final DateTime? collectionDate;
  final double premiumAmount;
  final double paidAmount;
  final double dueAmount;
  final String? collectedBy;

  CollectionsModel({
    required this.receiptId,
    required this.fileNumber,
    this.collectionDate,
    required this.premiumAmount,
    required this.paidAmount,
    required this.dueAmount,
    this.collectedBy,
  });

  factory CollectionsModel.fromDatabase(Map<String, dynamic> map) {
    return CollectionsModel(
      receiptId: map['receipt_id'] as String,
      fileNumber: map['file_number'] as String,
      collectionDate: map['collection_date'],
      premiumAmount: (map['premium_amount'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (map['paid_amount'] as num?)?.toDouble() ?? 0.0,
      dueAmount: (map['due_amount'] as num?)?.toDouble() ?? 0.0,
      collectedBy: map['collected_by'] as String?,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'receipt_id': receiptId,
      'file_number': fileNumber,
      // 'collection_date': collectionDate?.toIso8601String(),
      'premium_amount': premiumAmount,
      'paid_amount': paidAmount,
      'due_amount': dueAmount,
      'collected_by': collectedBy,
    };
  }

  Map<String, dynamic> toServer() {
    return {
      'receiptId': receiptId,
      'fileNumber': fileNumber,
      'collectionDate': collectionDate,
      'premiumAmount': premiumAmount,
      'paidAmount': paidAmount,
      'dueAmount': dueAmount,
      'collectedBy': collectedBy,
    };
  }
}
