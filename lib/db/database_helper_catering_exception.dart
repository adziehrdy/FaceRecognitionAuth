import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/catering_exception_model.dart';
import 'package:face_net_authentication/models/rig_status_history_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperCateringException {
  static final _databaseName = "catering_exception.db";
  static final _databaseVersion = 1;

  static final table = 'catering_exception';
  static final columnId = 'id';
  // static final columnUser = 'user';
  // static final columnPassword = 'password';
  // static final columnModelData = 'model_data';

  static final branch_id = "branch_id";
  static final employee_id = "employee_id";
  static final employee_name = "employee_name";
  static final requester = "requester";
  static final approver = "approver";
  static final status = "status";
  static final date = "date";
  static final notes = "notes";

  DatabaseHelperCateringException._privateConstructor();
  static final DatabaseHelperCateringException instance =
      DatabaseHelperCateringException._privateConstructor();

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
$branch_id TEXT,
$employee_id TEXT,
$employee_name TEXT,
$requester TEXT,
$approver TEXT,
$status TEXT,
$date TEXT,
$notes TEXT
          )
          ''');
  }

  // $columnUser TEXT NOT NULL,
  // $columnPassword TEXT NOT NULL,
  // $columnModelData TEXT NOT NULL
  Future<int> insert(catering_exception_model status) async {
    try {
      Database db = await instance.database;
      print(status.toMap());
      return await db.insert(table, status.toMap());
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }

  Future<List<catering_exception_model>> queryAllStatus() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus = await db.query(table);
    return rigStatus
        .map((u) => catering_exception_model.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> update(catering_exception_model status) async {
    try {
      Database db = await instance.database;
      int id = status.id!;
      return await db.update(table, status.toMap(),
          where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }
}
