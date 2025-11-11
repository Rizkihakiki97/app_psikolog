import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user_model.dart';
import '../model/booking_model.dart';

class DbHelper {
  static const tableUser = 'users';
  static const tableBooking = 'bookings';

  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'ppkd.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableUser(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          bio TEXT,
          lisensi TEXT,
          foto TEXT,
          phone TEXT,
          password TEXT,
          role TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE $tableBooking(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          doctorName TEXT,
          specialization TEXT,
          date TEXT,
          time TEXT,
          active INTEGER
        )
        ''');
      },
    );
  }

  static Future<int> insertUser(UserModel user) async {
    final dbs = await db();
    return await dbs.insert(
      tableUser,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<UserModel>> getAllUsers() async {
    final dbs = await db();
    final List<Map<String, dynamic>> maps = await dbs.query(tableUser);
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final dbs = await db();
    final List<Map<String, dynamic>> maps = await dbs.query(
      tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> updateUser(UserModel user) async {
    final dbs = await db();
    return await dbs.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<int> deleteUser(int id) async {
    final dbs = await db();
    return await dbs.delete(tableUser, where: 'id = ?', whereArgs: [id]);
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final dbs = await db();

    final List<Map<String, dynamic>> results = await dbs.query(
      tableUser,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      // Jika email dan password cocok
      return UserModel.fromMap(results.first);
    } else {
      // Jika tidak ditemukan
      return null;
    }
  }

  static Future<UserModel?> getUserById(int id) async {
    final dbs = await db();

    final List<Map<String, dynamic>> maps = await dbs.query(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // BOOKING
  static Future<int> insertBooking(BookingModel booking) async {
    final dbs = await db();
    return await dbs.insert(
      tableBooking,
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<BookingModel>> getAllBookings() async {
    final dbs = await db();
    final List<Map<String, dynamic>> maps = await dbs.query(tableBooking);
    return List.generate(maps.length, (i) {
      return BookingModel.fromMap(maps[i]);
    });
  }

  static Future<int> updateBooking(BookingModel booking) async {
    final dbs = await db();
    return await dbs.update(
      tableBooking,
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  static Future<int> deleteBooking(int id) async {
    final dbs = await db();
    return await dbs.delete(tableBooking, where: 'id = ?', whereArgs: [id]);
  }

  static Future<UserModel?> getStudentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null) return null;

    final db = await DbHelper.db();
    final result = await db.query(
      DbHelper.tableUser,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }
}
