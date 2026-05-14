import 'package:nkrs_app/data/services/database_initializer_service.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseService {
  final DatabaseInitializerService _databaseService =
      DatabaseInitializerService();

  Future<bool?> isTableExists(String tableName) async {
    final db = await _databaseService.database; //risk
    final result = await db?.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result?.isNotEmpty;
  }

  Future<void> printAllTables() async {
    final db = await _databaseService.database;
    final tables = await db?.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    for (var table in tables!) {
      print("Table: ${table['name']}");
    }
  }

  Future<void> dropTables() async {
    final db = await _databaseService.database;
    await db?.execute('PRAGMA foreign_keys = OFF');
    try {
      await db?.execute('DROP TABLE IF EXISTS loans');
      await db?.execute('DROP TABLE IF EXISTS employees');
      await db?.execute('DROP TABLE IF EXISTS customers');

      print("Tables dropped successfully.");
    } catch (e) {
      print("Error dropping tables: $e");
    } finally {
      // Re-enable foreign keys
      await db?.execute('PRAGMA foreign_keys = ON');
    }
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseService.filePath);
    await deleteDatabase(path);
    print("Database deleted");
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

      print('Customer $name inserted successfully.');
    } catch (e) {
      print('Error inserting customer: $e');
      rethrow;
    }
  }

  Future<void> getAllCustomers() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db!.query('customers');
      print(maps);
      for (var data in maps) {
        print('-----------------------------------');
        print('  NIC:          ${data['nic']}');
        print('  Name:         ${data['name']}');
        print('  Email:        ${data['email']}');
        print('  Address:      ${data['address']}');
        print('  Phone Number: ${data['phone_number']}');
        print('-----------------------------------');
      }
      // return maps;
    } catch (e) {
      print('Error retrieving customers: $e');
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
        print('Successfully deleted customer with NIC: $nic');
      } else {
        print('No customer found with NIC: $nic');
      }
      // return rowsDeleted;
    } catch (e) {
      print('Error deleting customer: $e');
      // return 0;
    }
  }

  Future<int> deleteAllCustomers(String tableName) async {
    try {
      final db = await _databaseService.database;
      final rowsDeleted = await db!.delete(tableName);
      // print('Successfully cleared table. Deleted $rowsDeleted customers.');
      return rowsDeleted;
    } catch (e) {
      // print('Error clearing customers table: $e');
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
    print(customerResult);
    if (customerResult.isEmpty) {
      return null;
    }else{
      
    }

    final loansResult = await db.query(
      'loans',
      where: 'customer_id = ?',
      whereArgs: [nic],
      orderBy: 'created_at DESC',
    );

    return {'customer': customerResult.first, 'loans': loansResult};
  }
}
