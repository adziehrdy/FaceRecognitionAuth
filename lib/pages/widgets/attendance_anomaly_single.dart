import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceAnomalySingle extends StatefulWidget {
  const AttendanceAnomalySingle(
      {Key? key, required this.data, required this.onApprove})
      : super(key: key);

  final Attendance data;
  final VoidCallback onApprove;

  @override
  _AttendanceAnomalySingleState createState() =>
      _AttendanceAnomalySingleState();
}

class _AttendanceAnomalySingleState extends State<AttendanceAnomalySingle> {
  String jam = "";
  String tanggal = "";
  String bulan = "";
  Color typeColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tanggal = DateFormat('d', 'id').format(widget.data.attendanceDate!);

    bulan = DateFormat('LLL', 'id').format(widget.data.attendanceDate!);

    DateTime actualClock;
    if (widget.data.type_absensi == "MASUK") {
      actualClock = widget.data.checkInActual!;
      typeColor = Colors.green;
    } else {
      actualClock = widget.data.checkOutActual!;
      typeColor = Colors.purple;
    }

    jam = DateFormat('HH:mm').format(actualClock);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey, width: 0.8), // Tambahkan ini
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.primary),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        tanggal,
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
                                    Text(
                                      widget.data.employee_name!.toUpperCase(),
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: 
                                      Row(
                                        children: [
                                          Icon(Icons.timer_outlined),
                                          SizedBox(width: 5,),
                                          Text(
                                            jam,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 17,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (widget.data.type_absensi ?? ""),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: typeColor),
                                        ),
                                                                                Text(
                                          (" ( " +(widget.data.note_status ?? "")+" ) "),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: typeColor),
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
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    widget.onApprove();
                  },
                  child: Text("Approve"),
                ),
              ],
            )
          ],
        ));
  }
}
