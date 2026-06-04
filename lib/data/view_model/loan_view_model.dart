// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/database_service/database_user_service.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/data/services/user_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/models/Interest_rate_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

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
          return user;
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
}
