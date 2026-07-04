import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseInitializerService {
  static final DatabaseInitializerService _instance =
      DatabaseInitializerService._internal();
  static Database? _databse;
  factory DatabaseInitializerService() => _instance;
  DatabaseInitializerService._internal();

  String get filePath => "lankacapital.db";
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
        sync INTEGER DEFAULT 0,
        update_status INTEGER DEFAULT 0,
        active_status INTEGER DEFAULT 0
      )
  ''');
    // create customers table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS customers (
      nic INTEGER PRIMARY KEY,
      address TEXT NOT NULL,
      email TEXT,
      name TEXT NOT NULL,
      phone_number TEXT NOT NULL,
      sync INTEGER DEFAULT 0,
      update_status INTEGER DEFAULT 0,
      active_status INTEGER DEFAULT 0
    )
  ''');
    // create installments table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS installments (
        id INTEGER PRIMARY KEY,
        value INTEGER NOT NULL UNIQUE,
        sync INTEGER DEFAULT 0,
        update_status INTEGER DEFAULT 0
      )
    ''');
    // create interest_rates table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS interest_rates (
        id INTEGER PRIMARY KEY,
        rate REAL NOT NULL UNIQUE,
        sync INTEGER DEFAULT 0,
        update_status INTEGER DEFAULT 0
      )
    ''');
    // create loans table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS loans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      file_number TEXT,
      amount REAL,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      document_charge REAL DEFAULT 0.0,
      interest_rate_id INTEGER,
      customer_id INTEGER NOT NULL,
      employee_id INTEGER NOT NULL,
      installment_id INTEGER NOT NULL,
      rejection_note TEXT,
      status TEXT CHECK(status IN ('APPROVED', 'PENDING', 'REJECTED')) DEFAULT 'PENDING',
      sync INTEGER DEFAULT 0,
      update_status INTEGER DEFAULT 0,
      active_status INTEGER DEFAULT 0,
      FOREIGN KEY (customer_id) REFERENCES customers(nic),
      FOREIGN KEY (employee_id) REFERENCES employees(id),
      FOREIGN KEY (installment_id) REFERENCES installments(id)
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

    await db.execute('''
      CREATE TABLE IF NOT EXISTS temp_customers (
        id INTEGER PRIMARY KEY,
        update_status INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS update_customers (
        id INTEGER PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS temp_emloyees (
        id INTEGER PRIMARY KEY,
        update_status INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS update_emloyees (
        id INTEGER PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS temp_loans (
        id TEXT PRIMARY KEY,
        update_status INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS update_loans (
        id TEXT PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS time (
        id INTEGER PRIMARY KEY,
        last_sync TEXT,
        last_async TEXT
      )
    ''');

    await createTimeTable(db);
  }

  Future<void> createTimeTable(Database db) async {
    try {
      await db.insert('time', {
        'id': 1,
        'last_sync': DateTime.now().toIso8601String(),
        'last_async': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      return;
    }
  }
}
