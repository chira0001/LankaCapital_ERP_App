import 'package:nkrs_app/data/services/database_initializer_service.dart';

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
}
