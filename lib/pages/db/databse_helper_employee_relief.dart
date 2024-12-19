import 'dart:convert';
import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperEmployeeRelief {
  static final _databaseName = "UserRelief.db";
  static final _databaseVersion = 1;

  static final table = 'users_relief';
  static final columnId = 'id';
  // static final columnUser = 'user';
  // static final columnPassword = 'password';
  // static final columnModelData = 'model_data';

  static final employee_id = "employee_id";
  static final username = "username";
  static final groupAccessId = "group_access_id";
  static final companyId = "company_id";
  static final employeeName = "employee_name";
  static final employeePhone = "employee_phone";
  static final employeeEmail = "employee_email";
  static final employeeStatus = "employee_status";

  // static final employeeBirthday = "employee_birth_date";
  static final employeePosition = "employee_position";
  static final profileImage = "employee_photo";
  static final branchId = "branch_id";
  static final branchName = "branch_name";
  static final attendanceType = "attendance_type";
  static final status = "status";
  // static final userLocation = "user_location";
  static final employee_fr_template = "employee_fr_template";
  static final is_personal = "is_personal";
  static final is_verif_fr = "is_verif_fr";

  static final shift_id = "shift_id";
  static final check_in = "check_in";
  static final check_out = "check_out";
  static final employee_fr_image = "employee_fr_image";

  //RELIEF

  static final status_relief = "status_relief";
  static final relief_id = "relief_id";
  static final from_branch = "from_branch";
  static final to_branch = "to_branch";
  static final relief_status = "relief_status";
  static final relief_start_date = "relief_start_date";
  static final relief_end_date = "relief_end_date";
  static final is_relief_employee = "is_relief_employee";

  //DK
  static final dk_start_date = "dk_start_date";
  static final dk_end_date = "dk_end_date";
  static final status_dk = "status_dk";

  DatabaseHelperEmployeeRelief._privateConstructor();
  static final DatabaseHelperEmployeeRelief instance =
      DatabaseHelperEmployeeRelief._privateConstructor();

  static late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
$employee_id TEXT,
$username TEXT,
$groupAccessId TEXT,
$companyId TEXT,
$employeeName TEXT,
$employeePhone TEXT,
$employeeEmail TEXT,
$employeeStatus TEXT,

$employeePosition TEXT,
$profileImage TEXT,
$branchId TEXT,
$branchName TEXT,
$attendanceType TEXT,
$status TEXT,
$employee_fr_template TEXT,
$is_personal TEXT,
$is_verif_fr TEXT,
$shift_id TEXT,
$check_in TEXT,
$check_out TEXT,
$employee_fr_image TEXT,
$status_relief TEXT,
$relief_id TEXT,
$from_branch TEXT,
$to_branch TEXT,
$relief_status TEXT,
$relief_start_date,
$relief_end_date,
$is_relief_employee,
$dk_start_date TEXT,
$dk_end_date TEXT,
$status_dk
          )
          ''');
  }

  // $columnUser TEXT NOT NULL,
  // $columnPassword TEXT NOT NULL,
  // $columnModelData TEXT NOT NULL
  Future<int> insert(User user) async {
    Database db = await instance.database;

    print(user.toMap());
    user.is_relief_employee = "1";
    return await db.insert(table, user.toMap());
  }

  Future<List<User>> queryAllUsers() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> users = await db.query(table);
      return users.map((u) => User.fromMap(u)).toList();
    } catch (e) {
      showToast(e.toString());
      return [];
    }
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<void> updateFaceTemplate(String employeeId,
      List<dynamic> newFaceTemplate, String base64Image) async {
    try {
      Database db = await instance.database;

      await db.update(
        table,
        {
          employee_fr_template: jsonEncode(newFaceTemplate),
          employee_fr_image:
              base64Image, // Menambahkan data gambar ke kolom face_image
          is_verif_fr: "0",
        },
        where: 'employee_id = ?',
        whereArgs: [employeeId],
      );
    } catch (e) {
      showToast("error saat registrasi - " + e.toString());
    }
  }

  Future<List<User>> queryAllUsersNotVerifFR() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> users = await db.rawQuery(
          'SELECT * FROM $table WHERE ' +
              '$employee_fr_image IS NOT NULL AND ' +
              'is_verif_fr = 0 AND ' +
              '$employee_fr_template IS NOT NULL');
      List<User> userFiltered = [];
      List<User> users_unfilter = users.map((u) => User.fromMap(u)).toList();
      for (User usr in users_unfilter) {
        if (reliefChecker(usr.relief_start_date, relief_end_date)) {
          userFiltered.add(usr);
        }
      }
      return userFiltered;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<User>> queryAllUsersNotVerifRegister() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db
        .rawQuery('SELECT * FROM $table WHERE employee_status != "ACTIVE"');
    // List<Map<String, dynamic>> users = await db.rawQuery('SELECT * FROM $table WHERE is_verif_fr = 0');
    return users.map((u) => User.fromMap(u)).toList();
  }

  Future<void> approveFR(String? employeeId) async {
    try {
      Database db = await instance.database;

      await db.update(
        table,
        {
          is_verif_fr: "1",
        },
        where: 'employee_id = ?',
        whereArgs: [employeeId],
      );
    } catch (e) {
      showToast("error saat registrasi - " + e.toString());
    }
  }

  Future<void> updateShift(
      String? employeeId, String id_shift, String cin, String cout) async {
    try {
      Database db = await instance.database;

      await db.update(
        table,
        {shift_id: id_shift, check_in: cin, check_out: cout},
        where: 'employee_id = ?',
        whereArgs: [employeeId],
      );
    } catch (e) {
      showToast("error saat Update shift - " + e.toString());
    }
  }

  Future<List<User>> queryAllUsersReliefForMLKit() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> users = await db.rawQuery(
          'SELECT * FROM $table WHERE (' +
              employee_fr_template +
              ' is NOT NULL ) AND (' +
              is_verif_fr +
              " = '1' ) AND ( " +
              check_out +
              ' is NOT NULL ) AND ( ' +
              check_in +
              " is NOT NULL )");

      // List<Map<String, dynamic>> users = await db.rawQuery('SELECT * FROM $table WHERE is_verif_fr = 0');
      // print(users.length);
      List<User> userFiltered = [];
      List<User> users_unfilter = users.map((u) => User.fromMap(u)).toList();
      for (User usr in users_unfilter) {
        if (reliefChecker(usr.relief_start_date, usr.relief_end_date)) {
          userFiltered.add(usr);
        }
      }
      return userFiltered;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<User>> queryAllUsersReliefForRangkumanHarian(
      String shift_filter) async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> users = await db
          .rawQuery('SELECT * FROM $table WHERE $shift_id = "$shift_filter"');

      // List<Map<String, dynamic>> users = await db.rawQuery('SELECT * FROM $table WHERE is_verif_fr = 0');
      // print(users.length);
      List<User> userFiltered = [];
      List<User> users_unfilter = users.map((u) => User.fromMap(u)).toList();
      for (User usr in users_unfilter) {
        if (reliefChecker(usr.relief_start_date, usr.relief_end_date)) {
          userFiltered.add(usr);
        }
      }
      return userFiltered;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
