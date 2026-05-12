import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';

class AddLoanView {
  final LoanService _service = LoanService();

  void addLoan(AddLoanModel addLoan) {
    _service.addLoan(addLoan);
  }
}
