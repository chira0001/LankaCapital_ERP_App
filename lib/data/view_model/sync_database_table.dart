// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_get_service.dart';
import 'package:nkrs_app/data/services/sync_service/sync_service.dart';
import 'package:nkrs_app/models/customer_sync_result.dart';
import 'package:nkrs_app/models/sync_loan_resp_model.dart';
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

      final missedIds = allCustomerIds
          .where((id) => !successIds.contains(id) && !failedIds.contains(id))
          .toList();

      if (failedIds.isEmpty && successIds.length == allCustomerIds.length) {
        AppTopSnackBar.success(context, "Customer data synced successfully.");
        return CustomerSyncResult(success: true, successId: successIds);
      }
      if (successIds.isNotEmpty || failedIds.isNotEmpty) {
        return CustomerSyncResult(
          success: false,
          successId: successIds,
          failedId: missedIds,
        );
      }
      return CustomerSyncResult(success: false);
    } catch (e) {
      ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_customer");
      return CustomerSyncResult(success: false);
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
      final List<int> failedIds = [];
      final List<SyncLoanRespModel> loanObj = [];

      for (int i = 0; i < loanList.length; i += batchSize) {
        final batch = loanList.skip(i).take(batchSize).toList();
        List<SyncLoanRespModel>? result = await SyncService().syncLoans(batch);
        if (result == null) {
          AppTopSnackBar.error(context, "Can't sync Loan data to server");
          return CustomerSyncResult(success: false);
        }
        for (final e in result) {
          if (e.loanUUID.isNotEmpty && e.status == "success") {
            loanObj.add(e);
            successIds.add(e.id);
          } else if (e.loanUUID.isEmpty && e.status == "failure") {
            failedIds.add(e.id);
          }
        }
      }
      final missedIds = allLoanIds
          .where((id) => !successIds.contains(id) && !failedIds.contains(id))
          .toList();

      if (failedIds.isEmpty && successIds.length == allLoanIds.length) {
        AppTopSnackBar.success(context, "Loan data synced successfully.");
        return CustomerSyncResult(
          success: true,
          successId: successIds,
          obj: loanObj,
        );
      }
      if (successIds.isNotEmpty || missedIds.isNotEmpty) {
        return CustomerSyncResult(
          success: false,
          successId: successIds,
          failedId: missedIds,
          obj: loanObj,
        );
      }
      return CustomerSyncResult(success: false);
    } catch (e) {
      ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_loan");
      return CustomerSyncResult(success: false);
    }
  }

  Future<CustomerSyncResult> collectionsTable(BuildContext context) async {
    const int batchSize = 2;

    try {
      final collections = await _databaseGetService.getCollections();
      if (collections == null) {
        ScaffoldMessageBottom.show(context, "Failed to load Collections");
        return CustomerSyncResult(success: false);
      }
      if (collections.isEmpty) {
        AppTopSnackBar.success(
          context,
          "No Collections are available for Sync.",
        );
        return CustomerSyncResult(success: true);
      }
      final allCollectionIds = collections
          .where((data) => data.id != null)
          .map((data) => data.id)
          .toList();

      final List<int> successIds = [];

      for (int i = 0; i < collections.length; i += batchSize) {
        final batch = collections.skip(i).take(batchSize).toList();
        List<int>? result = await SyncService().syncCollections(batch);
        if (result == null || result.isEmpty) {
          AppTopSnackBar.error(context, "Can't sync data to server");
          return CustomerSyncResult(success: false);
        }
        successIds.addAll(result);
      }
      final failedIds = allCollectionIds
          .where((id) => !successIds.contains(id))
          .toList();

      final missedIds = allCollectionIds
          .where((id) => !successIds.contains(id) && !failedIds.contains(id))
          .toList();

      if (failedIds.isEmpty && successIds.length == allCollectionIds.length) {
        AppTopSnackBar.success(context, "Customer data synced successfully.");
        return CustomerSyncResult(success: true, successId: successIds);
      }
      if (successIds.isNotEmpty || failedIds.isNotEmpty) {
        return CustomerSyncResult(
          success: false,
          successId: successIds,
          // failedId: missedIds,
        );
      }
      return CustomerSyncResult(success: false);
    } catch (e) {
      ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_Collection");
      return CustomerSyncResult(success: false);
    }
  }
}
