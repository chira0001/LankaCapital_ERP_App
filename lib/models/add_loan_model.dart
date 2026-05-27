class AddLoanModel {
  final double amount;
  final int customerNic;
  final int employeeId;
  final int installmentId;

  AddLoanModel({
    required this.amount,
    required this.customerNic,
    required this.employeeId,
    required this.installmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'customer_nic': customerNic,
      'employee_id': employeeId,
      'interest_rate_id': installmentId,
    };
  }

  Map<String, dynamic> toJsonServer() {
  return {
    "amount": amount,
    "customerNic": customerNic,
    "employeeId": employeeId,
    "installmentId": installmentId,
  };
}
}
