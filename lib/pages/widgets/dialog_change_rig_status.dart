import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class dialog_change_rig_status extends StatefulWidget {
  final Function(RigStatusShift)? onStatusSelected;

  dialog_change_rig_status({this.onStatusSelected});

  @override
  _dialog_change_rig_statusState createState() =>
      _dialog_change_rig_statusState();
}

class _dialog_change_rig_statusState extends State<dialog_change_rig_status> {
  TextEditingController notesController =
      TextEditingController(); // Track the selected status

  List<RigStatusShift> rig_statuses = [];

  @override
  void initState() {
    super.initState();
    initStatusRig();
  }

  Future<void> initStatusRig() async {
    rig_statuses = await SpGetALLStatusRig();

    setState(() {
      rig_statuses;
      print(rig_statuses);
    });
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
        child: Column(
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
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Set the selected status when a button is pressed

                          if (widget.onStatusSelected != null) {
                            widget.onStatusSelected!(rig_statuses[index]);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(rig_statuses[index].statusBranch ?? "-"),
                      ),
                    ),
                    // Container(
                    //   width: 20,
                    //   child: IconButton(onPressed: (){

                    //   }, icon: Icon(Icons.info_outline)),
                    // )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
