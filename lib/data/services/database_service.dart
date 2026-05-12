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
}
