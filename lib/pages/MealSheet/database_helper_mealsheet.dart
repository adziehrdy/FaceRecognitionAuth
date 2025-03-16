import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_func.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperMealsheet {
  static final DatabaseHelperMealsheet instance =
      DatabaseHelperMealsheet._privateConstructor();
  static Database? _database;

  static const String tableName = 'employee_mealsheet';

  static const String columnId = 'id';
  static const String columnEmployeeId = 'employee_id';
  static const String columnEmployeeName = 'employee_name';
  static const String columnInitDate = 'init_date';
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
  static const String columnAccommodation = 'accommodation';
  static const String columnType = 'type';
  static const String columnPersonCount = 'person_count';
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
        $columnEmployeeId TEXT NOT NULL,
        $columnEmployeeName TEXT NOT NULL,
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
        $columnType TEXT,
        $columnPersonCount INTEGER NOT NULL,
        $columnIsUploaded INTEGER DEFAULT 0
      )
    ''');
  }

  Future<List<MealSheetModel>> getAllData() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((map) => MealSheetModel.fromMap(map)).toList();
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

  Future<List<MealSheetModel>> getAllbyUser(String employee_id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    String today = formatDateForFilter(DateTime.now()
        .add(Duration(hours: CONSTANT_VAR.MEAL_SUBSTACT_FOR_DEBUG)));
    maps = await db.query(
      tableName,
      where: 'SUBSTR($columnInitDate, 1, 10) = ? AND employee_id = ?',
      whereArgs: [today, employee_id],
    );

    return List.generate(maps.length, (i) {
      return MealSheetModel.fromMap(maps[i]);
    });
  }

  Future<String> insertOrUpdateData(User employee_data, DateTime dateCheckin,
      String ATTENDANCE_CATEGORY) async {
    try {
      // //TESTING ABSENSI
      // String textJamAbsensi = "2024-01-04 01:51:46";
      // now = DateTime.parse(textJamAbsensi!);
      // //TESTING ABSENSI
      //MASUK PAGI

      ATTENDANCE_CATEGORY = ATTENDANCE_CATEGORY.toLowerCase();

      List<MealSheetModel> allRecord =
          await getAllbyUser(employee_data.employee_id!);
      if (allRecord.isEmpty) {
        String status = await insertMealAttendance(
            employee_data, ATTENDANCE_CATEGORY, dateCheckin);
        return status;
      } else {
        String status = await updateMealAttendance(
            allRecord[0], ATTENDANCE_CATEGORY, dateCheckin);
        return status;
      }
    } catch (e) {
      print(e.toString);
      return ("ERROR INSERT DB");
    }
  }

  Future<String> updateMealAttendance(MealSheetModel existingData,
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
      case "sahur":
        columnTimeName = columnSahurTime;
        columnFlagName = columnSahur;
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

  Future<String> insertMealAttendance(User employee_data,
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
      case "sahur":
        columnTimeName = columnSahurTime;
        columnFlagName = columnSahur;
        break;
      default:
        return "Kategori tidak valid";
    }

    Map<String, dynamic> updateData = {
      columnEmployeeId: employee_data.employee_id,
      columnEmployeeName: employee_data.employee_name,
      columnInitDate: dateCheckin.toIso8601String(),
      columnTimeName: dateCheckin.toIso8601String(),
      columnFlagName: "YES",
      columnType: "REGULER",
      columnPersonCount: 1
    };

    try {
      await db.insert(tableName, updateData);
      return "SUCCESS";
    } catch (e) {
      return "Error saat insert kehadiran: ${e.toString()}";
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

  Future<String> updateAccomodation(String id, String? accomodation) async {
    Map<String, dynamic> updateData = {
      columnAccommodation: accomodation,
    };
    Database db = await instance.database;
    try {
      await db.update(tableName, updateData,
          where: '$columnId = ?', whereArgs: [id]);
      return "SUCCESS";
    } catch (e) {
      showToast("Failed update data = " + e.toString());
      return "FAILED";
    }
  }
}
