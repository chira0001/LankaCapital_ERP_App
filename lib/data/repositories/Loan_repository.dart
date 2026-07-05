
import 'package:nkrs_app/models/loan_model.dart';
import 'package:flutter/foundation.dart';

class LoanRepository {
  // Removed unused _service
  late List<Loan> _loans;

  List<Loan> get loans => _loans;

  Future<void> fetchLoans() async {
    try {
      // _loans = await _service.fetchAllLoans("faf");
    } catch (e) {
      debugPrint("Failed to load loans.");
    }
  }
}