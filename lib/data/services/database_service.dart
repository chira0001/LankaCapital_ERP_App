import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  // Future<bool?> isTableExists(String tableName) async {
  //   final db = await _databaseService.database; //risk
  //   final result = await db?.rawQuery(
  //     "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
  //     [tableName],
  //   );
  //   return result?.isNotEmpty;
  // }

  Future<void> printAllTables() async {
    final db = await _databaseService.database;
    final tables = await db?.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    for (var table in tables!) {
      debugPrint("Table: ${table['name']}");
    }
  }

  Future<void> dropTables() async {
    final db = await _databaseService.database;
    await db?.execute('PRAGMA foreign_keys = OFF');
    try {
      await db?.execute('DROP TABLE IF EXISTS loans');
      await db?.execute('DROP TABLE IF EXISTS employees');
      await db?.execute('DROP TABLE IF EXISTS customers');
      await db?.execute('DROP TABLE IF EXISTS installments');

      debugPrint("Tables dropped successfully.");
    } catch (e) {
      debugPrint("Error dropping tables: $e");
    } finally {
      // Re-enable foreign keys
      await db?.execute('PRAGMA foreign_keys = ON');
    }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseService.filePath);
    await deleteDatabase(path);
    debugPrint("Database deleted");
  }

  Future close() async {
    final db = await _databaseService.database;
    db?.close();
  }

  Future<void> insertCustomer({
    required int nic,
    required String address,
    required String email,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final db = await _databaseService.database;
      final Map<String, dynamic> customerData = {
        'nic': nic,
        'address': address,
        'email': email,
        'name': name,
        'phone_number': phoneNumber,
      };

      // 2. Use conflictAlgorithm to handle duplicate emails/NICs gracefully
      await db?.insert(
        'customers',
        customerData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('Customer $name inserted successfully.');
    } catch (e) {
      debugPrint('Error inserting customer: $e');
      rethrow;
    }
  }

  Future<void> getAllCustomers() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query('customers');
      debugPrint(maps.toString());
      for (var data in maps) {
        debugPrint('-----------------------------------');
        debugPrint('  NIC:          ${data['nic']}');
        debugPrint('  Name:         ${data['name']}');
        debugPrint('  Email:        ${data['email']}');
        debugPrint('  Address:      ${data['address']}');
        debugPrint('  Phone Number: ${data['phone_number']}');
        debugPrint('  Sync:         ${data['sync']}');
        debugPrint('-----------------------------------');
      }
      // return maps;
    } catch (e) {
      debugPrint('Error retrieving customers: $e');
      // return [];
    }
  }

  Future<void> deleteCustomerByNic(int nic) async {
    try {
      final db = await _databaseService.database;
      final rowsDeleted = await db!.delete(
        'customers',
        where: 'nic = ?',
        whereArgs: [nic],
      );
      if (rowsDeleted > 0) {
        debugPrint('Successfully deleted customer with NIC: $nic');
      } else {
        debugPrint('No customer found with NIC: $nic');
      }
      // return rowsDeleted;
    } catch (e) {
      debugPrint('Error deleting customer: $e');
      // return 0;
    }
  }

  Future<int> deleteAllCustomers(String tableName) async {
    try {
      final db = await _databaseService.database;
      final rowsDeleted = await db!.delete(tableName);
      // debugPrint('Successfully cleared table. Deleted $rowsDeleted customers.');
      return rowsDeleted;
    } catch (e) {
      // debugPrint('Error clearing customers table: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>?> getCustomerWithLoans(int nic) async {
    final db = await _databaseService.database;
    final customerResult = await db!.query(
      'customers',
      where: 'nic = ?',
      whereArgs: [nic],
    );
    debugPrint(customerResult.toString());
    if (customerResult.isEmpty) {
      return null;
    } else {}

    final loansResult = await db.query(
      'loans',
      where: 'customer_id = ?',
      whereArgs: [nic],
      orderBy: 'created_at DESC',
    );

    return {'customer': customerResult.first, 'loans': loansResult};
  }

  Future<void> insertCollection({
    required String receiptId,
    required String fileNumber,
    required double premiumAmount,
    required double paidAmount,
    required double dueAmount,
    required String collectedBy,
  }) async {
    try {
      final db = await _databaseService.database;
      final Map<String, dynamic> collectionData = {
        'receipt_id': receiptId,
        'file_number': fileNumber,
        'premium_amount': premiumAmount,
        'paid_amount': paidAmount,
        'due_amount': dueAmount,
        'collected_by': collectedBy,
        'collection_date': DateTime.now().toIso8601String(),
      };

      await db?.insert(
        'collections',
        collectionData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Collection $receiptId inserted successfully.');
    } catch (e) {
      debugPrint('Error inserting collection: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTodayCollections() async {
    try {
      final db = await _databaseService.database;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final List<Map<String, dynamic>> maps = await db!.query(
        'collections',
        where: 'collection_date LIKE ?',
        whereArgs: ['$today%'],
        orderBy: 'collection_date DESC',
      );
      return maps;
    } catch (e) {
      debugPrint('Error retrieving today\'s collections: $e');
      return [];
    }
  }

  Future<bool> deleteAllData(String table) async {
    try {
      final db = await _databaseService.database;
      await db!.delete(table);
      return true;
    } catch (e) {
      debugPrint("Delete Employees Error: $e");
      return false;
    }
  }

  Future<void> getAllTableData(String table) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> employees = await db!.query(table);
      print("----------------------");
      for (var employee in employees) {
        // print("----------------------");
        // print("ID : ${employee['id']}");
        // print("First Name : ${employee['first_name']}");
        // print("Last Name : ${employee['last_name']}");
        // print("Email : ${employee['email']}");
        // print("NIC : ${employee['nic']}");
        // print("Phone : ${employee['phone_number']}");
        // print("Address : ${employee['address']}");
        // print("Sync : ${employee['sync']}");
        print(employee);
      }
      print("----------------------");
      // return employees;
    } catch (e) {
      debugPrint("Get Employees Error: $e");
    }
  }

  Future<double> getTotalPastDueAmount(List<String> fileNumbers) async {
    if (fileNumbers.isEmpty) return 0.0;
    try {
      final db = await _databaseService.database;

      // Ensure table exists before querying
      await db?.execute('''
        CREATE TABLE IF NOT EXISTS daily_collections (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          receipt_id TEXT,
          file_number TEXT,
          premium_amount REAL,
          paid_amount REAL,
          due_amount REAL,
          collected_by TEXT,
          collection_date TEXT
        )
      ''');

      final placeholders = List.filled(fileNumbers.length, '?').join(',');
      final result = await db?.rawQuery(
        'SELECT SUM(due_amount) as total_due FROM daily_collections WHERE file_number IN ($placeholders)',
        fileNumbers,
      );
      if (result != null && result.isNotEmpty && result.first['total_due'] != null) {
        return (result.first['total_due'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      debugPrint('Error getting total past due amount: $e');
      return 0.0;
    }
  }
}
