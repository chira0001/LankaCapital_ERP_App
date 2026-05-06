class Loan {
  final double amount;
  final double interestRate;
  final String? nic;
  final int installment;
  final int fieldOfficer;

  Loan({
    required this.amount,
    required this.interestRate,
    required this.nic,
    required this.installment,
    required this.fieldOfficer,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'interestRate': interestRate,
      'nic': nic,
      'installment': installment,
      'fieldOfficer': fieldOfficer,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      amount: (json['amount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      nic: json['nic'] as String?,
      installment: json['installment'] as int,
      fieldOfficer: json['fieldOfficer'] as int,
    );
  }
}
