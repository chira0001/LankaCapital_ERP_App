// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/sync_service/sync_service.dart';
import 'package:nkrs_app/models/customer_sync_result.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class SyncDatabaseTable {
  final DatabaseGetService _databaseGetService = DatabaseGetService();

  Future<CustomerSyncResult> customersTable(BuildContext context) async {
    const int batchSize = 2;

    try {
      final customerList = await _databaseGetService.getUnsyncedCustomers();
      if (customerList == null) {
        ScaffoldMessageBottom.show(context, "Failed to load customers");
        return CustomerSyncResult(success: false);
      }
      if (customerList.isEmpty) {
        AppTopSnackBar.success(context, "No customers are available for Sync.");
        return CustomerSyncResult(success: true);
      }
      final allCustomerIds = customerList
          .map((e) => e.nic)
          .whereType<int>()
          .toList();

      final List<int> successIds = [];
      for (int i = 0; i < customerList.length; i += batchSize) {
        final batch = customerList.skip(i).take(batchSize).toList();
        final result = await SyncService().syncCustomers(batch);
        if (result == null || result.isEmpty) {
          AppTopSnackBar.error(context, "Can't sync data to server");
          return CustomerSyncResult(success: false);
        }
        successIds.addAll(result);
      }
      final failedIds = allCustomerIds
          .where((id) => !successIds.contains(id))
          .toList();

      if (failedIds.isEmpty && successIds.length == allCustomerIds.length) {
        AppTopSnackBar.success(context, "Customer data synced successfully.");
        return CustomerSyncResult(success: true, successId: successIds);
      } else {
        if (successIds.isEmpty) {
          return CustomerSyncResult(success: false, failedId: failedIds);
        }
        return CustomerSyncResult(success: false);
      }
    } catch (e) {
      ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_customer");
      return CustomerSyncResult(success: false, message: e.toString());
    }
  }

  Future<CustomerSyncResult> loanTable(BuildContext context) async {
    const int batchSize = 2;

    try {
      final loanList = await _databaseGetService.getUnsyncedLoans();
      if (loanList == null) {
        ScaffoldMessageBottom.show(context, "Failed to load Loans");
        return CustomerSyncResult(success: false);
      }
      if (loanList.isEmpty) {
        AppTopSnackBar.success(context, "No Loans are available for Sync.");
        return CustomerSyncResult(success: true);
      }

      final allLoanIds = loanList
          .where((loan) => loan.id != null)
          .map((loan) => loan.id!)
          .toList();

      final List<int> successIds = [];

      for (int i = 0; i < loanList.length; i += batchSize) {
        final batch = loanList.skip(i).take(batchSize).toList();
        final result = await SyncService().syncLoans(batch);
        if (result == null) {
          AppTopSnackBar.error(context, "Can't sync Loan data to server");
          return CustomerSyncResult(success: false);
        }
        successIds.addAll(result);
      }
      final failedIds = allLoanIds
          .where((id) => !successIds.contains(id))
          .toList();

      if (failedIds.isEmpty && successIds.length == allLoanIds.length) {
        AppTopSnackBar.success(context, "Loan data synced successfully.");
        return CustomerSyncResult(success: true, successId: successIds);
      } else {
        if (successIds.isEmpty) {
          return CustomerSyncResult(success: false, failedId: failedIds);
        }
        return CustomerSyncResult(success: false);
      }
    } catch (e) {
      ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_loan");
      return CustomerSyncResult(success: false, message: e.toString());
    }
  }

  // Future<SyncResult> collectionsTable() async {
  //   return SyncResult(success: true,);
  // }
}
