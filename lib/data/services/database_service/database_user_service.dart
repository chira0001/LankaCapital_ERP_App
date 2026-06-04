import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/user_loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';

class DatabaseUserService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<User?> getUserWithLoans(int customerId) async {
    try {
      final db = await _databaseService.database;
      final customerResult = await db!.query(
        'customers',
        where: 'nic = ?',
        whereArgs: [customerId],
        limit: 1,
      );
      if (customerResult.isEmpty) return null;
      final loanResult = await db.query(
        'loans',
        where: 'customer_id = ?',
        whereArgs: [customerId],
        orderBy: 'created_at DESC',
      );

      final loans = await Future.wait(
        loanResult.map((loan) async {
          final employeeResult = await db.query(
            'employees',
            columns: ['id', 'first_name', 'last_name', 'phone_number'],
            where: 'id = ?',
            whereArgs: [loan['employee_id']],
            limit: 1,
          );

          final installmentResult = await db.query(
            'installments',
            where: 'id = ?',
            whereArgs: [loan['installment_id']],
            limit: 1,
          );

          final interestRateId = loan['interest_rate_id'];

          List<Map<String, dynamic>> interestRateResult = [];

          if (interestRateId != null) {
            interestRateResult = await db.query(
              'interest_rates',
              where: 'id = ?',
              whereArgs: [interestRateId],
              limit: 1,
            );
          }

          final fullLoan = {
            ...loan,
            'employee_id': employeeResult.isNotEmpty
                ? employeeResult.first
                : null,
            'installment_id': installmentResult.isNotEmpty
                ? installmentResult.first
                : null,
            'interest_rate_id': interestRateResult.isNotEmpty
                ? interestRateResult.first
                : null,
          };

          return UserLoanModel.fromMap(fullLoan);
        }),
      );
      final userMap = {...customerResult.first, 'loans': loans};
      return User.fromMapUser(userMap);
    } catch (e) {
      return null;
    }
  }
}
