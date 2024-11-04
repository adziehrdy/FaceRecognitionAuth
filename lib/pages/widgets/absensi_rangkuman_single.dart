import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _refreshView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.all(Radius.circular(5)),
          //   border: Border.all(color: Colors.grey, width: 0.8), // Tambahkan ini
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                // color: Colors.blue.shade50,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.face,
                          size: 20,
                        ),
                        Text(
                          ("  " +
                                  (widget.data.employee_name ??
                                      "NAME NOT FOUND"))
                              .toUpperCase(),
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              " ( " + (widget.data.shift_id ?? "") + " )",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.blue),
                            ),
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        widget.data.is_uploaded == "0"
                            ? SizedBox()
                            : IconButton(
                                iconSize: 20,
                                icon: Icon(Icons.cloud_circle),
                                color: Colors.green,
                                onPressed: () async {
                                  showToast(
                                      "Data Ini Sudah Diupload Ke server");
                                },
                              ),
                      ],
                    ),
                    Container(
                      width: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          single_absensi_indicator(
                              DateFormat('HH:mm')
                                  .format(widget.data.checkInActual!),
                              DateFormat('LLL', 'id')
                                  .format(widget.data.checkInActual!),
                              DateFormat('d', 'id')
                                  .format(widget.data.checkInActual!),
                              "ABSEN MASUK",
                              Theme.of(context).colorScheme.primary,
                              widget.data.checkInStatus ?? ""),
                          (widget.data.checkOutActual != null)
                              ? single_absensi_indicator(
                                  DateFormat('HH:mm')
                                      .format(widget.data.checkOutActual!),
                                  DateFormat('LLL', 'id')
                                      .format(widget.data.checkOutActual!),
                                  DateFormat('d', 'id')
                                      .format(widget.data.checkOutActual!),
                                  "ABSEN KELUAR",
                                  Colors.deepOrange.shade500,
                                  widget.data.checkOutStatus ?? "")
                              : single_absensi_belum_keluar()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget single_absensi_indicator(String jam, String bulan, String Tanggal,
      String Tipe, Color bg_color, String status) {
    if (jam == null) {
      return Icon(
        Icons.check_circle_sharp,
        color: Colors.grey,
      );
    } else {
      return Icon(
        Icons.check_circle_sharp,
        color: Colors.blue,
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
        color: Colors.blue,
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
