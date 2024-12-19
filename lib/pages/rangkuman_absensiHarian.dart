import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/master_register_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/widgets/absensi_rangkuman_single.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/repo/attendance_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'db/databse_helper_absensi.dart';

class RangkumanAbsensiHarian extends StatefulWidget {
  @override
  _RangkumanAbsensiHarianState createState() => _RangkumanAbsensiHarianState();
}

class _RangkumanAbsensiHarianState extends State<RangkumanAbsensiHarian> {
  List<Attendance> _attendance_PDC_MALAM = [];
  List<Attendance> _attendance_PDC_PAGI = [];
  List<Attendance> _attendance_PDC_ONCALL = [];
  String _searchText = "";
  bool _isSearchVisible = false;
  late DateTime today;
  late DateTime yesterday; // Untuk mengatur visibilitas search bar
  bool _isLocked = true;

  // Getter untuk mendapatkan nilai variabel isLocked
  bool get isLocked => _isLocked;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    yesterday = today.subtract(Duration(days: 1));
    _loadData();
    _fillinYgBelumAbsensi_MALAM();
    _fillinYgBelumAbsensi_PAGI();
    _fillinYgBelumAbsensi_ONCALL();
  }

  Future<void> _loadData() async {
    List<Attendance> newDataMALAM = await DatabaseHelperAbsensi.instance
        .getHistoryAbsensiByShift("PDC_MALAM");
    setState(() {
      _attendance_PDC_MALAM = newDataMALAM.reversed.toList();
      // _filteredAttendanceList =
      //     _attendance_PDC_MALAM; // Menampilkan semua data saat pertama kali load
    });

    List<Attendance> newDataPAGI = await DatabaseHelperAbsensi.instance
        .getHistoryAbsensiByShift("PDC_PAGI");
    setState(() {
      _attendance_PDC_PAGI = newDataPAGI.reversed.toList();
      // _filteredAttendanceList =
      //     _attendance_PDC_PAGI; // Menampilkan semua data saat pertama kali load
    });

    List<Attendance> newDataONCALL = await DatabaseHelperAbsensi.instance
        .getHistoryAbsensiByShift("PDC_ONCALL");
    setState(() {
      _attendance_PDC_ONCALL = newDataONCALL.reversed.toList();
      // _filteredAttendanceList =
      //     _attendance_PDC_PAGI; // Menampilkan semua data saat pertama kali load
    });
  }

  Future<void> _deleteEntryAndRefresh(
      Attendance entryToDelete, String tipe_absen) async {
    if (tipe_absen == "MASUK") {
      await DatabaseHelperAbsensi.instance
          .deleteAttendance(entryToDelete.attendanceId!);
      setState(() {
        _attendance_PDC_MALAM.remove(entryToDelete);
      });
    } else {
      await DatabaseHelperAbsensi.instance
          .updateToullAttendanceKeluar(entryToDelete.attendanceId!);

      // Ambil data yang diperbarui dari database setelah pembaruan
      Attendance? updatedEntry = await DatabaseHelperAbsensi.instance
          .getUpdatedAttendance(entryToDelete.attendanceId!);

      // Cari entri yang cocok dalam _attendanceList
      try {
        int index = _attendance_PDC_MALAM.indexWhere(
            (entry) => entry.attendanceId == updatedEntry!.attendanceId);

        if (index != -1) {
          // Perbarui entri yang sesuai dengan data yang diperbarui
          _attendance_PDC_MALAM[index] = updatedEntry!;
        }
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        _attendance_PDC_MALAM;
      });

      ;
    }
  }

  Future<void> _deleteEntry(Attendance entryToDelete) async {
    await DatabaseHelperAbsensi.instance
        .deleteAttendance(entryToDelete.attendanceId!);
  }

  Future<void> _updateIsUploaded(Attendance entryToUpdate) async {
    await DatabaseHelperAbsensi.instance
        .updateIsUploaded(entryToUpdate.attendanceId!);
  }

  // void _filterAttendanceList(String searchText) {
  //   if (searchText.isEmpty) {
  //     setState(() {
  //       _filteredAttendanceList =
  //           _attendance_PDC_MALAM; // Tampilkan semua data jika kosong
  //     });
  //   } else {
  //     setState(() {
  //       _filteredAttendanceList = _attendance_PDC_MALAM.where((attendance) {
  //         return attendance.employee_name!
  //                 .toLowerCase()
  //                 .contains(searchText.toLowerCase()) ||
  //             attendance.checkInActual.toString().contains(searchText);
  //       }).toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rangkuman Absensi Harian'),
          actions: <Widget>[
            Row(
              children: [
                // Tombol untuk menampilkan atau menyembunyikan search bar
                // IconButton(
                //   icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
                //   onPressed: () {
                //     setState(() {
                //       _isSearchVisible = !_isSearchVisible;
                //       if (!_isSearchVisible) {
                //         _searchText = "";
                //         _filterAttendanceList(_searchText);
                //       }
                //     });
                //   },
                // ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isLocked = !_isLocked;
                      });
                    },
                    icon: _isLocked
                        ? Icon(Icons.lock, color: Colors.red)
                        : Icon(Icons.lock_open, color: Colors.green)),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Bar hanya muncul jika tombol search diaktifkan

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(color: Colors.amber),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "PDC_PAGI",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.sunny,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    formatDateFriendly(today),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _attendance_PDC_PAGI.isEmpty
                ? Center(child: Text('Data absensi tidak ditemukan'))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 0,
                      childAspectRatio: 9, // Sesuaikan rasio dengan konten
                    ),
                    itemCount: _attendance_PDC_PAGI.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: absensi_rangkuman_single(
                          data: _attendance_PDC_PAGI[index],
                          onDelete: (tipe_absen) async {
                            PinInputDialog.show(context, (p0) async {
                              try {
                                await _deleteEntryAndRefresh(
                                    _attendance_PDC_PAGI[index], tipe_absen);
                                setState(() {
                                  _loadData();
                                });

                                showToastShort("Terhapus");
                              } catch (e) {
                                showToastShort("Data Sudah Terhapus");
                              }
                            });
                          },
                          onUpdate: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          isLocked: _isLocked,
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(color: Colors.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "PDC_MALAM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.nightlight,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    formatDateFriendly(yesterday) +
                        " - " +
                        formatDateFriendly(today),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            _attendance_PDC_MALAM.isEmpty
                ? Center(child: Text('Data absensi tidak ditemukan'))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 0,
                      childAspectRatio: 9, // Sesuaikan rasio dengan konten
                    ),
                    itemCount: _attendance_PDC_MALAM.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: absensi_rangkuman_single(
                          data: _attendance_PDC_MALAM[index],
                          onDelete: (tipe_absen) async {
                            PinInputDialog.show(context, (p0) async {
                              try {
                                await _deleteEntryAndRefresh(
                                    _attendance_PDC_MALAM[index], tipe_absen);
                                setState(() {
                                  _loadData();
                                });

                                showToastShort("Terhapus");
                              } catch (e) {
                                showToastShort("Data Sudah Terhapus");
                              }
                            });
                          },
                          onUpdate: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          isLocked: _isLocked,
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "PDC_ONCALL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    formatDateFriendly(today),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _attendance_PDC_PAGI.isEmpty
                ? Center(child: Text('Data absensi tidak ditemukan'))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 0,
                      childAspectRatio: 9, // Sesuaikan rasio dengan konten
                    ),
                    itemCount: _attendance_PDC_ONCALL.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: absensi_rangkuman_single(
                          data: _attendance_PDC_ONCALL[index],
                          onDelete: (tipe_absen) async {
                            PinInputDialog.show(context, (p0) async {
                              try {
                                await _deleteEntryAndRefresh(
                                    _attendance_PDC_ONCALL[index], tipe_absen);
                                setState(() {
                                  _loadData();
                                });

                                showToastShort("Terhapus");
                              } catch (e) {
                                showToastShort("Data Sudah Terhapus");
                              }
                            });
                          },
                          onUpdate: () {
                            setState(() {
                              _loadData();
                            });
                          },
                          isLocked: _isLocked,
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 20,
            )
          ],
        )));
  }

  Future<void> _uploadAllAttendance() async {
    AttendanceRepos repo = AttendanceRepos();
    int totalCount = _attendance_PDC_MALAM.length;

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Upload data..');

    for (var index = 0; index < totalCount; index++) {
      bool StillnotCompleteAttendace = false;
      var data = _attendance_PDC_MALAM[index];

      if (data.checkInStatus == null ||
          (data.approval_status_in != null && data.checkInStatus != null)) {
        // print(index.toString() +" || "+ formatDate(data.checkInActual ?? DateTime.now())+" = CHECKIN PASSED");

        if ((data.checkOutStatus == null && data.checkOutActual != null) ||
            (data.checkOutStatus != null && data.approval_status_out != null) ||
            (data.checkOutStatus == null && data.approval_status_out != null)) {
          try {
            progressDialog.update(
              value: ((index / totalCount) * 100).toInt(),
              msg: "Uploading " + data.employee_name! + ' ($index/$totalCount)',
            );

            await repo.uploadAbsensi(data, data.employee_id!);
            await _updateIsUploaded(data);
            // ADZIEHRDY TEST
            print(index.toString() +
                " || " +
                formatDate(data.checkInActual ?? DateTime.now()) +
                " = IS UPLOADED");
          } catch (e) {
            print(e.toString());
            showToast("Error saat upload absensi - ${data.employee_name} - " +
                (data.shift_id ?? "-"));
            break;
          } finally {}
        } else {
          StillnotCompleteAttendace = true;
        }
        // if ((data.checkIn != null && (data.approval_status_in != null || data.checkIn != null) ) &&  (data.approval_status_out != null || data.checkOut != null)) {
        //  if ((data.checkOut != null && data.approval_status_out != null ) || ( data.checkOutStatus != null && data.approval_status_out != null) || data.checkOutStatus == null ) {
        // String mode = data.type_absensi == "MASUK" ? "checkin" : "checkout";
      } else {
        StillnotCompleteAttendace = true;
      }

      if (StillnotCompleteAttendace) {
        showToast(
            "Ada beberapa absensi yang belum terupload karna belum ada approval, mohon approve terlebih dahulu agar bisa terupload");
      }
    }
    progressDialog.close();
    _loadData();
  }

  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text(
              'Anda yakin ingin mengupload semua absen ?, ( data yang belum memiliki absen masuk dan keluar tidak dapat terupload )'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Upload'),
              onPressed: () {
                Navigator.of(context).pop();
                _uploadAllAttendance();
              },
            ),
          ],
        );
      },
    );
  }

  _fillinYgBelumAbsensi_MALAM() async {
    DatabaseHelperEmployee helperEmployee = DatabaseHelperEmployee.instance;
    List<User> employees =
        await helperEmployee.queryAllEmployeeByShift("PDC_MALAM");

    // Buat set untuk menyimpan semua employee_id yang ada di _attendanceList
    Set<String?> existingEmployeeIds =
        _attendance_PDC_MALAM.map((a) => a.employee_id).toSet();

// List sementara untuk menyimpan elemen baru
    List<Attendance> newAttendances = [];

// Iterasi employees dan tambahkan jika employee_id tidak ada di set
    for (User emp in employees) {
      if (!existingEmployeeIds.contains(emp.employee_id)) {
        newAttendances.add(
          Attendance.withData(employee_name: emp.employee_name),
        );
      }
    }

// Tambahkan elemen baru ke _attendanceList
    _attendance_PDC_MALAM.addAll(newAttendances);
    print(employees);
    setState(() {
      _attendance_PDC_MALAM;
    });
  }

  _fillinYgBelumAbsensi_PAGI() async {
    DatabaseHelperEmployee helperEmployee = DatabaseHelperEmployee.instance;
    List<User> employees =
        await helperEmployee.queryAllEmployeeByShift("PDC_PAGI");

    // Buat set untuk menyimpan semua employee_id yang ada di _attendanceList
    Set<String?> existingEmployeeIds =
        _attendance_PDC_PAGI.map((a) => a.employee_id).toSet();

// List sementara untuk menyimpan elemen baru
    List<Attendance> newAttendances = [];

// Iterasi employees dan tambahkan jika employee_id tidak ada di set
    for (User emp in employees) {
      if (!existingEmployeeIds.contains(emp.employee_id)) {
        newAttendances.add(
          Attendance.withData(employee_name: emp.employee_name),
        );
      }
    }

// Tambahkan elemen baru ke _attendanceList
    _attendance_PDC_PAGI.addAll(newAttendances);
    print(employees);
    setState(() {
      _attendance_PDC_PAGI;
    });
  }

  _fillinYgBelumAbsensi_ONCALL() async {
    DatabaseHelperEmployee helperEmployee = DatabaseHelperEmployee.instance;
    List<User> employees =
        await helperEmployee.queryAllEmployeeByShift("PDC_ONCALL");

    // Buat set untuk menyimpan semua employee_id yang ada di _attendanceList
    Set<String?> existingEmployeeIds =
        _attendance_PDC_ONCALL.map((a) => a.employee_id).toSet();

// List sementara untuk menyimpan elemen baru
    List<Attendance> newAttendances = [];

// Iterasi employees dan tambahkan jika employee_id tidak ada di set
    for (User emp in employees) {
      if (!existingEmployeeIds.contains(emp.employee_id)) {
        newAttendances.add(
          Attendance.withData(employee_name: emp.employee_name),
        );
      }
    }

// Tambahkan elemen baru ke _attendanceList
    _attendance_PDC_ONCALL.addAll(newAttendances);
    print(employees);
    setState(() {
      _attendance_PDC_ONCALL;
    });
  }
}
