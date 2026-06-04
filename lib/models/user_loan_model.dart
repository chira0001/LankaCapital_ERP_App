import 'package:nkrs_app/models/Interest_rate_model.dart';
import 'package:nkrs_app/models/employee_model.dart';
import 'package:nkrs_app/models/installment_model.dart';

class UserLoanModel {
  final String? fileNumber;
  final double amount;
  final String createdAt;
  final double? documentCharge;
  final String? rejectionNote;
  final String status;
  final int? sync;
  final InterestRateModel? interestRate;
  final EmployeeModel employee;
  final InstallmentModel installments;

  UserLoanModel({
    this.fileNumber,
    required this.amount,
    required this.createdAt,
    this.documentCharge,
    this.rejectionNote,
    required this.status,
    this.sync,
    this.interestRate,
    required this.employee,
    required this.installments,
  });

  factory UserLoanModel.fromJson(Map<String, dynamic> json) {
    return UserLoanModel(
      fileNumber: (json['fileNumber']?.toString().length ?? 0) < 7
          ? json['fileNumber'].toString()
          : "Pending",
      amount: json['amount'] as double,
      createdAt: json['createdAt'].toString(),
      documentCharge: double.tryParse(json['documentCharge'].toString()) ?? 0,
      rejectionNote: json['rejectionNote']?.toString() ?? "N/A",
      status: json['status'].toString(),
      interestRate: InterestRateModel.fromMap(
        json['interestRate'] as Map<String, dynamic>,
      ),
      employee: EmployeeModel.fromMap(json['employee'] as Map<String, dynamic>),
      installments: InstallmentModel.fromMap(
        json['installments'] as Map<String, dynamic>,
      ),
    );
  }

  factory UserLoanModel.fromMap(Map<String, dynamic> map) {
    return UserLoanModel(
      fileNumber: (map['file_number']?.toString().length ?? 0) < 7
          ? map['file_number'].toString()
          : "Pending",
      amount: map['amount'] as double,
      createdAt: map['created_at'].toString(),
      documentCharge: double.tryParse(map['document_charge'].toString()) ?? 0.0,
      rejectionNote: map['rejection_note']?.toString() ?? "N/A",
      status: map['status'].toString(),
      sync: map['sync'] as int,
      interestRate: map['interest_rate_id'] != null
          ? InterestRateModel.fromMap(
              map['interest_rate_id'] as Map<String, dynamic>,
            )
          : null,
      employee: EmployeeModel.fromMap(
        map['employee_id'] as Map<String, dynamic>,
      ),
      installments: InstallmentModel.fromMap(
        map['installment_id'] as Map<String, dynamic>,
      ),
    );
  }
}

// class GetLoanModel {
//   final String? uuID;
//   final String? fileNumber;
//   final double amount;
//   final String createdAt;
//   final int? interestRateId;
//   final String status;
//   final int sync;

//   GetLoanModel({
//     this.uuID,
//     this.fileNumber,
//     required this.amount,
//     required this.createdAt,
//     this.interestRateId,
//     required this.status,
//     this.sync = 0,
//   });

//   factory GetLoanModel.fromMap(Map<String, dynamic> map) {
//     return GetLoanModel(
//       uuID: map['uuID']?.toString(),
//       fileNumber: map['file_number']?.toString(),
//       amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
//       createdAt: map['created_at']?.toString() ?? "",
//       interestRateId: map['interest_rate_id'] as int?,
//       status: map['status'].toString(),
//       sync: map['sync'] as int? ?? 0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'uuID': uuID,
//       'file_number': fileNumber,
//       'amount': amount,
//       'created_at': createdAt,
//       'interest_rate_id': interestRateId,
//       'status': status,
//       'sync': sync,
//     };
//   }

//   factory GetLoanModel.fromJson(Map<String, dynamic> json) {
//     return GetLoanModel(
//       uuID: json['uuID']?.toString(),

//       fileNumber: json['fileNumber']?.toString(),

//       amount: (json['amount'] as num?)?.toDouble() ?? 0.0,

//       createdAt: json['createdAt']?.toString() ?? "",

//       interestRateId: json['interestRateId'] as int?,

//       status: json['status']?.toString() ?? "PENDING",

//       sync: json['sync'] as int? ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'uuID': uuID,
//       'fileNumber': fileNumber,
//       'amount': amount,
//       'createdAt': createdAt,
//       'interestRateId': interestRateId,
//       'status': status,
//       'sync': sync,
//     };
//   }
// }
