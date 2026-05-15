import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseInitializerService {
  static final DatabaseInitializerService _instance = DatabaseInitializerService._internal();
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