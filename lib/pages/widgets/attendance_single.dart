import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/widgets/dialog_approval_absensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void OnDeleteCallback(String deleteType);
typedef void OnUpdate();

class AttendanceSingle extends StatefulWidget {
  const AttendanceSingle(
      {Key? key,
      required this.data,
      required this.onDelete,
      required this.onUpdate})
      : super(key: key);

  final Attendance data;
  // final VoidCallback onDelete;
  final OnDeleteCallback onDelete;
  final OnUpdate onUpdate; // Gunakan tipe OnDeleteCallback

  @override
  _AttendanceSingleState createState() => _AttendanceSingleState();
}

class _AttendanceSingleState extends State<AttendanceSingle> {
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
              height: 35,
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
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        " ( " + (widget.data.shift_id ?? "") + " )",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis, fontSize: 8),
                      )
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
                                showToast("Data Ini Sudah Diupload Ke server");
                              },
                            ),
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
                    DateFormat('HH:mm').format(widget.data.checkInActual!),
                    DateFormat('LLL', 'id').format(widget.data.checkInActual!),
                    DateFormat('d', 'id').format(widget.data.checkInActual!),
                    "ABSEN MASUK",
                    Theme.of(context).colorScheme.primary,
                    widget.data.checkInStatus ?? ""),
                Row(
                  children: [
                    Container(
                      color: Colors.black,
                      width: 0.5,
                      height: 75,
                    ),
                    (widget.data.checkOutActual != null)
                        ? single_absensi_keluar(
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

                    //     single_absensi_keluar(
                    // "-",
                    // "-",
                    // "-",
                    //     "ABSEN KELUAR", Colors.deepOrange.shade500, "BELUM ABSEN KELUAR")
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
                        Tanggal,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Text(
                        bulan,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
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
                                    // Text(
                                    //   (widget.data.employee_name ??
                                    //           "NAME NOT FOUND")
                                    //       .toUpperCase(),
                                    //   style: TextStyle(
                                    //       overflow: TextOverflow.ellipsis,
                                    //       color: Theme.of(context)
                                    //           .colorScheme
                                    //           .primary,
                                    //       fontSize: 15),
                                    // ),
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
                                              fontSize: 13),
                                        ),
                                        Container(
                                          height: 20,
                                          child: Row(
                                            children: [
                                              (widget.data.attendanceAddressOut ==
                                                          null) &&
                                                      (widget.data
                                                              .is_uploaded ==
                                                          "0")
                                                  ? IconButton(
                                                      iconSize: 20,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () async {
                                                        setState(() {
                                                          widget.onDelete(
                                                              "MASUK");
                                                        });
                                                      },
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer_outlined),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            jam,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26,
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
                                              child: (status != "") &&
                                                      (widget.data
                                                              .approval_status_in ==
                                                          null) &&
                                                      (widget.data
                                                              .is_uploaded ==
                                                          "0")
                                                  ? ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateColor
                                                                  .resolveWith(
                                                                      (states) =>
                                                                          Colors
                                                                              .blue)),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return dialog_approval_absensi(
                                                                onSelected:
                                                                    (value) async {
                                                              await _dataBaseHelper
                                                                  .approveAbsensi(
                                                                      widget
                                                                          .data
                                                                          .attendanceId!,
                                                                      await getActiveSuperIntendentID(),
                                                                      value[1],
                                                                      true,
                                                                      value[0]);
                                                              setState(() {
                                                                setState(() {
                                                                  widget
                                                                      .onUpdate();
                                                                });
                                                              });
                                                            });
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        "APPROVAL",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white),
                                                      ))
                                                  : InkWell(
                                                      onTap: () {
                                                        showToast("Notes : " +
                                                            (widget.data
                                                                    .attendanceNoteIn ??
                                                                "-"));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons
                                                              .notes_sharp),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            (widget.data
                                                                    .approval_status_in ??
                                                                ""),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                        ],
                                      ),
                                    ),
                                    // Text(
                                    //   (Tipe),
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       color: typeColor),
                                    // ),
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
            // Row(
            //   children: [
            //     widget.data.is_uploaded == "0"
            //         ? IconButton(
            //             icon: Icon(Icons.delete),
            //             onPressed: () async {
            //               widget.onDelete();
            //             },
            //           )
            //         : IconButton(
            //             icon: Icon(Icons.cloud_circle),
            //             color: Colors.green,
            //             onPressed: () async {
            //               showToast("Data Ini Sudah Diupload Ke server");
            //             },
            //           ),
            //   ],
            // ),
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
                        Tanggal,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Text(
                        bulan,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
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
                                    // Text(
                                    //   (widget.data.employee_name ??
                                    //           "NAME NOT FOUND")
                                    //       .toUpperCase(),
                                    //   style: TextStyle(
                                    //       overflow: TextOverflow.ellipsis,
                                    //       color: Theme.of(context)
                                    //           .colorScheme
                                    //           .primary,
                                    //       fontSize: 15),
                                    // ),
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
                                              fontSize: 13),
                                        ),
                                        Container(
                                          height: 20,
                                          child: Row(
                                            children: [
                                              (widget.data.is_uploaded == "0" &&
                                                      widget.data.checkOut !=
                                                          null)
                                                  ? IconButton(
                                                      iconSize: 20,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () async {
                                                        setState(() {
                                                          widget.onDelete(
                                                              "KELUAR");
                                                        });
                                                      },
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer_outlined),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            jam,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26,
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
                                            child: (status != "") &&
                                                    (widget.data
                                                            .approval_status_out ==
                                                        null) &&
                                                    (widget.data.is_uploaded ==
                                                        "0")
                                                ? ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateColor
                                                                .resolveWith(
                                                                    (states) =>
                                                                        Colors
                                                                            .blue)),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return dialog_approval_absensi(
                                                              onSelected:
                                                                  (value) async {
                                                            await _dataBaseHelper
                                                                .approveAbsensi(
                                                                    widget.data
                                                                        .attendanceId!,
                                                                    await getActiveSuperIntendentID(),
                                                                    value[1],
                                                                    false,
                                                                    value[0]);
                                                            setState(() {
                                                              widget.onUpdate();
                                                            });
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      "APPROVAL",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white),
                                                    ))
                                                : InkWell(
                                                    onTap: () {
                                                      showToast("Notes : " +
                                                          (widget.data
                                                                  .attendanceNoteOut ??
                                                              "-"));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.notes_sharp),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          (widget.data
                                                                  .approval_status_out ??
                                                              ""),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Text(
                                    //   (Tipe),
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       color: typeColor),
                                    // ),
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
            // Row(
            //   children: [
            //     widget.data.is_uploaded == "0"
            //         ? IconButton(
            //             icon: Icon(Icons.delete),
            //             onPressed: () async {
            //               widget.onDelete();
            //             },
            //           )
            //         : IconButton(
            //             icon: Icon(Icons.cloud_circle),
            //             color: Colors.green,
            //             onPressed: () async {
            //               showToast("Data Ini Sudah Diupload Ke server");
            //             },
            //           ),
            //   ],
            // ),
          ],
        ));
  }

  Widget single_absensi_belum_keluar() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(children: [
                  (widget.data.approval_status_out == null) ?
                  Text(
                    "BELUM ABSEN KELUAR",
                  ) : Text(
                    "TIDAK ABSEN KELUAR",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 25,
                    child: (widget.data.approval_status_out == null) &&
                            (widget.data.is_uploaded == "0")
                        ? ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue)),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialog_approval_absensi(
                                      onSelected: (value) async {
                                    await _dataBaseHelper.approveAbsensi(
                                        widget.data.attendanceId!,
                                        await getActiveSuperIntendentID(),
                                        value[1],
                                        false,
                                        value[0]);
                                    setState(() {
                                      widget.onUpdate();
                                    });
                                  });
                                },
                              );
                            },
                            child: Text(
                              "TIDAK ABSEN KELUAR ?",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ))
                        : 
                        Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  showToast("Notes : " +
                                      (widget.data.attendanceNoteOut ?? "-"));
                                },
                                child: 
                                Column(

                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.notes_sharp),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          (widget.data.approval_status_out ?? ""),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ]),
              ),
            ),
            // Row(
            //   children: [
            //     widget.data.is_uploaded == "0"
            //         ? IconButton(
            //             icon: Icon(Icons.delete),
            //             onPressed: () async {
            //               widget.onDelete();
            //             },
            //           )
            //         : IconButton(
            //             icon: Icon(Icons.cloud_circle),
            //             color: Colors.green,
            //             onPressed: () async {
            //               showToast("Data Ini Sudah Diupload Ke server");
            //             },
            //           ),
            //   ],
            // ),
          ],
        ));
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
