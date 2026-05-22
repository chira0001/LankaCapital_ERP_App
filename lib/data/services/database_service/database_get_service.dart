import 'package:nkrs_app/data/services/database_initializer_service.dart';

class DatabaseGetService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<List<int>> getCustomerId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'customers',
        columns: ['nic'],
      );
      return maps.map((e) => e['nic'] as int).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Database Error: $e");
      return [];
    }
  }
}
