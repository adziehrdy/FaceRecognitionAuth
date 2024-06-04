import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:flutter/material.dart';

class dialog_change_catering_status extends StatefulWidget {
  final Function(String shift, bool isActive)? onStatusSelected;
  final String Lastshift;
  final bool LastisActiveCatering;
  final RigStatusShift? ListShift;

  dialog_change_catering_status(
      {this.onStatusSelected,
      required this.ListShift,
      required this.Lastshift,
      required this.LastisActiveCatering});

  @override
  _dialog_change_catering_statusState createState() =>
      _dialog_change_catering_statusState();
}

class _dialog_change_catering_statusState
    extends State<dialog_change_catering_status> {
  TextEditingController notesController =
      TextEditingController(); // Track the selected status

  bool isActiveCatering = false;
  String selectedShift = "-";

  @override
  void initState() {
    super.initState();
    setState(() {
      isActiveCatering = widget.LastisActiveCatering;
      selectedShift = widget.Lastshift;

      if (widget.Lastshift == "-") {
        selectedShift = widget.ListShift!.shift![0].id!;
      }
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
              "PILIH STATUS CATERING",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Text(
              "Status Catering",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Switch(
              value: isActiveCatering,
              onChanged: (value) {
                setState(() {
                  isActiveCatering = value;
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
            ),

            SizedBox(height: 10),
            Text(
              isActiveCatering ? "AKTIF" : "TIDAK AKTIF",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),

            // Use ListView.builder to create a list of status options
            DropdownButtonFormField<String>(
              value: selectedShift,
              decoration: InputDecoration(labelText: "Shift"),
              items: widget.ListShift!.shift!.map((ShiftRig shift) {
                return DropdownMenuItem<String>(
                  value: shift.id,
                  child: Text(shift.id ?? "-"),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedShift = newValue ?? "-";
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: () {
                if (selectedShift != "-") {
                  widget.onStatusSelected!(selectedShift, isActiveCatering);
                  Navigator.pop(context);
                } else {
                  showToast("Mohon Memilih Shift Terlebih dahulu");
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
