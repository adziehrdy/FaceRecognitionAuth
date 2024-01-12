import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void OnDeleteCallback(String deleteType);

class AttendanceUploadedSingle extends StatefulWidget {
  const AttendanceUploadedSingle({Key? key, required this.data, required this.onDelete})
      : super(key: key);

  final Attendance data;
  // final VoidCallback onDelete;
  final OnDeleteCallback onDelete; // Gunakan tipe OnDeleteCallback

  @override
  _AttendanceUploadedSingleState createState() => _AttendanceUploadedSingleState();
}

class _AttendanceUploadedSingleState extends State<AttendanceUploadedSingle> {

  DatabaseHelperAbsensi _dataBaseHelper = DatabaseHelperAbsensi.instance;

  String jam_in = "-";
  String tanggal_in = "-";
  String bulan_in = "-";
  String status_in = "-";

  String jam_out = "-";
  String tanggal_out = "-";
  String bulan_out = "-";
  String status_out = "-";
  Color typeColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshView();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        ("  " + (widget.data.employee_name ?? "NAME NOT FOUND"))
                            .toUpperCase(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        " ( " + (widget.data.shift ?? "") + " )",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis, fontSize: 8),
                      )
                    ],
                  ),
                  
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spa,
              children: [
                single_absensi_masuk(
                    jam_in,
                    bulan_in,
                    tanggal_in,
                    "ABSEN MASUK",
                    Theme.of(context).colorScheme.primary,
                    status_in),
                Row(
                  children: [
                    Container(
                      color: Colors.black,
                      width: 0.5,
                      height: 15,
                    ),
                    single_absensi_keluar(jam_out, bulan_out, tanggal_out,
                        "ABSEN KELUAR", Colors.deepOrange.shade500, status_out),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget single_absensi_masuk(String jam, String bulan, String Tanggal,
      String Tipe, Color bg_color, String status) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        bg_color,
                        Colors.green
                      ], // Ubah warna gradasi sesuai kebutuhan
                      begin: Alignment.bottomRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Tanggal +" "+bulan,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Tipe,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: bg_color,
                                              fontSize: 10),
                                        ),
                                        
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer_outlined,size: 15,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            jam,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            status,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Container(
                                            height: 25,
                                            child:
                                                InkWell(
                                                  onTap: (){
                                                    showToast("Notes : "+(widget.data.attendanceNoteIn ?? "-") );
                                                  },
                                                  child: Row(
                                                  children: [
                                                    Icon(Icons.notes_sharp,size: 15,),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                        (widget.data.approval_status_in ??
                                                            ""),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                                                  ],
                                                ),)
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget single_absensi_keluar(String jam, String bulan, String Tanggal,
      String Tipe, Color bg_color, String status) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        bg_color,
                        Colors.green
                      ], // Ubah warna gradasi sesuai kebutuhan
                      begin: Alignment.bottomRight,
                      end: Alignment.centerLeft,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Tanggal +" "+bulan,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          Tipe,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: bg_color,
                                              fontSize: 10),
                                        ),
                                        
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer_outlined,size: 15,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            jam,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            status,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Container(
                                            height: 25,
                                            child:
                                                InkWell(
                                                  onTap: (){
                                                    showToast("Notes : "+(widget.data.attendanceNoteOut ?? "-") );
                                                  },
                                                  child: Row(
                                                  children: [
                                                    Icon(Icons.notes_sharp,size: 15,),
                                                    SizedBox(width: 5,),
                                                    Text(
                                                        (widget.data.approval_status_out ??
                                                            ""),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                                                  ],
                                                ),)
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  void _refreshView() {
    setState(() {
      jam_in = "-";
      tanggal_in = "-";
      bulan_in = "-";
      status_in = "-";

      jam_out = "-";
      tanggal_out = "-";
      bulan_out = "-";
      status_out = "-";

      try {
        jam_in = DateFormat('HH:mm').format(widget.data.checkInActual!);
        tanggal_in = DateFormat('d', 'id').format(widget.data.checkInActual!);
        bulan_in = DateFormat('LLL', 'id').format(widget.data.checkInActual!);
        status_in = widget.data.checkInStatus ?? "";
      } catch (e) {
        print(e.toString());
      }

      try {
        jam_out = DateFormat('HH:mm').format(widget.data.checkOutActual!);
        tanggal_out = DateFormat('d', 'id').format(widget.data.checkOutActual!);
        bulan_out = DateFormat('LLL', 'id').format(widget.data.checkOutActual!);
        status_out = widget.data.checkOutStatus ?? "";
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
