// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_put_service.dart';
import 'package:nkrs_app/data/services/loan_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

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
      ScaffoldMessageBottom.show(context, "Server connection failed");
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
    ScaffoldMessageBottom.show(context, "Database connection failed");
    return false;
  }
}
