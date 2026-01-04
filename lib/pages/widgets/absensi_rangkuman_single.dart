import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/pages/widgets/attendance_single.dart';
import 'package:face_net_authentication/pages/widgets/dialog_approval_absensi.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/databse_helper_absensi.dart';

typedef void OnDeleteCallback(String deleteType);
typedef void OnUpdate();

class absensi_rangkuman_single extends StatefulWidget {
  const absensi_rangkuman_single(
      {Key? key,
      required this.data,
      required this.onDelete,
      required this.onUpdate,
      required this.isLocked}) // Added isLocked as per instructions
      : super(key: key);

  final Attendance data;
  // final VoidCallback onDelete;
  final OnDeleteCallback onDelete;
  final OnUpdate onUpdate;
  final bool isLocked; // Added isLocked as per instructions

  @override
  _absensi_rangkuman_singleState createState() =>
      _absensi_rangkuman_singleState();
}

class _absensi_rangkuman_singleState extends State<absensi_rangkuman_single> {
  DatabaseHelperAbsensi _dataBaseHelper = DatabaseHelperAbsensi.instance;

  // String jam_in = "-";
  // String tanggal_in = "-";
  // String bulan_in = "-";
  // String status_in = "-";

  // String jam_out = "-";
  // String tanggal_out = "-";
  // String bulan_out = "-";
  // String status_out = "-";
  Color typeColor = Colors.black;
  Color bgColor = Colors.white;
  String tanggalMasuk = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data.checkIn == null) {
      bgColor = Colors.grey.shade400;
      tanggalMasuk = "Belum Absen Masuk";
    } else {
      tanggalMasuk = formatDateFriendly(widget.data.checkIn!);
    }
    // _refreshView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        if (widget.data.checkIn != null && widget.data.is_uploaded != "1") {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              // Sesuaikan padding jika diperlukan
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.28, // Batas maksimum lebar
                  maxWidth: MediaQuery.of(context).size.width *
                      1, // Batas maksimum lebar
                ),
                child: AttendanceSingle(
                  data: widget.data,
                  onDelete: (tipe_absen) async {},
                  onUpdate: () {},
                  isLocked: true,
                ),
              ),
            ),
          );
        }
      },
      child: Card(
        color: bgColor,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Container(
              height: 35, // Ketinggian hanya untuk row ini
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.face, size: 20),
                      Text(
                        ("  " + (widget.data.employee_name ?? "NAME NOT FOUND"))
                            .toUpperCase(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(width: 5),
                      Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            " ( " + (tanggalMasuk) + " )",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ],
                      ))
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            widget.data.is_uploaded == "1"
                                ? IconButton(
                                    icon: Icon(Icons.cloud_circle),
                                    color: Colors.green,
                                    onPressed: () async {
                                      showToast(
                                          "Data Ini Sudah Diupload Ke server");
                                    },
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        single_absensi_indicator(
                            widget.data.checkInActual?.toIso8601String() ??
                                null,
                            "ABSEN MASUK",
                            Theme.of(context).colorScheme.primary,
                            widget.data.checkInStatus ?? ""),
                        (widget.data.checkOutActual != null)
                            ? single_absensi_indicator(
                                widget.data.checkOutActual?.toIso8601String() ??
                                    null,
                                "ABSEN KELUAR",
                                Colors.deepOrange.shade500,
                                widget.data.checkOutStatus ?? "")
                            : single_absensi_belum_keluar(),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget single_absensi_indicator(
      String? attendance, String Tipe, Color bg_color, String status) {
    if (attendance == null) {
      return Icon(
        Icons.check_circle_sharp,
        color: Colors.grey,
      );
    } else {
      return Icon(
        Icons.check_circle_sharp,
        color: Colors.green,
      );
    }
  }

  Widget single_absensi_belum_keluar() {
    if (widget.data.attendanceNoteOut == null) {
      return Icon(
        Icons.check_circle_sharp,
        color: Colors.grey,
      );
    } else {
      return Icon(
        Icons.file_present_sharp,
        color: Colors.green,
      );
    }
  }

  void _refreshView() {
    setState(() {
      // jam_in = "-";
      // tanggal_in = "-";
      // bulan_in = "-";
      // status_in = "-";

      // jam_out = "-";
      // tanggal_out = "-";
      // bulan_out = "-";
      // status_out = "-";

      // try {
      //   jam_in = DateFormat('HH:mm').format(widget.data.checkInActual!);
      //   tanggal_in = DateFormat('d', 'id').format(widget.data.checkInActual!);
      //   bulan_in = DateFormat('LLL', 'id').format(widget.data.checkInActual!);
      //   status_in = widget.data.checkInStatus ?? "";
      // } catch (e) {
      //   print(e.toString());
      // }

      // try {
      //   jam_out = DateFormat('HH:mm').format(widget.data.checkOutActual!);
      //   tanggal_out = DateFormat('d', 'id').format(widget.data.checkOutActual!);
      //   bulan_out = DateFormat('LLL', 'id').format(widget.data.checkOutActual!);
      //   status_out = widget.data.checkOutStatus ?? "";
      // } catch (e) {
      //   print(e.toString());
      // }
    });
  }
}
