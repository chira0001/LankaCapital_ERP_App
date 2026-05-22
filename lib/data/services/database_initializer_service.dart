import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseInitializerService {
  static final DatabaseInitializerService _instance =
      DatabaseInitializerService._internal();
  static Database? _databse;
  factory DatabaseInitializerService() => _instance;
  DatabaseInitializerService._internal();

  String get filePath => "lankacapitals.db";
  final String password = "1234";

  Future<Database?> get database async {
    if (_databse != null) return _databse;
    return _databse = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

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
        id INTEGER PRIMARY KEY,
        address TEXT,
        email TEXT NOT NULL UNIQUE,
        first_name TEXT,
        last_name TEXT,
        nic INTEGER NOT NULL UNIQUE,
        phone_number TEXT,
        sync INTEGER DEFAULT 0
      )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS customers (
      nic INTEGER PRIMARY KEY,
      address TEXT,
      email TEXT,
      name TEXT,
      phone_number TEXT,
      sync INTEGER DEFAULT 0
    )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS loans (
      file_number TEXT PRIMARY KEY,
      amount REAL,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      interest_rate REAL,
      customer_id INTEGER,
      employee_id INTEGER,
      no_of_installments REAL,
      rejection_note TEXT,
      risk TEXT CHECK(risk IN ('HIGH', 'LOW', 'MEDIUM')),
      status TEXT CHECK(status IN ('APPROVED', 'PENDING', 'REJECTED'))DEFAULT 'PENDING',
      sync INTEGER DEFAULT 0,
      FOREIGN KEY (customer_id)
        REFERENCES customers(nic),
      FOREIGN KEY (employee_id)
        REFERENCES employees(id)
    )
  ''');
    // create collections table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS collections (
        receipt_id VARCHAR(255) PRIMARY KEY,
        file_number VARCHAR(255),
        collection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        premium_amount DECIMAL(12,2),
        paid_amount DECIMAL(12,2),
        due_amount DECIMAL(12,2),
        collected_by VARCHAR(255),
        FOREIGN KEY (file_number) REFERENCES loans(file_number) ON DELETE CASCADE
      )
    ''');
  }
}
