class Loan {
  final String fileNumber;
  final double amount;
  final String? createdAt;
  final double interestRate;
  // final int customerId; //customer NIC
  // final int? employeeId;
  final int noOfInstallments;
  // final String? rejectionNote;
  final String status;
  final double documentCharge;

  Loan({
    required this.amount,
    this.createdAt,
    required this.interestRate,
    // required this.customerId,
    // required this.employeeId,
    required this.noOfInstallments,
    required this.fileNumber,
    required this.documentCharge,
    required this.status,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      fileNumber: json['fileNumber']?.toString() ?? "N/A",

      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,

      createdAt: json['createdAt']?.toString(),

      interestRate: (json['interestRate']?['rate'] as num?)?.toDouble() ?? 0.0,

      noOfInstallments: (json['installments']?['value'] as num?)?.toInt() ?? 0,

      documentCharge: (json['documentCharge'] as num?)?.toDouble() ?? 0.0,

      status: json['status']?.toString() ?? "PENDING",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'createdAt': createdAt,
      'interestRate': interestRate,
      // 'customerId': customerId,
      // 'employeeId': employeeId,
      'noOfInstallments': noOfInstallments,
      // 'rejection_note': rejectionNote,
      'status': status,
    };
  }

  static Object? fromMap(Map<String, dynamic> loan) {
    return null;
  }
}
