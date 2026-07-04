import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_loan_model.dart';
import 'package:nkrs_app/models/update_model/loan_update.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AsyncDatabaseLoan {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<bool?> insertTempCustomers(List<ManageLoanModel> data) async {
    try {
      final db = await _databaseService.database;
      print("update");
      await db!.transaction((txn) async {
        for (final loan in data) {
          final existing = await txn.query(
            'loans',
            where: 'file_number = ?',
            whereArgs: [loan.loanIds],
            limit: 1,
          );

          if (existing.isNotEmpty) {
            final localCustomer = existing.first;
            await txn.update(
              'loans',
              {'active_status': 1},
              where: 'file_number = ?',
              whereArgs: [loan.loanIds],
            );

            if (localCustomer['update_status'].toString() !=
                loan.updateStatus.toString()) {
              print(loan.loanIds);
              await txn.insert('update_loans', {
                'id': loan.loanIds.toString(),
              }, conflictAlgorithm: ConflictAlgorithm.ignore);
            }
          } else {
            await txn.insert('temp_loans', {
              'id': loan.loanIds,
              'update_status': loan.updateStatus,
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });

      return true;
    } catch (e) {
      print("Manage Loan Update Error: $e");
      return null;
    }
  }

  Future<void> clearTempLoans() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('temp_loans');
    } catch (e) {
      print("Clear Temp Customers Error: $e");
      return;
    }
  }

  Future<void> clearUpdateLoans() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('update_loans');
    } catch (e) {
      print("Clear Temp Customers Error: $e");
      return;
    }
  }

  Future<List<String>> getLoansIds({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'temp_loans',
        columns: ['id'],
        limit: limit,
        offset: offset,
      );

      return maps.map((e) => e['id'] as String).toList();
    } catch (e) {
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<List<String>> getUpdateLoans({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'update_loans',
        columns: ['id'],
        limit: limit,
        offset: offset,
      );

      return maps.map((e) => e['id'] as String).toList();
    } catch (e) {
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<int?> insertLoanToTable(LoanUpdate data) async {
    try {
      final db = await _databaseService.database;
      final values = {...data.toLocal(), 'active_status': 1};
      return await db?.insert(
        'loans',
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Insert Loan Error: $e");
      return null;
    }
  }

  Future<bool> deleteLoans() async {
    try {
      final db = await _databaseService.database;
      await db!.delete(
        'loans',
        where: '(active_status = ? OR active_status IS NULL) AND sync = ?',
        whereArgs: [0, 2],
      );
      return true;
    } catch (e) {
      print("Delete Loan Error: $e");
      return false;
    }
  }

  Future<void> resetLoans() async {
    try {
      final db = await _databaseService.database;
      await db!.update(
        'loans',
        {'active_status': '0'},
        where: 'active_status = ? AND sync = ?',
        whereArgs: [1, 2],
      );
    } catch (e) {
      print("Reset Loans Error: $e");
    }
  }

  Future<int?> updateLoanToTable(LoanUpdate data) async {
    try {
      final db = await _databaseService.database;
      return await db?.update(
        'loans',
        data.toUpdateDatabase(),
        where: 'file_number = ?',
        whereArgs: [data.fileNumber.toString()],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Update Loan Error: $e");
      return null;
    }
  }
}
