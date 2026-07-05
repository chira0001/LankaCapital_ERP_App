// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/database_service/database_loan_service.dart';
import 'package:nkrs_app/data/services/database_service/database_user_service.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/interest_rate_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class LoanViewModel extends ChangeNotifier {
  late User? _user;
  List<Loan> _loans = [];

  User? get user => _user;

  Future<void> searchByNic(int nic) async {
    final LoanService service = LoanService();

    notifyListeners();

    try {
      final (user, loans) = await service.fetchUserAndLoans(nic);
      _user = user;
      _loans = loans.where((loan) => loan.status == "APPROVED").toList();
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

  Future<User?> findUserAndLoanById(BuildContext context, int nic) async {
    try {
      final User? user;
      if (CheckConnection.isOnline.value) {
        user = await UserService().findUserInfoById(nic);
      } else {
        user = await DatabaseUserService().getUserWithLoans(nic);
      }
      if (user != null) {
        if (user.loans != null) {
          return User(
            nic: user.nic,
            email: user.email,
            name: user.name,
            phoneNumber: user.phoneNumber,
            address: user.address,
            sync: user.sync,
            loans: user.loans!.where((loan) => loan.status == "APPROVED").toList(),
          );
        } else {}
      } else {
        // AppTopSnackBar.error(context, "");
      }
      return null;
      // ignore: empty_catches
    } catch (e) {}
    return null;
  }

  Future<List<InstallmentModel>?> getInstallmentInfo(
    BuildContext context,
  ) async {
    try {
      List<InstallmentModel>? installments;
      if (CheckConnection.isOnline.value) {
        installments = await LoanService().getInstallments();
      } else {
        installments = await DatabaseGetService().getInstallments();
      }
      if (installments != null) {
        if (installments.isNotEmpty) {
          return installments;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Installment data found")),
        );
      }
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Installment data found")),
      );
      return null;
    }
  }

  Future<List<InterestRateModel>?> getInterestByOnline(
    BuildContext context,
  ) async {
    try {
      List<InterestRateModel>? interest;
      if (CheckConnection.isOnline.value) {
        interest = await LoanService().getInterestRates();
      } else {
        interest = await DatabaseGetService().getInterestRates();
      }
      if (interest != null) {
        if (interest.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No Interest Rate data found")),
          );
        } else {
          return interest;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Interest Rate data found")),
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> existingLoan(AddLoanModel loan, BuildContext context) async {
    try {
      String? m;
      if (CheckConnection.isOnline.value) {
        m = await LoanService().addExistingLoan(loan);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Server Connection failed");
          return false;
        }
      } else {
        m = await DatabaseLoanService().insertExistingLoan(loan);
        if (m == null) {
          ScaffoldMessageBottom.show(context, "Database Connection failed");
          return false;
        }
      }
      if (m.isEmpty) {
        return true;
      } else {
        AppTopSnackBar.error(
          context,
          m,
          showClose: true,
          duration: Duration(seconds: 3),
        );
        return false;
      }
        } catch (e) {
      return false;
    }
  }
}
