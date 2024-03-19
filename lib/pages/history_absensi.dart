import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/widgets/attendance_single.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/repo/attendance_repos.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class HistoryAbsensi extends StatefulWidget {
  @override
  _HistoryAbsensiState createState() => _HistoryAbsensiState();
}

class _HistoryAbsensiState extends State<HistoryAbsensi> {
  List<Attendance> _attendanceList = [];
  bool isLoked = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Attendance> newData =
        await DatabaseHelperAbsensi.instance.getHistoryAbsensi();
    setState(() {
      _attendanceList =
          newData.reversed.toList(); // Replace the list instead of adding to it
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Absensi'),
        actions: <Widget>[
          Row(
            children: [
              // isLoked ? Icon(Icons.lock,color: Colors.grey,): Icon(Icons.lock_open,color: Colors.blue,),
              // SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  PinInputDialog.show(context, (p0) {
                    _showConfirmationDialog();
                  });
                },
                child: Row(children: [
                  Icon(Icons.cloud_circle),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Upload Absensi"),
                  SizedBox(
                    width: 10,
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
      body: _attendanceList.isEmpty
          ? Center(
              child: Text('Data absensi yang belum di upload kosong'),
            )
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    AttendanceSingle(
                      data: _attendanceList[index],
                      onDelete: (tipe_absen) async {
                        PinInputDialog.show(context, (p0) async {
                          try {
                            await _deleteEntryAndRefresh(
                                _attendanceList[index], tipe_absen);
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
                    ),
                  ],
                );
              },
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
