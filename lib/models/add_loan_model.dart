class AddLoanModel {
  final int? id;
  final double amount;
  final int customerNic;
  final int employeeId;
  final int installmentId;
  final String? createdAt;

  AddLoanModel({
    this.id,
    required this.amount,
    required this.customerNic,
    required this.employeeId,
    required this.installmentId,
    this.createdAt,
  });

  factory AddLoanModel.fromJson(Map<String, dynamic> json) {
    return AddLoanModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      customerNic: json['customer_id'] as int,
      employeeId: json['employee_id'] as int,
      installmentId: json['installment_id'] as int,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'customer_id': customerNic,
      'employee_id': employeeId,
      'installment_id': installmentId,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toJsonServer() {
    return {
      "amount": amount,
      "customerNic": customerNic,
      "employeeId": employeeId,
      "installmentId": installmentId,
      "creatdAt": createdAt,
    };
  }

  Map<String, dynamic> toJsonSync() {
    return {
      "id": id,
      "amount": amount,
      "customerNic": customerNic,
      "employeeId": employeeId,
      "installmentId": installmentId,
      "creatdAt": createdAt,
    };
  }
}
