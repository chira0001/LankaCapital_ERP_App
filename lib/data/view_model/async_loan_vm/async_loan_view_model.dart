// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/async_service/async_loan/async_database_loan.dart';
import 'package:nkrs_app/data/services/async_service/async_loan/async_loan_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_loan_model.dart';
import 'package:nkrs_app/models/update_model/loan_update.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class AsyncLoanViewModel {
  final AsyncLoanService _asyncLoanService = AsyncLoanService();
  final AsyncDatabaseLoan _asyncDatabaseLoan = AsyncDatabaseLoan();

  final int limit = 10;

  Future<bool?> ManageLoansTabel(BuildContext context) async {
    int pageNo = 0;
    await _asyncDatabaseLoan.clearTempLoans();
    await _asyncDatabaseLoan.clearUpdateLoans();

    while (true) {
      //async
      List<ManageLoanModel>? serverData = await _asyncLoanService.manageLoans(
        pageNo,
      );

      if (serverData == null) return false;
      if (serverData.isEmpty) {
        break;
      }

      bool? table = await _asyncDatabaseLoan.insertTempCustomers(serverData);
      if (table == null) {
        await _asyncDatabaseLoan.clearTempLoans();
        await _asyncDatabaseLoan.clearUpdateLoans();
        break;
      }
      ++pageNo;
    }

    int offset = 0;
    while (true) {
      //
      final customerIds = await _asyncDatabaseLoan.getLoansIds(
        limit: limit,
        offset: offset,
      );

      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"id": customerIds};
      List<LoanUpdate>? tableData = await _asyncLoanService.asyncLoans(json);
      if (tableData == null) {
        AppTopSnackBar.info(context, "Server or Connection or Error : Loan");
        break;
      }
      if (tableData.isEmpty) {
        break;
      }

      for (var employee in tableData) {
        employee.sync = 2;
      }

      for (var item in tableData) {
        final savedId = (await _asyncDatabaseLoan.insertLoanToTable(item));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Loan");
          return false;
        }
      }
      offset += limit;
    }

    int offsets = 0; //update
    while (true) {
      final customerIds = await _asyncDatabaseLoan.getUpdateLoans(
        limit: limit,
        offset: offsets,
      );

      if (customerIds.isEmpty) {
        break;
      }
      Map<String, dynamic> json = {"id": customerIds};
      List<LoanUpdate>? tableData = await _asyncLoanService.asyncLoans(json);
      if (tableData == null) {
        AppTopSnackBar.info(
          context,
          "Server or Connection or Error : Customers",
        );
        break;
      }
      if (tableData.isEmpty) {
        break;
      }
      for (var item in tableData) {
        final savedId = (await _asyncDatabaseLoan.updateLoanToTable(item));
        if (savedId == null) {
          ScaffoldMessageBottom.show(context, "Can't insert data Customers");
          return false;
        }
      }
      offsets += limit;
    }

    await _asyncDatabaseLoan.deleteLoans();
    await _asyncDatabaseLoan.resetLoans();
    await _asyncDatabaseLoan.clearTempLoans();
    await _asyncDatabaseLoan.clearUpdateLoans();
    return true;
  }
}
