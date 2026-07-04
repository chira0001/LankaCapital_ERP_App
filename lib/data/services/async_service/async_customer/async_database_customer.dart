import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:nkrs_app/models/async_manage_model/manage_customer_model.dart';
import 'package:nkrs_app/models/update_model/customer_update.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AsyncDatabaseCustomer {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<bool?> insertTempCustomers(List<ManageCustomerModel> data) async {
    try {
      final db = await _databaseService.database;
      print("update");
      await db!.transaction((txn) async {
        for (final customer in data) {
          final existing = await txn.query(
            'customers',
            where: 'nic = ?',
            whereArgs: [customer.customerIds],
            limit: 1,
          );

          if (existing.isNotEmpty) {
            final localCustomer = existing.first;
            await txn.update(
              'customers',
              {'active_status': 1},
              where: 'nic = ?',
              whereArgs: [customer.customerIds],
            );

            if (localCustomer['update_status'] != customer.updateStatus) {
              print(customer.customerIds);
              await txn.insert('update_customers', {
                'id': customer.customerIds,
              }, conflictAlgorithm: ConflictAlgorithm.ignore);
            }
          } else {
            await txn.insert('temp_customers', {
              'id': customer.customerIds,
              'update_status': customer.updateStatus,
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });

      return true;
    } catch (e) {
      print("Manage Customer Update Error: $e");
      return null;
    }
  }

  Future<void> clearTempCustomers() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('temp_customers');
    } catch (e) {
      print("Clear Temp Customers Error: $e");
      return;
    }
  }

  Future<void> clearUpdateCustomers() async {
    try {
      final db = await _databaseService.database;
      await db!.delete('update_customers');
    } catch (e) {
      print("Clear Temp Customers Error: $e");
      return;
    }
  }

  Future<List<int>> getCustomersIds({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'temp_customers',
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

  Future<List<int>> getUpdateCustomers({int limit = 10, int offset = 0}) async {
    try {
      final db = await _databaseService.database;
      final maps = await db!.query(
        'update_customers',
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

  Future<int?> insertCustomerToTable(CustomerUpdate data) async {
    try {
      final db = await _databaseService.database;
      final values = {...data.toLocal(), 'active_status': 1};
      return await db?.insert(
        'customers',
        values,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return null;
      //   throw Exception('Failed to insert customer: $e');
    }
  }

  Future<bool> deleteCustomers() async {
    try {
      final db = await _databaseService.database;
      await db!.delete(
        'customers',
        where: 'active_status = ? AND sync = ?',
        whereArgs: [0, 2],
      );

      return true;
    } catch (e) {
      print("Delete Customers Error: $e");
      return false;
    }
  }

  Future<void> resetCustomers() async {
    try {
      final db = await _databaseService.database;
      await db!.update(
        'customers',
        {'active_status': '0'},
        where: 'active_status = ? AND sync = ?',
        whereArgs: [1, 2],
      );
    } catch (e) {
      print("Reset Customers Error: $e");
    }
  }

  Future<int?> updateCustomerToTable(CustomerUpdate data) async {
    try {
      final db = await _databaseService.database;
      print("--------------------------");
      return await db?.update(
        'customers',
        data.toUpdateDatabase(),
        where: 'nic = ?',
        whereArgs: [data.nic],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Update Customer Error: $e");
      return null;
    }
  }

  Future<void> printUpdateCustomers() async {
    try {
      final db = await _databaseService.database;

      final List<Map<String, dynamic>> result = await db!.query(
        'update_customers',
      );

      if (result.isEmpty) {
        print('update_customers table is empty.');
        return;
      }

      print('===== update_customers =====');
      for (final row in result) {
        print(row);
      }
    } catch (e) {
      print('Print Update Customers Error: $e');
    }
  }
}
