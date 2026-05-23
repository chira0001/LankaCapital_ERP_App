import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabasePutService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<int?> insertDataToCustomer(Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert(
        'customers',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null; 
    //   throw Exception('Failed to insert customer: $e');
    }
  }

  Future<int?> insertDataToEmployee(Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert(
        'employees',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null; 
    //   throw Exception('Failed to insert employee: $e');
    }
  }
}
