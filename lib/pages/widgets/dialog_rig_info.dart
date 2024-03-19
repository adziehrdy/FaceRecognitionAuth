import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';

class dialog_rig_info extends StatefulWidget {
  const dialog_rig_info({super.key});

  @override
  _dialog_rig_infoState createState() => _dialog_rig_infoState();
}

class _dialog_rig_infoState extends State<dialog_rig_info> {
  String RigName = "";
  RigStatusShift? brachStatus;
  String tolerance = "0";
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return SingleChildScrollView(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 10),
              blurRadius: 100,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "INFORMASI RIG",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            // ),
            // SizedBox(
            //   height: 5,
            // ),
            Text(
              "NAMA RIG",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              RigName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "STATUS RIG",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              brachStatus?.statusBranch ?? "-",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            SizedBox(
              height: 10,
            ),

            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                width: 350,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: brachStatus?.shift?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final shift = brachStatus!.shift?[index];
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shift!.id.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'Checkin: ${shift.checkin} - Checkout: ${shift.checkout}'),
                          SizedBox(
                            height: 10,
                          )
                        ]);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            
            Text("Semua Jam Shift ditambahkan toleransi keterlambatan sebanyak " +tolerance+" jam.",style: TextStyle(fontSize: 12,color: Colors.orange),),
            SizedBox(
              height: 15,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tutup")))
          ],
        ),
      ),
    );
  }

  Future<void> _initData() async {
    LoginModel loginData = await getUserLoginData();
    brachStatus = await SpGetSelectedStatusRig();
    tolerance = (loginData.branch?.tolerance ?? 0).toString();
    RigName = loginData.branch?.branchName ?? "-";

    setState(() {
      tolerance;
      brachStatus;
      RigName;
    });
  }
}
