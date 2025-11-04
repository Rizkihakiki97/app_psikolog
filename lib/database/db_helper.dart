import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mindcare.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE roles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doctorName TEXT,
        specialization TEXT,
        date TEXT,
        time TEXT,
        active INTEGER
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
