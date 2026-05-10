import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class LoanViewModel extends ChangeNotifier {
  final LoanService _service = LoanService();
  User? _user;

  User? get user => _user;
  List<Loan> _loans = [];

  Future<void> searchByNic(int nic) async {
    notifyListeners();

    try {
      final (user, loans) = await _service.fetchUserAndLoans(nic);
      _user = user;
      _loans = loans;
    } catch (e) {
      _user = null;
      _loans = [];
    } finally {
      notifyListeners();
    }
  }

  Future<List<Loan>> getLoansByID() async {
    return _loans;
  }
}
