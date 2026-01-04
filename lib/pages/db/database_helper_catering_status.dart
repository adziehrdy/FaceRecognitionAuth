import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/catering_history_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperCateringHistory {
  static final _databaseName = "CateringHistory.db";
  static final _databaseVersion = 1;

  static final table = 'catering_history';
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
  static final shift = "shift";

  DatabaseHelperCateringHistory._privateConstructor();
  static final DatabaseHelperCateringHistory instance =
      DatabaseHelperCateringHistory._privateConstructor();

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
$api_flag TEXT,
$shift TEXT
          )
          ''');
  }

  // $columnUser TEXT NOT NULL,
  // $columnPassword TEXT NOT NULL,
  // $columnModelData TEXT NOT NULL
  Future<int> insert(CateringHistoryModel status) async {
    try {
      Database db = await instance.database;
      print(status.toMap());
      return await db.insert(table, status.toMap());
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }

  Future<void> insertAll(List<CateringHistoryModel> statusList) async {
    deleteAll();
    try {
      Database db = await instance.database;
      Batch batch = db.batch();
      statusList.forEach((status) {
        batch.insert(table, status.toMap());
      });
      await batch.commit();
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<List<CateringHistoryModel>> queryAllStatus() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus = await db.query(table);
    return rigStatus
        .map((u) => CateringHistoryModel.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<List<CateringHistoryModel>> queryForUpdateOnline() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rigStatus = await db
        .query(table, where: '$api_flag IN (?, ?)', whereArgs: ['U', 'I']);
    return rigStatus
        .map((u) => CateringHistoryModel.fromMap(u))
        .toList()
        .reversed
        .toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<int> softDelete(CateringHistoryModel status) async {
    try {
      Database db = await instance.database;
      String id = status.id!;
      await db.update(table, {'api_flag': null},
          where: '$columnId = ?', whereArgs: [id]);
      return 1;
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }

  Future<int> update(
      CateringHistoryModel status, String shift, bool isActive) async {
    String updatedStatus = "-";
    if (isActive) {
      updatedStatus = "AKTIF";
    } else {
      updatedStatus = "TIDAK AKTIF";
    }

    CateringHistoryModel finalData = CateringHistoryModel(
        id: status.id,
        branchId: status.branchId,
        requester: status.requester,
        status: updatedStatus,
        date: status.date,
        api_flag: "U",
        shift: shift);
    try {
      Database db = await instance.database;
      String id = status.id!;
      return await db.update(table, finalData.toMap(),
          where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      showToast(e.toString());
      return 0;
    }
  }
}
