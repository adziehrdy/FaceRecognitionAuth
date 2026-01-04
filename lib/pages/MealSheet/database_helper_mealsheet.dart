import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperMealsheet {
  static final DatabaseHelperMealsheet instance =
      DatabaseHelperMealsheet._privateConstructor();
  static Database? _database;

  static const String tableName = 'employee_mealsheet';

  static const String columnId = 'id';
  static const String columnNIP = 'nip';
  static const String columnEmployeeName = 'employee_name';
  static const String columnBFAST = 'b_fast';
  static const String columnBFASTTime = 'b_fast_time';
  static const String columnLunch = 'lunch';
  static const String columnLunchTime = 'lunch_time';
  static const String columnDinner = 'dinner';
  static const String columnDinnerTime = 'dinner_time';
  static const String columnSupper = 'supper';
  static const String columnSupperTime = 'supper_time';
  static const String columnType = 'type';
  static const String columnIsUploaded = 'is_uploaded';

  DatabaseHelperMealsheet._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mealsheet.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNIP TEXT NOT NULL,
        $columnEmployeeName TEXT NOT NULL,
        $columnBFAST TEXT,
        $columnBFASTTime TEXT,
        $columnLunch TEXT,
        $columnLunchTime TEXT,
        $columnDinner TEXT,
        $columnDinnerTime TEXT,
        $columnSupper TEXT,
        $columnSupperTime TEXT,
        $columnType TEXT,
        $columnIsUploaded INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> insertData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> fetchAllData() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<int> updateData(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db
        .update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteData(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
}
