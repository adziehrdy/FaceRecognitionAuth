import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperAbsensi {
  static final DatabaseHelperAbsensi instance =
      DatabaseHelperAbsensi._privateConstructor();

  static final String tableName = 'attendance_table';

  static final String columnAttendanceId = 'attendance_id';
  static final String columnEmployeeId = 'employee_id';
  static final String columnAttendanceDate = 'attendance_date';
  static final String columnCheckIn = 'check_in';
  static final String columnCheckInActual = 'check_in_actual';
  static final String columnCheckInStatus = 'check_in_status';
  static final String columnCheckOut = 'check_out';
  static final String columnCheckOutActual = 'check_out_actual';
  static final String columnCheckOutStatus = 'check_out_status';
  static final String columnAttendanceTypeIn = 'attendance_type_in';
  static final String columnAttendanceLocationIn = 'attendance_location_in';
  static final String columnAttendanceAddressIn = 'attendance_address_in';
  static final String columnAttendanceNoteIn = 'attendance_note_in';
  static final String columnAttendanceTypeOut = 'attendance_type_out';
  static final String columnAttendanceLocationOut = 'attendance_location_out';
  static final String columnAttendanceAddressOut = 'attendance_address_out';
  static final String columnAttendanceNoteOut = 'attendance_note_out';
  static final String columnAttendancePhotoIn = 'attendance_photo_in';
  static final String columnAttendancePhotoOut = 'attendance_photo_out';
  static final String columnCompanyId = 'company_id';
  static final String columnBranchName = 'branch_name';
  static final String columnEmployeeName = 'employee_name';
  static final String columnTypeAbsensi = 'type_absensi';
  static final String note_status = 'note_status';
  static final String is_uploaded = 'is_uploaded';
  static final String approval_employee_id = "approval_employee_id";

  DatabaseHelperAbsensi._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      '$path/attendance.db',
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnAttendanceId INTEGER PRIMARY KEY,
        $columnEmployeeId TEXT,
        $columnAttendanceDate TEXT,
        $columnCheckIn TEXT,
        $columnCheckInActual TEXT,
        $columnCheckInStatus TEXT,
        $columnCheckOut TEXT,
        $columnCheckOutActual TEXT,
        $columnCheckOutStatus TEXT,
        $columnAttendanceTypeIn TEXT,
        $columnAttendanceLocationIn TEXT,
        $columnAttendanceAddressIn TEXT,
        $columnAttendanceNoteIn TEXT,
        $columnAttendanceTypeOut TEXT,
        $columnAttendanceLocationOut TEXT,
        $columnAttendanceAddressOut TEXT,
        $columnAttendanceNoteOut TEXT,
        $columnAttendancePhotoIn TEXT,
        $columnAttendancePhotoOut TEXT,
        $columnCompanyId TEXT,
        $columnBranchName TEXT,
        $columnEmployeeName TEXT,
        $columnTypeAbsensi TEXT,
        $note_status TEXT,
        $is_uploaded BOOLEAN,
        $approval_employee_id TEXT
      )
    ''');
  }

  Future<String> insertAttendance(Attendance attendance, String MODE) async {
    final db = await database;

    bool canAbsense = false;

    String hariIni = DateFormat("ddMM").format(DateTime.now());
    List<Attendance> allRecord =
        await getAllAttendancesByType(attendance.employee_id!, MODE);

    if (allRecord.isEmpty) {
      await db.insert(tableName, attendance.toCreateMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return "SUCCESS";
    } else {
      for (var data in allRecord) {
        String tanggalAbsen = DateFormat("ddMM").format(data.attendanceDate!);

        if (tanggalAbsen != hariIni) {
          canAbsense = true;
        } else {
          canAbsense = false;
          break;
        }
      }

      if (canAbsense) {
        await db.insert(tableName, attendance.toCreateMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        print("SUSKSES ABSENSI");
        return "SUCCESS";
      } else {
        return "ALLREADY";
      }
    }

    //BYPASS CHECK
    //  await db.insert(tableName, attendance.toCreateMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    //     print("SUSKSES ABSENSI");
    //     return "SUCCESS";
  }

  Future<List<Attendance>> getAllAttendances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getAllAttendancesByType(
      String employee_id, String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'type_absensi = ? AND employee_id = ?',
      whereArgs: [type, employee_id],
    );

    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<void> deleteAttendance(int attendanceId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnAttendanceId = ?',
      whereArgs: [attendanceId],
    );
  }

  Future<List<Attendance>> getAnomalyAbsensi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ' + note_status + ' is NOT NULL');
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getHistoryAbsensi() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM $tableName WHERE ' + note_status + ' is NULL');
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<void> approveAbsensi(int attendanceId,String id_approval) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        {
          note_status: null,
          approval_employee_id: id_approval,

        },
        where: 'attendance_id = ?',
        whereArgs: [attendanceId],
      );
    } catch (e) {
      showToast("error saat Approve Absensi - " + e.toString());
    }
  }

  Future<void> updateIsUploaded(int attendanceId) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        {
          is_uploaded: true,
        },
        where: 'attendance_id = ?',
        whereArgs: [attendanceId],
      );
    } catch (e) {
      showToast("error saat Approve Absensi - " + e.toString());
    }
  }
}
