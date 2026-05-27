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
}
