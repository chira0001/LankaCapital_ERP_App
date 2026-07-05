// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_async_service.dart';
import 'package:nkrs_app/data/services/database_service/database_sync_service.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/data/view_model/sync_database_table.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

class SyncControllerViewModel {
  final DatabaseSyncService _service = DatabaseSyncService();

  Future<void> syncController(BuildContext context) async {
    if (!CheckConnection.isOnline.value) {
      AppTopSnackBar.wifi(
        context,
        "Device is offline. Turn on mobile data to continue.",
      );
      return;
    }
    SyncDatabaseTable syncDatabaseTable = SyncDatabaseTable();
    try {
      for (int i = 0; i < 2; i++) {
        final result = await syncDatabaseTable.customersTable(context);
        if (result.success) {
          if (result.successId!.isNotEmpty) {
            await _service.updateCustomersSync(result.successId!);
            await DatabaseAsyncService().updateSyncTime(0);
            break;
          }
        }
        if (result.failedId!.isNotEmpty && result.successId!.isNotEmpty) {
          await _service.updateCustomersSync(result.successId!);
          if (i == 1) {
            ScaffoldMessageBottom.show(
              context,
              "Error_Message_c2E00001_customer",
            );
          }
        }
      }
      for (int i = 0; i < 2; i++) {
        final result = await syncDatabaseTable.loanTable(context);
        if (result.success) {
          if (result.successId!.isNotEmpty) {
            await _service.updateSyncedLoans(result.obj);
            await DatabaseAsyncService().updateSyncTime(0);
            break;
          }
        }
        if (result.failedId!.isNotEmpty || result.successId!.isNotEmpty) {
          if (result.obj!.isNotEmpty) {
            await _service.updateSyncedLoans(result.obj);
          }
          if (i == 1) {
            ScaffoldMessageBottom.show(context, "Error_Message_c2E00001_loan");
          }
        }
      }
      for (int i = 0; i < 2; i++) {
        final result = await syncDatabaseTable.collectionsTable(context);
        if (result.success) {
          if (result.successId!.isNotEmpty) {
            await _service.deleteCollectionsSync(result.successId!);
            await DatabaseAsyncService().updateSyncTime(0);
            break;
          }
        }
        if (result.failedId!.isNotEmpty && result.successId!.isNotEmpty) {
          await _service.deleteCollectionsSync(result.successId!);
          if (i == 1) {
            ScaffoldMessageBottom.show(
              context,
              "Error_Message_c2E00001_collection",
            );
          }
        }
      }
    } catch (e) {
      return;
    }
  }
}
