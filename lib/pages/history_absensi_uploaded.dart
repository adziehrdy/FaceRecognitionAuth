import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/widgets/attendance_uploaded_single.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HistoryAbsensiUploaded extends StatefulWidget {
  @override
  _HistoryAbsensiUploadedState createState() => _HistoryAbsensiUploadedState();
}

class _HistoryAbsensiUploadedState extends State<HistoryAbsensiUploaded> {
  List<Attendance> _attendanceList = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Attendance> newData =
        // await DatabaseHelperAbsensi.instance.getHistoryAbsensiTerUpload();
        await DatabaseHelperAbsensi.instance
            .getHistoryAbsensiTerUploadFilterDate(_selectedDate);
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

      setState(() {
        // Cari entri yang cocok dalam _attendanceList
        int index = _attendanceList.indexWhere(
            (entry) => entry.attendanceId == updatedEntry!.attendanceId);

        if (index != -1) {
          // Perbarui entri yang sesuai dengan data yang diperbarui
          _attendanceList[index] = updatedEntry!;
        }
      });
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
      // appBar: AppBar(
      //   title: Text('Data Absensi Terupload'),
      // ),
      body:
          // _attendanceList.isEmpty
          //     ? Center(
          //         child: Text('Tidak ada data absensi yang sudah terupload'),
          //       )
          //     :

          Column(
        children: [
          Container(
            height: 20,
             color: Colors.blue.shade100.withOpacity(0.2),
          ),

          // Text('Data Absensi Terupload'),
          // SizedBox(height: 5,),
          Container(
            color: Colors.blue.shade100.withOpacity(0.2),
            height: 90,
            child: DatePicker(
              DateTime.now().subtract(Duration(days: 14)),
              daysCount: 15,

              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.blue,
              // monthTextStyle: TextStyle(fontSize: 8),
              // dayTextStyle: TextStyle(fontSize: 8),
              locale: "ID",
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                // New date selected
                setState(() {
                  _selectedDate = date;
                  setState(() {
                    _loadData();
                  });
                });
              },
            ),
          ),
          (_attendanceList.length != 0)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _attendanceList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          AttendanceUploadedSingle(
                            data: _attendanceList[index],
                            onDelete: (tipe_absen) async {
                              PinInputDialog.show(context, (p0) async {
                                try {
                                  await _deleteEntryAndRefresh(
                                      _attendanceList[index], tipe_absen);
                                  showToastShort("Terhapus");
                                } catch (e) {
                                  showToastShort("Data Sudah Terhapus");
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                          textAlign: TextAlign.center,
                          "History Absensi Terupload",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                      Lottie.asset(
                        'assets/lottie/nodata.json',
                        width: 300,
                        height: 300,
                        fit: BoxFit.fill,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          "Tidak Ada History Untuk Tanggal " +
                              formatDateRegisterForm(_selectedDate),
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
