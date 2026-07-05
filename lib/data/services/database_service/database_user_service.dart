import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/new_user_model.dart';
import 'package:nkrs_app/models/user_loan_model.dart';
import 'package:nkrs_app/models/user_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

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

  Future<String?> addCustomerAndLoan(NewUserModel customer) async {
    try {
      final db = await _databaseService.database;

      final customerResult = await db!.query(
        'customers',
        where: 'nic = ?',
        whereArgs: [customer.customerId],
        limit: 1,
      );

      if (customerResult.isNotEmpty) {
        return "Customer exists with NIC :  ${customer.customerId}";
      }

      await db.transaction((txn) async {
        await txn.insert('customers', {
          'nic': customer.customerId,
          'email': customer.email,
          'name': customer.name,
          'phone_number': customer.phoneNumber,
          'address': customer.address,
          'sync': 0,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        await txn.insert('loans', {
          'amount': customer.amount,
          'customer_id': customer.customerId,
          'employee_id': customer.employeeId,
          'installment_id': customer.installmentId,
          'status': 'PENDING',
          'sync': 0,
          'created_at': DateTime.now().toIso8601String(),
        });
      });

      return '';
    } catch (e) {
      return null;
    }
  }

  Future<int?> insertTempUser(int id) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert('temp_user', {
        'id': id,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      return null;
    }
  }

  Future<int?> clearTempUsers() async {
    try {
      final db = await _databaseService.database;
      return await db?.delete('temp_user');
    } catch (e) {
      return null;
    }
  }

  Future<int?> getTempUserId() async {
    try {
      final db = await _databaseService.database;
      final result = await db!.query('temp_user', columns: ['id'], limit: 1);
      if (result.isEmpty) {
        return null;
      }
      return result.first['id'] as int;
    } catch (e) {
      return null;
    }
  }
}
