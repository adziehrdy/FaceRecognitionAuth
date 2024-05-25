import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/rig_status_history_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperRigStatusHistory {
  static final _databaseName = "RigStatus.db";
  static final _databaseVersion = 1;

  static final table = 'rig_status';
  static final columnId = 'id';
  // static final columnUser = 'user';
  // static final columnPassword = 'password';
  // static final columnModelData = 'model_data';

  static final branch_id = "branch_id";
  static final branch_status_id = "branch_status_id";
  static final requester = "requester";
  static final approver = "approver";
  static final status = "status";
  static final date = "date";
  static final api_flag = "api_flag";

  DatabaseHelperRigStatusHistory._privateConstructor();
  static final DatabaseHelperRigStatusHistory instance =
      DatabaseHelperRigStatusHistory._privateConstructor();

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
$branch_status_id TEXT,
$requester TEXT,
$approver TEXT,
$status TEXT,
$date TEXT,
$api_flag TEXT
          )
          ''');
  }

  // $columnUser TEXT NOT NULL,
  // $columnPassword TEXT NOT NULL,
  // $columnModelData TEXT NOT NULL
  Future<int> insert(RigStatusHistoryModel status) async {
    try {
      Database db = await instance.database;
      print(status.toMap());
      return await db.insert(table, status.toMap());
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }

  Future<List<RigStatusHistoryModel>> queryAllStatus() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus = await db.query(table);
    return rigStatus
        .map((u) => RigStatusHistoryModel.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<List<RigStatusHistoryModel>> queryForInsert() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus =
        await db.query(table, where: '$api_flag = ?', whereArgs: ['I']);
    return rigStatus
        .map((u) => RigStatusHistoryModel.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<List<RigStatusHistoryModel>> queryForUpdate() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus =
        await db.query(table, where: '$api_flag = ?', whereArgs: ['U']);
    return rigStatus
        .map((u) => RigStatusHistoryModel.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> update(RigStatusHistoryModel status) async {
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
