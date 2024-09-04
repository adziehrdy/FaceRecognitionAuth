import 'dart:typed_data';

import 'package:flutter/material.dart';

class dialog_confirm_fr extends StatefulWidget {
  const dialog_confirm_fr(
      {super.key, required this.faceImage, required this.employeeName, required this.onApprove});

  @override
  _dialog_confirm_frState createState() => _dialog_confirm_frState();

  final Uint8List faceImage;
  final String employeeName;
  final VoidCallback onApprove;
}

class _dialog_confirm_frState extends State<dialog_confirm_fr> {
  TextEditingController notesController = TextEditingController();
  String selectedStatus = ""; // Track the selected status

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.employeeName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            ClipOval(
              child: Image.memory(
                widget.faceImage,
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Foto Ulang",
                      style: TextStyle(color: Colors.red),
                    )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(onPressed: () {

                  widget.onApprove();

                }, child: Text("Approve"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
