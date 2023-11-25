import 'dart:convert';
import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperEmployee {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'users';
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

  static final employeeBirthday = "employee_birth_date";
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

  DatabaseHelperEmployee._privateConstructor();
  static final DatabaseHelperEmployee instance =
      DatabaseHelperEmployee._privateConstructor();

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
$employeeBirthday TEXT,
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
$employee_fr_image TEXT
          )
          ''');
  }

  // $columnUser TEXT NOT NULL,
  // $columnPassword TEXT NOT NULL,
  // $columnModelData TEXT NOT NULL
  Future<int> insert(User user) async {
    Database db = await instance.database;
    print(user.toMap());
    return await db.insert(table, user.toMap());
  }

  Future<List<User>> queryAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(table);
    return users.map((u) => User.fromMap(u)).toList();
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
  try{
 List<Map<String, dynamic>> users = await db.rawQuery(
    'SELECT * FROM $table WHERE ' +
    '$employee_fr_image IS NOT NULL AND ' +
    'is_verif_fr = 0 AND ' +
    '$employee_fr_template IS NOT NULL'
  );
          return users.map((u) => User.fromMap(u)).toList();
  }catch(e){
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

    Future<List<User>> queryAllUsersForMLKit() async {
    Database db = await instance.database;
    try{
       List<Map<String, dynamic>> users = await db
        .rawQuery('SELECT * FROM $table WHERE ('+employee_fr_template+' is NOT NULL ) AND ('+is_verif_fr+" = '1' ) AND ( "+ check_out +' is NOT NULL ) AND ( '+check_in+ " is NOT NULL )" );
    // List<Map<String, dynamic>> users = await db.rawQuery('SELECT * FROM $table WHERE is_verif_fr = 0');
    // print(users.length);
    return users.map((u) => User.fromMap(u)).toList();
    }catch(e){
      print(e);
      return [];
    }
   
  }
}
