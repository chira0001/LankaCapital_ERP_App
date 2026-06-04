import 'package:nkrs_app/data/services/database_initializer_service.dart';

class DatabaseSyncService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<void> updateEmployeesSync(List<int> ids) async {
    final db = await _databaseService.database;
    try {
      for (final id in ids) {
        await db!.update(
          'employees',
          {'sync': 1},
          where: 'id = ? AND sync = ?',
          whereArgs: [id, 0],
        );
      }
    } catch (e) {
      return;
    }
  }

  Future<void> deleteSyncedLoans(List<int> successKeys) async {
    try {
      if (successKeys.isEmpty) return;
      final db = await _databaseService.database;
      final placeholders = List.filled(successKeys.length, '?').join(',');
      await db!.rawDelete('''
      DELETE FROM loans WHERE sync = 0 AND id IN ($placeholders)
      ''', successKeys);
    } catch (e) {
      return;
    }
  }

  Future<int?> updateCustomersSync(List<int> ids) async {
    final db = await _databaseService.database;
    try {
      if (ids.isEmpty) return 0;
      final placeholders = List.filled(ids.length, '?').join(',');
      return await db!.rawUpdate(
        'UPDATE customers SET sync = 1 WHERE sync = 0 AND nic IN ($placeholders)',
        ids,
      );
    } catch (e) {
      return null;
    }
  }

  // Future<List<User>> syncUpdate(List<int> customerIds) async {
  //   try {
  //     if (customerIds.isEmpty) return [];
  //     final db = await _databaseService.database;
  //     final placeholders = List.filled(customerIds.length, '?').join(',');
  //     final result = await db!.rawQuery('''
  //     SELECT *
  //     FROM customers
  //     WHERE sync = 0
  //     AND nic IN ($placeholders)
  //     ''', customerIds);
  //     return result.map(User.fromMapUser).toList();
  //   } catch (e) {
  //     print('getCustomersByIdsAndUnsynced: $e');
  //     return [];
  //   }
  // }

  Future<void> resetCustomerSync() async {
    try {
      final db = await _databaseService.database;
      await db!.update(
        'customers',
        {'sync': 0},
        where: 'sync = ?',
        whereArgs: [1],
      );
      await db.update('loans', {'sync': 0}, where: 'sync = ?', whereArgs: [1]);
    } catch (e) {
      return;
    }
  }
}
