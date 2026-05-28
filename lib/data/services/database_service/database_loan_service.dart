import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/user_loan_model.dart';

class DatabaseLoanService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<List<UserLoanModel>?> getLoansByCustomerId(int customerId) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> result = await db!.query(
        'loans',
        where: 'customer_id = ?',
        whereArgs: [customerId],
        orderBy: 'created_at DESC',
      );
      return result.map((e) => UserLoanModel.fromMap(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<int?> deleteInvalidFileNumberLoans() async {
    try {
      final db = await _databaseService.database;
      return await db!.delete(
        'loans',
        where: '''
        (file_number IS NULL OR file_number = ?)
        AND sync = ?
      ''',
        whereArgs: ['', 1],
      );
    } catch (e) {
      return null;
    }
  }
}
