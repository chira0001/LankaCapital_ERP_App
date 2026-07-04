import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_customer_model.dart';
import 'package:nkrs_app/models/update_model/customer_update.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseAsyncService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<int?> updateSyncStatus(String n) async {
    try {
      final db = await _databaseService.database;
      return await db!.update(
        n,
        {'sync': 1},
        where: 'sync = ?',
        whereArgs: [2],
      );
    } catch (e) {
      return null;
    }
  }

  Future<int?> deleteSyncedInstallments(String n) async {
    try {
      final db = await _databaseService.database;
      return await db!.delete(n, where: 'sync = ?', whereArgs: [2]);
    } catch (e) {
      return null;
    }
  }

  Future<int?> updateSyncTime(int n) async {
    try {
      final db = await _databaseService.database;
      final column = n == 0 ? 'last_sync' : 'last_async';
      return await db!.update(
        'time',
        {column: DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [1],
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateAsync(Map<int, bool?> checker) async {
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
          if (tableName != null) {
            await updateSyncStatus(tableName);
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<int?> removeDuplicateUuidLoans() async {
    final db = await _databaseService.database;
    try {
      final deletedCount = await db?.rawDelete('''
        DELETE FROM loans
        WHERE file_number NOT LIKE 'D%'
          AND EXISTS (
            SELECT 1
            FROM loans AS serverLoan
            WHERE serverLoan.customer_id = loans.customer_id
              AND serverLoan.employee_id = loans.employee_id
              AND serverLoan.created_at = loans.created_at
              AND serverLoan.file_number LIKE 'D%'
          )
      ''');
      return deletedCount;
    } catch (e) {
      return null;
    }
  }

  // Future<bool?> insertTempCustomers(List<ManageCustomerModel> data) async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db!.transaction((txn) async {
  //       for (final customer in data) {
  //         await txn.insert('temp_customers', customer.toLocal());
  //       }
  //     });
  //     return true;
  //   } catch (e) {
  //     print("Manage Customer Insert Error: $e");
  //     return null;
  //   }
  // }

  // Future<bool?> insertTempCustomers(List<ManageCustomerModel> data) async {
  //   try {
  //     final db = await _databaseService.database;

  //     await db!.transaction((txn) async {
  //       for (final customer in data) {
  //         final existing = await txn.query(
  //           'customers',
  //           where: 'nic = ?',
  //           whereArgs: [customer.customerIds],
  //           limit: 1,
  //         );

  //         if (existing.isNotEmpty) {
  //           final localCustomer = existing.first;
  //           await txn.update(
  //             'customers',
  //             {'active_status': 1},
  //             where: 'nic = ?',
  //             whereArgs: [customer.customerIds],
  //           );

  //           if (localCustomer['update_status'] != customer.updateStatus) {
  //             await txn.insert('update_customers', {
  //               'id': customer.customerIds,
  //             }, conflictAlgorithm: ConflictAlgorithm.ignore);
  //           }
  //         } else {
  //           await txn.insert('temp_customers', {
  //             'id': customer.customerIds,
  //             'update_status': customer.updateStatus,
  //           }, conflictAlgorithm: ConflictAlgorithm.replace);
  //         }
  //       }
  //     });

  //     return true;
  //   } catch (e) {
  //     print("Manage Customer Update Error: $e");
  //     return null;
  //   }
  // }

  // Future<void> clearTempCustomers() async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db!.delete('temp_customers');
  //   } catch (e) {
  //     print("Clear Temp Customers Error: $e");
  //     return;
  //   }
  // }

  // Future<void> clearUpdateCustomers() async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db!.delete('update_customers');
  //   } catch (e) {
  //     print("Clear Temp Customers Error: $e");
  //     return;
  //   }
  // }

  // Future<List<int>> getCustomersIds({int limit = 10, int offset = 0}) async {
  //   try {
  //     final db = await _databaseService.database;
  //     final maps = await db!.query(
  //       'temp_customers',
  //       columns: ['id'],
  //       limit: limit,
  //       offset: offset,
  //     );

  //     return maps.map((e) => e['id'] as int).toList();
  //   } catch (e) {
  //     print("Database Error: $e");
  //     throw Exception(e);
  //   }
  // }

  // Future<List<int>> getUpdateCustomers({int limit = 10, int offset = 0}) async {
  //   try {
  //     final db = await _databaseService.database;
  //     final maps = await db!.query(
  //       'temp_customers',
  //       columns: ['id'],
  //       limit: limit,
  //       offset: offset,
  //     );

  //     return maps.map((e) => e['id'] as int).toList();
  //   } catch (e) {
  //     print("Database Error: $e");
  //     throw Exception(e);
  //   }
  // }

  // Future<int?> insertCustomerToTable(CustomerUpdate data) async {
  //   try {
  //     final db = await _databaseService.database;
  //     return await db?.insert(
  //       'customers',
  //       data.toLocal(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } catch (e) {
  //     return null;
  //     //   throw Exception('Failed to insert customer: $e');
  //   }
  // }

  // Future<void> deleteCustomers() async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db!.delete(
  //       'customers',
  //       where: 'active_status = ? AND sync = ?',
  //       whereArgs: [0, 1],
  //     );
  //   } catch (e) {
  //     print("Delete Customers Error: $e");
  //   }
  // }

  // Future<void> resetCustomers() async {
  //   try {
  //     final db = await _databaseService.database;
  //     await db!.update(
  //       'customers',
  //       {'active_status': 0},
  //       where: 'active_status = ? AND sync = ?',
  //       whereArgs: [1, 1],
  //     );
  //   } catch (e) {
  //     print("Reset Customers Error: $e");
  //   }
  // }

  // Future<int?> updateCustomerToTable(CustomerUpdate data) async {
  //   try {
  //     final db = await _databaseService.database;
  //     return await db?.update(
  //       'customers',
  //       data.toUpdateDatabase(),
  //       where: 'nic = ?',
  //       whereArgs: [data.nic],
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } catch (e) {
  //     print("Update Customer Error: $e");
  //     return null;
  //   }
  // }
}
