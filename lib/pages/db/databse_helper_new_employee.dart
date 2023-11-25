import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperNewEmployee {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'new_employee';
  static final columnId = 'id';
  // static final columnUser = 'user';
  // static final columnPassword = 'password';
  // static final columnModelData = 'model_data';

  static final name = "name";
  static final birthday = "birthday";
  static final groupAccessId = "groupAccessId";
  static final approval = "approval";
  static final location = "location";
  static final password = "password";
  static final nip = "nip";
  static final email = "email";
  static final phone = "phone";
  static final status_employee = "status_employee";
  static final status = "status";
  static final company_id = "company_id";
  static final organization = "organization";

  DatabaseHelperNewEmployee._privateConstructor();
  static final DatabaseHelperNewEmployee instance = DatabaseHelperNewEmployee._privateConstructor();

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
$name TEXT,
$birthday TEXT,
$groupAccessId TEXT,
$approval TEXT,
$location TEXT,
$password TEXT,
$nip TEXT,
$email TEXT,
$phone TEXT,
$status_employee TEXT,
$status TEXT,
$company_id TEXT,
$organization TEXT
          )
          ''');
  }
// Fungsi untuk menambahkan data baru ke dalam database
  Future<int> insertNewEmployee(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Fungsi untuk mendapatkan semua data new_employee dari database
  Future<List<Map<String, dynamic>>> queryAllNewEmployees() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Fungsi untuk mengupdate data new_employee berdasarkan ID
  Future<int> updateNewEmployee(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Fungsi untuk menghapus data new_employee berdasarkan ID
  Future<int> deleteNewEmployee(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

}
