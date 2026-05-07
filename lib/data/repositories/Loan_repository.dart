import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/loan_model.dart';

class LoanRepository {
  final LoanService _service = LoanService();
  late List<Loan> _loans;

  List<Loan> get loans => _loans;

  Future<void> fetchLoans() async {
    try {
      // _loans = await _service.fetchAllLoans("faf");
    } catch (e) {
      print("Failed to load loans.");
    }
  }
}