import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
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

  Future<void> _deleteEntryAndRefresh(Attendance entryToDelete) async {
    await DatabaseHelperAbsensi.instance
        .deleteAttendance(entryToDelete.attendanceId!);
    setState(() {
      _attendanceList.remove(entryToDelete);
    });
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
        title: Text('Data absensi'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {

               PinInputDialog.show(context, (p0) {
              _showConfirmationDialog();
               }
               );

            },
          ),
        ],
      ),
      body: _attendanceList.isEmpty
          ? Center(
              child: Text('Data absensi kosong'),
            )
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    AttendanceSingle(
                      data: _attendanceList[index],
                      onDelete: () async {
                        PinInputDialog.show(context, (p0) async {
              try {
                          await _deleteEntryAndRefresh(_attendanceList[index]);
                          showToast("Terhapus");
                        } catch (e) {
                          showToast("Data Sudah Terhapus");
                        }
               }
               );
                       
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
      
      var data = _attendanceList[index];
      if(data.is_uploaded == false){
String mode = data.type_absensi == "MASUK" ? "checkin" : "checkout";

      try {
        progressDialog.update(
          value: ((index / totalCount) * 100).toInt(),
          msg: "Uploading " + data.employee_name! + ' ($index/$totalCount)',
        );

        await repo.verifyAbsensi(data, mode, data.employee_id!);

        await _updateIsUploaded(data);
      } catch (e) {
        print(e.toString());
        showToast("Error saat upload absensi - ${data.employee_name}");
        break;
      } finally {
        progressDialog.close();
        _loadData();
      }
      }
      
    }
  }

  Future<void> _showConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin mengupload semua absen?'),
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
