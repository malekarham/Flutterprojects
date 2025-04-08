import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'subject_data.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE subjects (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             subject TEXT,
             marks INTEGER,  
             creditHours INTEGER,  
             semester TEXT,
             grade TEXT,
             percentage REAL)''',
        );
      },
      version: 1,
    );
  }

  static Future<void> saveSubjectData(
    String subject,
    String semester,
    int creditHours,
    int marks,
    String grade,
    double percentage,
  ) async {
    final db = await database;
    await db.insert(
      'subjects',
      {
        'subject': subject,
        'semester': semester,
        'creditHours': creditHours,
        'marks': marks,
        'grade': grade,
        'percentage': percentage,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchSubjectData() async {
    final db = await database;
    return await db.query('subjects');
  }

  static Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('subjects');
  }
}