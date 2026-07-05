// // ignore_for_file: use_build_context_synchronously
// import 'package:flutter/material.dart';
// import 'package:nkrs_app/data/services/database_service/database_async_service.dart';
// import 'package:nkrs_app/data/view_model/async_database_table.dart';
// import 'package:nkrs_app/data/view_model/check_connection.dart';
// import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message.dart';
// import 'package:nkrs_app/views/new_loan_request_view/utility/scaffold_message_bottom.dart';

// class AsyncControllerViewModel {
//   final AsyncDatabaseTable _service = AsyncDatabaseTable();
//   final DatabaseAsyncService _database = DatabaseAsyncService();

//   Future<void> asyncController(BuildContext context) async {
//     if (!CheckConnection.isOnline.value) {
//       AppTopSnackBar.wifi(
//         context,
//         "Device is offline. Turn on mobile data to continue.",
//       );
//       return;
//     }
//     bool anyParentFailed = false;
//     final Map<int, bool?> checker = {};
//     try {
//       final results = await Future.wait<bool?>([
//         _service.customersTable(context), // 1
//         _service.employeesTable(context), // 2
//         _service.installmentsTable(context), // 3
//         _service.interestRatesTable(context), // 4
//       ]);

//       checker[1] = results[0];
//       checker[2] = results[1];
//       checker[3] = results[2];
//       checker[4] = results[3];

//       for (final entry in checker.entries) {
//         if (entry.value != true || entry.value == null) {
//           anyParentFailed = true;
//           final failedIndex = entry.key;
//           await retryFailedMethod(failedIndex, context, checker);
//         }
//       }

//       if (!anyParentFailed) {
//         checker[5] = await _service.loansTable(context);
//         if (checker[5] == false || checker[5] == null) {
//           final _ = await _database.deleteSyncedInstallments("loans");
//           checker[5] = await _service.loansTable(context);
//         }
//       } else {
//         final successCount = checker.values.where((v) => v == true).length;
//         if (successCount == 4) {
//           checker[5] = await _service.loansTable(context);
//         }
//       }
//       await _database.updateAsync(checker);
//       final successCount = checker.values.where((v) => v == true).length;
//       if (successCount == 5) {
//         await _database.updateSyncTime(1);
//         int? num = await _database.removeDuplicateUuidLoans();
//         print(num);
//         AppTopSnackBar.success(context, "Async completed successfully.");
//       }
//       //   AppTopSnackBar.error(
//       //     context,
//       //     "Loan sync failed. Other data synced successfully.",
//       //   );
//       // }
//     } catch (e) {
//       ScaffoldMessageBottom.show(
//         context,
//         "An error occurred during sync controller execution: $e'",
//       );
//     }
//   }

//   Future<void> retryFailedMethod(
//     int index,
//     BuildContext context,
//     Map<int, bool?> checker,
//   ) async {
//     switch (index) {
//       case 1:
//         await _database.deleteSyncedInstallments("customers");
//         checker[1] = await _service.customersTable(context);
//         break;
//       case 2:
//         await _database.deleteSyncedInstallments("employees");
//         checker[2] = await _service.employeesTable(context);
//         break;
//       case 3:
//         debugPrint("can;t insertt dsad-------");
//         await _database.deleteSyncedInstallments("installments");
//         checker[3] = await _service.installmentsTable(context);
//         break;
//       case 4:
//         await _database.deleteSyncedInstallments("interest_rates");
//         checker[4] = await _service.interestRatesTable(context);
//         break;
//       default:
//         AppTopSnackBar.error(context, 'Unknown index passed to retry: $index');
//         break;
//     }
//   }
// }
