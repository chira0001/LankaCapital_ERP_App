import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _databse;
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final String _filePath = "lankacapitals.db";
  final String password = "1234";

  Future<Database?> get database async {
    if (_databse != null) return _databse;
    return _databse = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _filePath);

    return await openDatabase(
      path,
      password: password,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // create employee table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        nic BIGINT NOT NULL,
        phone_number VARCHAR(255) NOT NULL
      )
    ''');
    // create customer table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        nic BIGINT PRIMARY KEY,
        address VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        name VARCHAR(255) NOT NULL,
        phone_number VARCHAR(255) NOT NULL
      )
    ''');
    // create loan table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS loans (
        file_number VARCHAR(255) PRIMARY KEY,
        amount DECIMAL(12,2),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        interest_rate DOUBLE,
        customer_id BIGINT,
        employee_id BIGINT,
        no_of_installments DOUBLE,
        rejection_note VARCHAR(1000),
        risk TEXT CHECK(risk IN ('HIGH', 'LOW', 'MEDIUM')),
        status TEXT CHECK(status IN ('APPROVED', 'PENDING', 'REJECTED')),
        FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
        FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
      )
    ''');
  }

  Future<bool?> isTableExists(String tableName) async {
    //risk
    final db = await DatabaseService._instance.database;
    final result = await db?.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      ["employees"],
    );
    return result?.isNotEmpty;
  }

  Future<void> printAllTables() async {
    final db = await _instance.database;
    final tables = await db?.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    for (var table in tables!) {
      print("Table: ${table['name']}");
    }
  }

  Future<void> dropTables() async {
    final db = await _instance.database;
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
    final path = join(dbPath, 'loan_system.db');
    await deleteDatabase(path);
    print("Database deleted");
  }

  Future close() async {
    final db = await _instance.database;
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
      final db = await _instance.database;
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
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Replaces old data if NIC/Email duplicates
      );

      print('Customer $name inserted successfully.');
    } catch (e) {
      print('Error inserting customer: $e');
      rethrow;
    }
  }

  Future<void> getAllCustomers() async {
    try {
      final db = await _instance.database;
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
      final db = await _instance.database;
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
      final db = await _instance.database;
      final rowsDeleted = await db!.delete(tableName);
      // print('Successfully cleared table. Deleted $rowsDeleted customers.');
      return rowsDeleted;
    } catch (e) {
      // print('Error clearing customers table: $e');
      return 0;
    }
  }
}
