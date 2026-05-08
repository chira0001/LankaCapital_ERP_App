import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class LoanViewModel extends ChangeNotifier {
  final LoanService _service = LoanService();
  User? _user;

  User? get user =>
      User(id: 1, email: "email", name: "name", phoneNumber: "phoneNumber");
  // ignore: unused_field
  List<Loan> _loans = [];
  // ignore: unused_field
  bool _isLoading = false;

  Future<void> searchByNic(int nic, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final (user, loans) = await _service.fetchUserAndLoans(nic);

      _user = user;
      _loans = loans;
    } catch (e) {
      debugPrint(e.toString());
      _user = null;
      _loans = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<User?> getUserByID() async {
  //   return _user;
  //   // return User(id: 1, email: "f", name: "fsf", phoneNumber: "0766303435");
  // }

  Future<List<Loan>> getLoansByID() async {
    return _loans;

    // return [
    //   Loan(
    //     amount: 8000.00,
    //     createdAt: "2026-06-03 13:33:22",
    //     interestRate: 18.0,
    //     customerId: 200227800587,
    //     employeeId: 3,
    //     noOfInstallments: 1,
    //     status: "REJECTED",
    //     rejectionNote: "Low income",
    //   ),
    //   Loan(
    //     amount: 99989.99,
    //     createdAt: "2026-04-24 12:27:14",
    //     interestRate: 11.5,
    //     customerId: 200227800577,
    //     employeeId: 3,
    //     noOfInstallments: 1,
    //     status: "APPROVED",
    //   ),
    //   Loan(
    //     amount: 100000.80,
    //     createdAt: "2026-05-03 11:09:58",
    //     interestRate: 14.5,
    //     customerId: 200227800587,
    //     employeeId: 3,
    //     noOfInstallments: 1,
    //     status: "PENDING",
    //   ),
    // ];
  }
}
