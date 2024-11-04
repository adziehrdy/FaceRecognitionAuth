import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/pages/widgets/absensi_rangkuman_single.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/repo/attendance_repos.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'db/databse_helper_absensi.dart';

class RangkumanAbsensiHarian extends StatefulWidget {
  @override
  _RangkumanAbsensiHarianState createState() => _RangkumanAbsensiHarianState();
}

class _RangkumanAbsensiHarianState extends State<RangkumanAbsensiHarian> {
  List<Attendance> _attendanceList = [];
  List<Attendance> _filteredAttendanceList = [];
  String _searchText = "";
  bool _isSearchVisible = false; // Untuk mengatur visibilitas search bar
  bool _isLocked = true;

  // Getter untuk mendapatkan nilai variabel isLocked
  bool get isLocked => _isLocked;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Attendance> newData =
        await DatabaseHelperAbsensi.instance.getHistoryAbsensi();
    setState(() {
      _attendanceList = newData.reversed.toList();
      _filteredAttendanceList =
          _attendanceList; // Menampilkan semua data saat pertama kali load
    });
  }

  Future<void> _deleteEntryAndRefresh(
      Attendance entryToDelete, String tipe_absen) async {
    if (tipe_absen == "MASUK") {
      await DatabaseHelperAbsensi.instance
          .deleteAttendance(entryToDelete.attendanceId!);
      setState(() {
        _attendanceList.remove(entryToDelete);
      });
    } else {
      await DatabaseHelperAbsensi.instance
          .updateToullAttendanceKeluar(entryToDelete.attendanceId!);

      // Ambil data yang diperbarui dari database setelah pembaruan
      Attendance? updatedEntry = await DatabaseHelperAbsensi.instance
          .getUpdatedAttendance(entryToDelete.attendanceId!);

      // Cari entri yang cocok dalam _attendanceList
      try {
        int index = _attendanceList.indexWhere(
            (entry) => entry.attendanceId == updatedEntry!.attendanceId);

        if (index != -1) {
          // Perbarui entri yang sesuai dengan data yang diperbarui
          _attendanceList[index] = updatedEntry!;
        }
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        _attendanceList;
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

  void _filterAttendanceList(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _filteredAttendanceList =
            _attendanceList; // Tampilkan semua data jika kosong
      });
    } else {
      setState(() {
        _filteredAttendanceList = _attendanceList.where((attendance) {
          return attendance.employee_name!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              attendance.checkInActual.toString().contains(searchText);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Absensi'),
        actions: <Widget>[
          Row(
            children: [
              // Tombol untuk menampilkan atau menyembunyikan search bar
              IconButton(
                icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                    if (!_isSearchVisible) {
                      _searchText = "";
                      _filterAttendanceList(_searchText);
                    }
                  });
                },
              ),
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Bar hanya muncul jika tombol search diaktifkan
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                    _filterAttendanceList(_searchText);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Cari Absensi',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          // Menampilkan data dalam 2 kolom menggunakan GridView
          Expanded(
            child: _filteredAttendanceList.isEmpty
                ? Center(child: Text('Data absensi tidak ditemukan'))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Menampilkan 2 kolom
                    ),
                    itemCount: _filteredAttendanceList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: absensi_rangkuman_single(
                          data: _filteredAttendanceList[index],
                          onDelete: (tipe_absen) async {
                            PinInputDialog.show(context, (p0) async {
                              try {
                                await _deleteEntryAndRefresh(
                                    _filteredAttendanceList[index], tipe_absen);
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
          ),
        ],
      ),
    );
  }

  Future<void> _uploadAllAttendance() async {
    AttendanceRepos repo = AttendanceRepos();
    int totalCount = _attendanceList.length;

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Upload data..');

    for (var index = 0; index < totalCount; index++) {
      bool StillnotCompleteAttendace = false;
      var data = _attendanceList[index];

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
}
