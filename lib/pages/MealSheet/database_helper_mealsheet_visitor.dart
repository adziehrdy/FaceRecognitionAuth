import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperMealsheetVisitor {
  static final DatabaseHelperMealsheetVisitor instance =
      DatabaseHelperMealsheetVisitor._privateConstructor();
  static Database? _database;

  static const String tableName = 'visitor_mealsheet';

  static const String columnId = 'id';
  static const String columnEmployeeId = 'employee_id';
  static const String columnEmployeeName = 'employee_name';
  static const String columnCompany = 'company';
  static const String columnInitDate = 'init_date';
  static const String columnStartDate = 'start_date';
  static const String columnEnd = 'end_date';
  static const String columnBFAST = 'b_fast';
  static const String columnBFASTTime = 'b_fast_time';
  static const String columnLunch = 'lunch';
  static const String columnLunchTime = 'lunch_time';
  static const String columnDinner = 'dinner';
  static const String columnDinnerTime = 'dinner_time';
  static const String columnSupper = 'supper';
  static const String columnSupperTime = 'supper_time';
  static const String columnSahur = 'sahur';
  static const String columnSahurTime = 'sahur_time';
  static const String columnAccommodation = "accommodation";
  static const String columnGuestType = 'guest_type';
  static const String columnType = 'type';
  static const String columnPersonCount = 'person_count';
  static const String columnBranchID = 'branch_id';
  static const String columnDepartment = 'department';
  static const String columnCostCenter = 'cost_center';
  static const String columnNotes = 'notes';
  static const String columnIsUploaded = 'is_uploaded';

  DatabaseHelperMealsheetVisitor._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mealsheet_visitor.db');
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
        $columnEmployeeId TEXT,
        $columnEmployeeName TEXT,
        $columnCompany TEXT,
        $columnInitDate DATETIME,
        $columnBFAST TEXT,
        $columnBFASTTime DATETIME,
        $columnLunch TEXT,
        $columnLunchTime DATETIME,
        $columnDinner TEXT,
        $columnDinnerTime DATETIME,
        $columnSupper TEXT,
        $columnSupperTime DATETIME,
        $columnSahur TEXT,
        $columnSahurTime DATETIME,
        $columnAccommodation TEXT,
        $columnGuestType TEXT,
        $columnType TEXT,
        $columnBranchID TEXT,
        $columnDepartment TEXT,
        $columnCostCenter TEXT,
        $columnPersonCount INTEGER NOT NULL,
        $columnNotes TEXT,
        $columnIsUploaded INTEGER DEFAULT 0
      )
    ''');
  }

  Future<List<MealSheetVisitorModel>> getAllData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((map) => MealSheetVisitorModel.fromMap(map)).toList();
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

  Future<List<MealSheetVisitorModel>> getAllbyUser(String employee_id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    String today = formatDateForFilter(DateTime.now());
    maps = await db.query(
      tableName,
      where: 'SUBSTR($columnInitDate, 1, 10) = ? AND employee_id = ?',
      whereArgs: [today, employee_id],
    );

    return List.generate(maps.length, (i) {
      return MealSheetVisitorModel.fromMap(maps[i]);
    });
  }

  Future<String> updateMealAttendance(MealSheetVisitorModel existingData,
      String? attendanceCategory, DateTime dateCheckin) async {
    final db = await database;

    String columnTimeName = "";
    String columnFlagName = "";

    switch (attendanceCategory) {
      case "breakfast":
        columnTimeName = columnBFASTTime;
        columnFlagName = columnBFAST;
        break;
      case "lunch":
        columnTimeName = columnLunchTime;
        columnFlagName = columnLunch;
        break;
      case "dinner":
        columnTimeName = columnDinnerTime;
        columnFlagName = columnDinner;
        break;
      case "supper":
        columnTimeName = columnSupperTime;
        columnFlagName = columnSupper;
        break;
      default:
        return "Kategori tidak valid";
    }

    // Cek apakah absensi sudah dilakukan sebelumnya
    final String? existingTime = existingData.toMap()[columnTimeName];
    if (existingTime != null) {
      return "Anda Sudah Mengambil $attendanceCategory";
    }

    Map<String, dynamic> updateData = {
      columnTimeName: dateCheckin.toIso8601String(),
      columnFlagName: "YES",
    };

    try {
      await db.update(
        tableName,
        updateData,
        where: 'id = ?',
        whereArgs: [existingData.id],
      );
      return "SUCCESS";
    } catch (e) {
      return "Error saat update kehadiran: ${e.toString()}";
    }
  }

  Future<String> insertMealAttendance(MealSheetVisitorModel insertData) async {
    final db = await database;
    try {
      await db.insert(tableName, insertData.toMap());
      return "SUCCESS";
    } catch (e) {
      showToast("Error saat insert kehadiran: ${e.toString()}");
      return "FAILED";
    }
  }

  Future<String> clearOrDelete(
      String record_id, String mode, int filledCount) async {
    final db = await database;

    mode = mode.toLowerCase();

    String columnTimeName = "";
    String columnFlagName = "";

    if (filledCount > 1) {
      switch (mode) {
        case "breakfast":
          columnTimeName = columnBFASTTime;
          columnFlagName = columnBFAST;
          break;
        case "lunch":
          columnTimeName = columnLunchTime;
          columnFlagName = columnLunch;
          break;
        case "dinner":
          columnTimeName = columnDinnerTime;
          columnFlagName = columnDinner;
          break;
        case "supper":
          columnTimeName = columnSupperTime;
          columnFlagName = columnSupper;
          break;
        default:
          return "Flag tidak didefinisikan"; // Tambahkan return agar tidak lanjut ke bawah
      }

      Map<String, dynamic> updateData = {
        columnTimeName: null,
        columnFlagName: null,
      };

      try {
        await db.update(
          tableName,
          updateData,
          where: 'id = ?',
          whereArgs: [record_id],
        );
        return "SUCCESS";
      } catch (e) {
        return "Error saat update kehadiran: ${e.toString()}";
      }
    } else if (filledCount == 1) {
      try {
        await db.delete(
          tableName,
          where: 'id = ?',
          whereArgs: [record_id],
        );
        return "SUCCESS";
      } catch (e) {
        return "Error saat hapus kehadiran: ${e.toString()}";
      }
    }

    return "Mode tidak valid"; // Tambahkan return sebagai fallback jika tidak masuk ke kondisi manapun
  }
}
