import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/interest_rate_model.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:nkrs_app/models/installment_model.dart';
import 'package:nkrs_app/models/user_model.dart';

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

  Future<List<String>?> getInstallmentsId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'installments',
        columns: ['id'],
        where: 'sync = ?',
        whereArgs: [1],
      );
      return maps.map((e) => e['id'].toString()).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<List<String>?> getInterestRatesId() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query(
        'interest_rates',
        columns: ['id'],
        where: 'sync = ?',
        whereArgs: [1],
      );
      return maps.map((e) => e['id'].toString()).toList();
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

  Future<List<InstallmentModel>?> getInstallments() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query('installments');

      return maps.map((e) => InstallmentModel.fromJson(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<List<InterestRateModel>?> getInterestRates() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query('interest_rates');

      return maps.map((e) => InterestRateModel.fromMap(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSyncTime() async {
    try {
      final db = await _databaseService.database;
      final result = await db!.query(
        'time',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      return result.first;
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> getUnsyncedCustomers() async {
    try {
      final db = await _databaseService.database;

      final result = await db!.query(
        'customers',
        where: 'sync = ?',
        whereArgs: [0],
      );

      return result.map(User.fromMapUser).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<AddLoanModel>?> getUnsyncedLoans() async {
    try {
      final db = await _databaseService.database;
      final result = await db!.query(
        'loans',
        where: 'sync = ?',
        whereArgs: [0],
      );
      return result.map(AddLoanModel.fromJson).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
