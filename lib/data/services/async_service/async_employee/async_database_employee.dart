import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_employee_model.dart';
import 'package:nkrs_app/models/update_model/employee_update.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AsyncDatabaseEmployee {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<bool?> insertTempEmployee(List<ManageEmployeeModel> data) async {
    try {
      final db = await _databaseService.database;
      print("update");
      await db!.transaction((txn) async {
        for (final employee in data) {
          final existing = await txn.query(
            'employees',
            where: 'id = ?',
            whereArgs: [employee.employeeIds],
            limit: 1,
          );

          if (existing.isNotEmpty) {
            final localCustomer = existing.first;
            await txn.update(
              'employees',
              {'active_status': 1},
              where: 'id = ?',
              whereArgs: [employee.employeeIds],
            );

            if (localCustomer['update_status'] != employee.updateStatus) {
              print(employee.employeeIds);
              await txn.insert('update_emloyees', {
                'id': employee.employeeIds,
              }, conflictAlgorithm: ConflictAlgorithm.ignore);
            }
          } else {
            await txn.insert('temp_emloyees', {
              'id': employee.employeeIds,
              'update_status': employee.updateStatus,
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });

      return true;
    } catch (e) {
      print("Manage Employee Update Error: $e");
      return null;
    }
  }

  Future<void> clearTempEmployee() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('temp_emloyees');
    } catch (e) {
      print("Clear Temp Employee Error: $e");
      return;
    }
  }

  Future<void> clearUpdateEmployee() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('update_emloyees');
    } catch (e) {
      print("Clear Temp Employee Error: $e");
      return;
    }
  }

  Future<List<int>> getEmployeesIds({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'temp_emloyees',
        columns: ['id'],
        limit: limit,
        offset: offset,
      );

      return maps.map((e) => e['id'] as int).toList();
    } catch (e) {
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<List<int>> getUpdateEmployees({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'update_emloyees',
        columns: ['id'],
        limit: limit,
        offset: offset,
      );

      return maps.map((e) => e['id'] as int).toList();
    } catch (e) {
      print("Database Error: $e");
      throw Exception(e);
    }
  }

  Future<int?> insertEmployeeToTable(EmployeeUpdate data) async {
    try {
      final db = await _databaseService.database;
      final values = {...data.toLocal(), 'active_status': 1};
      return await db?.insert(
        'employees',
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null;
      //   throw Exception('Failed to insert customer: $e');
    }
  }

  Future<bool> deleteEmployees() async {
    try {
      final db = await _databaseService.database;
      await db!.delete(
        'employees',
        where: 'active_status = ? AND sync = ?',
        whereArgs: [0, 2],
      );

      return true;
    } catch (e) {
      print("Delete Employees Error: $e");
      return false;
    }
  }

  Future<void> resetEmployees() async {
    try {
      final db = await _databaseService.database;
      await db!.update(
        'employees',
        {'active_status': '0'},
        where: 'active_status = ? AND sync = ?',
        whereArgs: [1, 2],
      );
    } catch (e) {
      print("Reset Customers Error: $e");
    }
  }

  Future<int?> updateEmployeeToTable(EmployeeUpdate data) async {
    try {
      final db = await _databaseService.database;
      return await db?.update(
        'employees',
        data.toUpdateDatabase(),
        where: 'id = ?',
        whereArgs: [data.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Update employees Error: $e");
      return null;
    }
  }
}
