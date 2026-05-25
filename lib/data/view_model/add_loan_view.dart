// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_put_service.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';

class AddLoanView {
  Future<bool> addLoanByOnline(
    AddLoanModel addLoan,
    BuildContext context,
  ) async {
    final LoanService service = LoanService();
    String? m = await service.addLoan(addLoan);
    if (m != null) {
      if (m.isEmpty) {
        return true;
      } else {
        AppTopSnackBar.error(
          context,
          m,
          showClose: true,
          duration: Duration(seconds: 4),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server connection failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  Future<bool> addLoanByOffline(
    AddLoanModel addLoan,
    BuildContext context,
  ) async {
    DatabasePutService service = DatabasePutService();
    int? r = await service.insertLoan(addLoan);
    if (r != null) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Database connection failed"),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
}
