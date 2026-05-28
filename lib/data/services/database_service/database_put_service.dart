import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/add_loan_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabasePutService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<int?> insertDataToCustomers(Map<String, dynamic> data) async {
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

  Future<int?> insertDataToEmployees(Map<String, dynamic> data) async {
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

  Future<int?> insertDataToinstallments(Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert(
        'installments',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null;
      //   throw Exception('Failed to insert employee: $e');
    }
  }

  Future<int?> insertDataToInterests(Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert(
        'interest_rates',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null;
      //   throw Exception('Failed to insert employee: $e');
    }
  }

  Future<int?> insertDataToLoans(Map<String, dynamic> data) async {
    try {
      final db = await _databaseService.database;
      return await db?.insert(
        'loans',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null;
      //   throw Exception('Failed to insert employee: $e');
    }
  }

  Future<String?> insertExistingLoan(AddLoanModel loan) async {
    try {
      final db = await _databaseService.database;
      int? u = await db?.insert(
        'loans',
        loan.toJsonServer(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (u != null) {
        return "";
      }
      return null;
    } catch (e) {
      debugPrint("Loan Insert Error : $e");
      return null;
    }
  }

  Future<int?> insertCustomer() async {
    return 1;
  }
}
