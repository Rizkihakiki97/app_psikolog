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

  static const String tableUser = 'users';

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabel Users
    await db.execute('''
CREATE TABLE $tableUser(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  bio TEXT,
  lisensi TEXT,
  foto TEXT,
  phone TEXT,
  password TEXT NOT NULL
)
''');

    // Tabel Roles
    await db.execute('''
CREATE TABLE roles(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
)
''');

    // Tabel Bookings
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

  // Tambah user baru (Register)
  static Future<void> createUser(UserModel user) async {
    final dbs = await instance.database;
    await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Ambil semua user
  static Future<List<UserModel>> getAllUser() async {
    final dbs = await instance.database;
    final List<Map<String, dynamic>> results = await dbs.query(tableUser);
    return results.map((e) => UserModel.fromMap(e)).toList();
  }

  // Update user (edit profile)
  static Future<void> updateUser(UserModel user) async {
    final dbs = await instance.database;
    await dbs.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Ambil user berdasarkan ID
  static Future<UserModel?> getUserById(int id) async {
    final dbs = await instance.database;
    final results = await dbs.query(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  // Hapus user berdasarkan ID
  static Future<void> deleteUser(int id) async {
    final dbs = await instance.database;
    await dbs.delete(tableUser, where: 'id = ?', whereArgs: [id]);
  }

  // LOGIN USER
  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await instance.database;
    final normalizedEmail = email.trim().toLowerCase();

    final List<Map<String, dynamic>> result = await dbs.query(
      tableUser,
      where: 'LOWER(email) = ? AND password = ?',
      whereArgs: [normalizedEmail, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  // Tambah Booking
  Future<int> insertBooking(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('bookings', data);
  }

  // Ambil semua booking
  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await instance.database;
    return await db.query('bookings', orderBy: 'date DESC');
  }

  // Update booking
  Future<int> updateBooking(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // Hapus booking
  Future<int> deleteBooking(int id) async {
    final db = await instance.database;
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
