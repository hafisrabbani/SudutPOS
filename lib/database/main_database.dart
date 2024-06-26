import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Product(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        createdTime TEXT NOT NULL,
        updatedTime TEXT NOT NULL,
        stock INTEGER NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE TransactionRecord(
      id INTEGER PRIMARY KEY,
      nominalPayment REAL NOT NULL,
      total REAL NOT NULL,
      tableNumber INTEGER NOT NULL,
      change REAL NOT NULL,
      discType TINYINT NOT NULL,
      discValue REAL NOT NULL,
      createdTime TEXT NOT NULL
    )
  ''');

    await db.execute('''
      CREATE TABLE TransactionDetail(
        id INTEGER PRIMARY KEY,
        transactionId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (transactionId) REFERENCES TransactionRecord(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES Product(id) ON DELETE CASCADE
      )
    ''');


    await db.execute('''
      CREATE TABLE AppSetting(
        id INTEGER PRIMARY KEY,
        key TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
