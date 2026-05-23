import 'package:nkrs_app/data/services/database_initializer_service.dart';

class DatabaseGetService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<List<int>?> getCustomersId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'customers',
        columns: ['nic'],
        where: 'sync = ?',
        whereArgs: [1],
      );
      return maps.map((e) => e['nic'] as int).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<List<int>?> getEmployeesId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'employees',
        columns: ['id'],
        where: 'sync = ?',
        whereArgs: [1],
      );
      return maps.map((e) => e['id'] as int).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<List<String>?> getLoansId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'loans',
        columns: ['file_number'],
        where: 'sync = ?',
        whereArgs: [1],
      );
      return maps.map((e) => e['file_number'].toString()).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Database Error: $e");
      throw Exception(e);
    }
  }
}
