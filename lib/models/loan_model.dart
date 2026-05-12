class Loan {
  final double amount;
  final String? createdAt;
  final double interestRate;
  final int customerId; //customer NIC
  final int? employeeId;
  final int noOfInstallments;
  final String? rejectionNote;
  final String status;

  Loan({
    required this.amount,
    this.createdAt,
    required this.interestRate,
    required this.customerId,
    required this.employeeId,
    required this.noOfInstallments,
    this.rejectionNote,
    required this.status,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] as String?,
      interestRate: (json['interest_rate'] as num).toDouble(),
      customerId: json['customer_id']as int,
      employeeId: json['employee_id'] as int,
      noOfInstallments: json['no_of_installments'] as int,
      rejectionNote: json['rejection_note'] as String?,
      status: json['status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'created_at': createdAt,
      'interest_rate': interestRate,
      'customer_id': customerId,
      'employee_id': employeeId,
      'no_of_installments': noOfInstallments,
      'rejection_note': rejectionNote,
      'status': status,
    };
  }
}
