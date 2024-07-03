import 'dart:developer';

import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
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
  static final String columnShift_id = "shift_id";
  static final String approval_status_in = "approval_status_in";
  static final String approval_status_out = "approval_status_out";
  static final String branch_status_id = "branch_status_id";
  static final String attendance_location_id = "attendance_location_id";

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
      version: 2,
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
        $is_uploaded TEXT,
        $approval_employee_id TEXT,
        $columnShift_id TEXT,
        $approval_status_in TEXT,
        $approval_status_out TEXT,
        $branch_status_id TEXT,
        $attendance_location_id TEXT
      )
    ''');
  }

  Future<String> insertAttendance(Attendance attendance, String MODE,
      bool isOvernight, String shift_id) async {
    try {
      final db = await database;

      bool canAbsense = false;

      DateTime now = DateTime.now();

      // //TESTING ABSENSI
      // String textJamAbsensi = "2024-01-04 01:51:46";
      // now = DateTime.parse(textJamAbsensi!);
      // //TESTING ABSENSI

      String hariIni = DateFormat("ddMM").format(now);

      DateTime yesterday = now.subtract(Duration(days: 1));
      String kemarin = DateFormat("ddMM").format(yesterday);

      if (!isOvernight) {
        //MASUK PAGI
        if (MODE == "MASUK") {
          List<Attendance> allRecord = await getAllAttendancesMasuk(
              attendance.employee_id!, shift_id, isOvernight);
          if (allRecord.isEmpty) {
            await db.insert(tableName, attendance.toCreateMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
            return "SUCCESS";
          } else {
            for (var data in allRecord) {
              String tanggalAbsen =
                  DateFormat("ddMM").format(data.attendanceDate!);
              if (tanggalAbsen != hariIni) {
                canAbsense = true;
                break;
              } else {
                canAbsense = false;
                // break;
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
        } else {
          //KELUAR PAGI
          List<Attendance> allRecord = await getAllAttendancesKELUAR(
              attendance.employee_id!, shift_id, isOvernight);
          if (allRecord.isEmpty) {
            print("BELUM ABSEN MASUK");

            return "BELUM ABSEN MASUK";
          } else {
            for (var data in allRecord) {
              if (data.checkOut == null) {
                await db.update(
                  tableName,
                  attendance.toCreateMap(),
                  where: '$columnAttendanceId = ?',
                  whereArgs: [data.attendanceId],
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
                canAbsense = true;
                break;
              } else {
                canAbsense = false;
              }
            }

            if (canAbsense) {
              return "SUCCESS";
            } else {
              return "ALLREADY";
            }
          }
        }
      } else {
        //OVERNIGHT
        print("OVERNIGHT");

        if (MODE == "MASUK") {
          List<Attendance> allRecord = await getAllAttendancesMasuk(
              attendance.employee_id!, shift_id, isOvernight);
          if (allRecord.isEmpty) {
            await db.insert(tableName, attendance.toCreateMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
            return "SUCCESS";
          } else {
            for (var data in allRecord) {
              String tanggalAbsen =
                  DateFormat("ddMM").format(data.checkInActual!);

              // if ((tanggalAbsen != hariIni && data.checkIn == null) || (tanggalAbsen == kemarin && data.checkOut == null)) {

              if (tanggalAbsen == hariIni) {
                canAbsense = false;
                break;
              } else if (tanggalAbsen == kemarin) {
                int perbadinganJam = calculateTimeDifference(
                    data.checkInActual!.toIso8601String(),
                    DateTime.now().toIso8601String());
                if (perbadinganJam >= CONSTANT_VAR.LAMA_JAM_BEKERJA) {
                  canAbsense = true;
                  // break;
                } else {
                  canAbsense = false;
                }
                // break;
              }

              // if (tanggalAbsen != hariIni) {
              //   canAbsense = true;
              //   break;
              // } else {
              //   canAbsense = false;
              //   // break;
              // }
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
        } else {
          //KELUAR OVERNIGHT
          List<Attendance> allRecord = await getAllAttendancesKELUAR(
              attendance.employee_id!, shift_id, isOvernight);
          if (allRecord.isEmpty) {
            print("BELUM ABSEN MASUK");

            return "BELUM ABSEN MASUK";
          } else {
            for (var data in allRecord) {
              String tanggalCheckIn =
                  DateFormat("ddMM").format(data.attendanceDate!);
              if (data.checkOut == null &&
                  (tanggalCheckIn == hariIni || tanggalCheckIn == kemarin)) {
                await db.update(
                  tableName,
                  attendance.toCreateMap(),
                  where: '$columnAttendanceId = ?',
                  whereArgs: [data.attendanceId],
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
                canAbsense = true;
                break;
              } else {
                canAbsense = false;
              }
            }

            if (canAbsense) {
              return "SUCCESS";
            } else {
              return "ALLREADY";
            }
          }
        }
      }

      // List<Attendance> allRecord =
      //     await getAllAttendancesByType(attendance.employee_id!, MODE);

      // if (allRecord.isEmpty) {
      //   await db.insert(tableName, attendance.toCreateMap(),
      //       conflictAlgorithm: ConflictAlgorithm.replace);
      //   return "SUCCESS";
      // } else {
      //   for (var data in allRecord) {
      //     String tanggalAbsen = DateFormat("ddMM").format(data.attendanceDate!);

      // if(tanggalAbsen != hariIni) {
      //       canAbsense = true;
      //     } else {
      //       canAbsense = false;
      //       break;
      //     }
      //   }

      //   if (canAbsense) {
      //     await db.insert(tableName, attendance.toCreateMap(),
      //         conflictAlgorithm: ConflictAlgorithm.replace);
      //     print("SUSKSES ABSENSI");
      //     return "SUCCESS";
      //   } else {
      //     return "ALLREADY";
      //   }
      // }

      //BYPASS CHECK
      //  await db.insert(tableName, attendance.toCreateMap(),
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      //     print("SUSKSES ABSENSI");
      //     return "SUCCESS";
    } catch (e) {
      print(e.toString);
      return ("ERROR INSERT DB");
    }
  }

  Future<List<Attendance>> getAllAttendances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  // Future<List<Attendance>> getAllAttendancesByType(
  //     String employee_id, String type, String shift) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps ;
  //   if(type == "MASUK"){
  //      maps = await db.query(
  //     tableName,
  //     where: 'columnCheckInActual NOT NULL AND employee_id = ? AND shift = ?',
  //     whereArgs: [employee_id, shift],
  //   );
  //   }else{
  //      maps = await db.query(
  //     tableName,
  //     where: 'columnCheckOutActual NOT NULL AND employee_id = ? AND shift = ?',
  //     whereArgs: [employee_id, shift],
  //   );
  //   }

  Future<List<Attendance>> getAllAttendancesMasuk(
      String employee_id, String shift, bool isOvernight) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    String today = formatDateForFilter(DateTime.now());
    String yesterday =
        formatDateForFilter(DateTime.now().subtract(Duration(days: 1)));

    if (isOvernight == false) {
      maps = await db.query(
        tableName,
        where:
            'SUBSTR(check_in_actual, 1, 10) = ? AND employee_id = ? AND shift_id = ?',
        whereArgs: [today, employee_id, shift],
      );
    } else {
      maps = await db.query(
        tableName,
        where:
            'check_in_actual NOT NULL AND employee_id = ? AND shift_id = ? AND (SUBSTR(check_in, 1, 10) = ? OR SUBSTR(check_in, 1, 10) = ?)',
        whereArgs: [employee_id, shift, today, yesterday],
      );
    }

    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getAllAttendancesKELUAR(
      String employee_id, String shift, bool isOvernight) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    String today = formatDateForFilter(DateTime.now());
    String yesterday =
        formatDateForFilter(DateTime.now().subtract(Duration(days: 1)));

    if (isOvernight == false) {
      maps = await db.query(
        tableName,
        where:
            'SUBSTR(check_in_actual, 1, 10) = ? AND employee_id = ? AND shift_id = ?',
        whereArgs: [today, employee_id, shift],
      );
    } else {
      maps = await db.query(
        tableName,
        where:
            'check_in_actual NOT NULL AND employee_id = ? AND shift_id = ? AND (SUBSTR(check_in, 1, 10) = ? OR SUBSTR(check_in, 1, 10) = ?) ORDER BY check_in DESC LIMIT 1',
        whereArgs: [employee_id, shift, today, yesterday],
      );
    }
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

  Future<Attendance?> getUpdatedAttendance(int attendanceId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnAttendanceId = ?',
      whereArgs: [attendanceId],
    );

    if (maps.isNotEmpty) {
      // Jika data ditemukan, kembalikan objek Attendance yang sesuai
      return Attendance.fromMap(maps.first);
    }

    // Jika tidak ditemukan, kembalikan null atau sesuaikan dengan kebutuhan logika aplikasi Anda
    return null;
  }

  Future<void> updateToullAttendanceKeluar(int attendanceId) async {
    final db = await database;
    await db.update(
      tableName,
      {
        columnCheckOut: null,
        columnCheckOutActual: null,
        columnCheckOutStatus: null,
        columnAttendanceTypeOut: null,
        columnAttendanceLocationOut: null,
        columnAttendanceAddressOut: null,
        columnAttendanceNoteOut: null,
        columnAttendancePhotoOut: null,
        approval_status_out: null,
      },
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
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $tableName' + " WHERE " + is_uploaded + " = 0");
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getHistoryAbsensiTerUpload() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $tableName' + " WHERE " + is_uploaded + " = 1");
    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<List<Attendance>> getHistoryAbsensiTerUploadFilterDate(
      DateTime selectedDate) async {
    try {
      final db = await database;

      // Ubah format tanggal ke dalam format yang sesuai untuk penyimpanan di SQLite
      final formattedDate = selectedDate.toIso8601String().substring(0, 10);

      final List<Map<String, dynamic>> maps = await db.rawQuery(
          'SELECT * FROM $tableName WHERE $is_uploaded = 1 AND $columnAttendanceDate = ?',
          [formattedDate]);

      return List.generate(maps.length, (i) {
        return Attendance.fromMap(maps[i]);
      });
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> approveAbsensi(int attendanceId, String id_approval,
      String notes, bool isAbsenMasuk, String statusApproval) async {
    final db = await database;
    try {
      if (isAbsenMasuk) {
        await db.update(
          tableName,
          {
            columnAttendanceNoteIn: notes,
            approval_status_in: statusApproval,
            approval_employee_id: id_approval,
          },
          where: 'attendance_id = ?',
          whereArgs: [attendanceId],
        );
      } else {
        await db.update(
          tableName,
          {
            columnAttendanceNoteOut: notes,
            approval_status_out: statusApproval,
            approval_employee_id: id_approval,
          },
          where: 'attendance_id = ?',
          whereArgs: [attendanceId],
        );
      }
    } catch (e) {
      showToast("error saat Approve Absensi - " + e.toString());
    }
  }

  Future<void> tidakAbsenKeluar(int attendanceId, String id_approval,
      String notes, bool isAbsenMasuk, String statusApproval) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        {
          columnAttendanceNoteOut: notes,
          approval_status_out: statusApproval,
          approval_employee_id: id_approval,
          columnCheckOutStatus: "TIDAK ABSEN KELUAR"
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
          is_uploaded: "1",
        },
        where: 'attendance_id = ?',
        whereArgs: [attendanceId],
      );
    } catch (e) {
      showToast("error saat Approve Absensi - " + e.toString());
    }
  }
}
