import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';

class AddLoanView {
  final LoanService _service = LoanService();

  Future<bool> addLoan(AddLoanModel addLoan) async {
    // return _service.addLoan(addLoan);
    return true;
  }
}
