class AddLoanModel {

  final double amount;
  // final double interestRate;
  final int customerId; //customer NIC
  final int employeeId;
  // final int noOfInstallments;

  AddLoanModel({
    required this.amount,
    // required this.interestRate,
    required this.customerId,
    required this.employeeId,
    // required this.noOfInstallments,
  });

  factory AddLoanModel.fromJson(Map<String, dynamic> json) {
    return AddLoanModel(
      amount: (json['amount'] as num).toDouble(),
      // interestRate: (json['interest_rate'] as num).toDouble(),
      customerId: json['customer_id']as int,
      employeeId: json['employee_id'] as int,
      // noOfInstallments: json['no_of_installments'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      // 'interest_rate': interestRate,
      'customer_id': customerId,
      'employee_id': employeeId,
      // 'no_of_installments': noOfInstallments,
    };
  }
}

