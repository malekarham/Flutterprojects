import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'grades.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE grades(id INTEGER PRIMARY KEY AUTOINCREMENT, studentname TEXT, obtainedmarks INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database();
    await db.insert('grades', data);
  }

  static Future<List<Map<String, dynamic>>> fetchAllData() async {
    final db = await database();
    return db.query('grades');
  }

  static Future<void> deleteRecord(int id) async {
    final db = await database();
    await db.delete('grades', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAllRecords() async {
    final db = await database();
    await db.delete('grades');
  }
}
