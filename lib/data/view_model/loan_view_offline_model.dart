import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class LoanViewOfflineModel {
  User? _user;

  User? get user => _user;
  List<Loan> _loans = [];

  Future<void> searchByNic0ffline(int nic) async {
    // notifyListeners();

    try {
      final (user, loans) = await _service.fetchUserAndLoans(nic);
      _user = user;
      _loans = loans;
    } catch (e) {
      _user = null;
      _loans = [];
    } finally {
      // notifyListeners();
    }
  }
}