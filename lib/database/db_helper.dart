import 'package:app_psikolog/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, bio TEXT, role TEXT, usia INTEGER, riwayat TEXT, lisensi TEXT, spesialisasi TEXT, jadwal TEXT, aktif INTEGER, foto TEXT, password TEXT)
''');
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

  static Future<void> createUser(UserModel user) async {
    final dbs = await instance.database;
    await dbs.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await instance.database;
    final List<Map<String, dynamic>> results = await dbs.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      print(UserModel.fromMap(results.first));
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  static Future<List<UserModel>> getAllUser() async {
    final dbs = await instance.database;
    final List<Map<String, dynamic>> results = await dbs.query('users');
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  static Future<void> updateUser(UserModel user) async {
    final dbs = await instance.database;
    await dbs.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUserById(int id) async {
    final dbs = await instance.database;
    final List<Map<String, dynamic>> results = await dbs.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  static Future<void> deleteUser(int id) async {
    final dbs = await instance.database;
    await dbs.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // INSERT Booking
  Future<int> insertBooking(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('bookings', data);
  }

  // GET semua booking
  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await instance.database;
    return await db.query('bookings', orderBy: 'date DESC');
  }

  // UPDATE Booking
  Future<int> updateBooking(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // DELETE Booking
  Future<int> deleteBooking(int id) async {
    final db = await instance.database;
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
