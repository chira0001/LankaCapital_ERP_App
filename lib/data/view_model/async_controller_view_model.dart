// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_service/database_async_service.dart';
import 'package:nkrs_app/data/view_model/async_database_table.dart';

class AsyncControllerViewModel {
  final AsyncDatabaseTable _service = AsyncDatabaseTable();
  final DatabaseAsyncService _database = DatabaseAsyncService();

  Future<void> asyncController(BuildContext context) async {
    bool anyParentFailed = false;
    final Map<int, bool?> checker = {};
    try {
      final results = await Future.wait<bool?>([
        _service.customersTable(context), // 1
        _service.employeesTable(context), // 2
        _service.installmentsTable(context), // 3
        _service.interestRatesTable(context), // 4
        // _service.loansTable(context), // 5
      ]);

      checker[1] = results[0];
      checker[2] = results[1];
      checker[3] = results[2];
      checker[4] = results[3];
      // checker[5] = results[4];

      for (final entry in checker.entries) {
        if (entry.value != true || entry.value == null) {
          anyParentFailed = true;
          final failedIndex = entry.key;

          await retryFailedMethod(failedIndex, context, checker);
        }
      }

      if (!anyParentFailed) {
        debugPrint('🔄 Syncing/Running Loans Table (5)...');
        checker[5] = await _service.loansTable(context);
        if (checker[5] == false || checker[5] == null) {
          final _ = await _database.deleteSyncedInstallments("loans");
          checker[5] = await _service.loansTable(context);
        }
      } else {
        final successCount = checker.values.where((v) => v == true).length;
        if (successCount == 4) {
          checker[5] = await _service.loansTable(context);
        }
        debugPrint("Other table error");
      }

      _updateAsync(checker);

      debugPrint("Update sync -------------: $checker");
    } catch (e) {
      debugPrint('An error occurred during sync controller execution: $e');
    }
  }

  Future<void> _updateAsync(Map<int, bool?> checker) async {
    final tableNames = {
      1: "customers",
      2: "employees",
      3: "installments",
      4: "interest_rates",
      5: "loans",
    };
    try {
      for (final entry in checker.entries) {
        if (entry.value == true) {
          final tableName = tableNames[entry.key];
          print(tableName);
          if (tableName != null) {
            await _database.updateSyncStatus(tableName);
          }
        }
      }
    } catch (e) {
      debugPrint("Update sync status error: $e");
    }
  }

  // final successCount = checker.values.where((v) => v == true).length;
  // if (successCount == 5) {
  //   await _database.updateSyncStatus("customers");
  //   await _database.updateSyncStatus("employees");
  //   await _database.updateSyncStatus("installments");
  //   await _database.updateSyncStatus("interest_rates");
  //   await _database.updateSyncStatus("loans");

  //   debugPrint('Final check statuses after retries: $checker');
  // }

  Future<void> retryFailedMethod(
    int index,
    BuildContext context,
    Map<int, bool?> checker,
  ) async {
    final int? n;
    switch (index) {
      case 1:
        n = await _database.deleteSyncedInstallments("customers");
        debugPrint('Cleared synced customer records: $n');
        checker[1] = await _service.customersTable(context);
        break;
      case 2:
        n = await _database.deleteSyncedInstallments("employees");
        debugPrint('Cleared synced employee records: $n');
        checker[2] = await _service.employeesTable(context);
        break;
      case 3:
        debugPrint("can;t insertt dsad-------");
        n = await _database.deleteSyncedInstallments("installments");
        debugPrint('Cleared synced installment records: $n');
        checker[3] = await _service.installmentsTable(context);
        break;
      case 4:
        n = await _database.deleteSyncedInstallments("interest_rates");
        debugPrint('Cleared synced interest rate records: $n');
        checker[4] = await _service.interestRatesTable(context);
        break;
      // case 5:
      //   final n = await _database.deleteSyncedInstallments("loans");
      //   debugPrint('Cleared synced loan records: $n');
      //   checker[5] = await _service.loansTable(context);
      //   break;
      default:
        debugPrint('Unknown index passed to retry: $index');
        break;
    }
  }
}
