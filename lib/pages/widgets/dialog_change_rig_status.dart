import 'dart:convert';

import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class dialog_change_rig_status extends StatefulWidget {
  @override
  _dialog_change_rig_statusState createState() =>
      _dialog_change_rig_statusState();
}

class _dialog_change_rig_statusState extends State<dialog_change_rig_status> {
  TextEditingController notesController =
      TextEditingController(); // Track the selected status
  List<BranchStatus> rig_statuses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rig_statuses = getAllBrachStatus(COSTANT_VAR.SHIFT_RIG_DUMMY);
    print(rig_statuses);
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
        width: 300,
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
        child: 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "PILIH STATUS RIG",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Lottie.asset(
              'assets/lottie/approval.json',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              "Pilih Status:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            // Use ListView.builder to create a list of status options
            ListView.builder(
              shrinkWrap: true,
              itemCount: rig_statuses.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () async {
                    // Set the selected status when a button is pressed
                    await SpSetStatusRig(jsonEncode(rig_statuses[index])); // CARA SAVE STRING DARI OBJEK
                    Navigator.pop(context);
                    // You can add additional logic or callback here
                    // For example, you can call a function to handle the selected status
                  },
                  child: Text(rig_statuses[index].statusBranch),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Callback function to handle the selected status
}

// List<String> status_list = ["IDLE", "OPERATION", "MAINTENANCE", "MOVING"];
