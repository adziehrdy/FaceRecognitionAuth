import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:face_net_authentication/pages/widgets/attendance_anomaly_single.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ApprovalTerlambat extends StatefulWidget {
  const ApprovalTerlambat({Key? key}) : super(key: key);

  @override
  _ApprovalTerlambatState createState() => _ApprovalTerlambatState();
}

class _ApprovalTerlambatState extends State<ApprovalTerlambat> {
  DatabaseHelperAbsensi _dataBaseHelper = DatabaseHelperAbsensi.instance;

  List<Attendance> user_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return user_list.isNotEmpty
        ? Container(
            child: ListView.builder(
                itemCount: user_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return AttendanceAnomalySingle(
                    data: user_list[index],
                    onApprove: () async {

                  
                       await _dataBaseHelper.approveAbsensi(user_list[index].attendanceId!,await getActiveSuperIntendentID());
                        _loadUserData();
                    },
                  );
                }),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    "Approval Absensi Terlambat",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                Lottie.asset(
                  'assets/lottie/no_data.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                Text(
                    textAlign: TextAlign.center,
                    "Tidak Ada Approval Untuk\nAbsensi Terlambat",
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          );
    ;
  }

  Future<void> _loadUserData() async {
    user_list = await _dataBaseHelper.getAnomalyAbsensi();
    // print(user_list);
    setState(() {});
  }


}
