import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class dialog_approval_absensi extends StatefulWidget {
  final Function(List<String>) onSelected;

  dialog_approval_absensi({required this.onSelected});

  @override
  _dialog_approval_absensiState createState() =>
      _dialog_approval_absensiState();
}

class _dialog_approval_absensiState extends State<dialog_approval_absensi> {
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final defaultPinTheme = PinTheme(
    width: 35,
    height: 35,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(100),
    ),
  );

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
        width: 450,
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
              "Approval Absensi",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Lottie.asset(
              'assets/lottie/approval.json',
              width: 200,
              height: 200,
            ),
            Stack(
              children: [
                TextFormField(
                  controller: notesController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Notes Approval',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.paste,
                      size: 20,
                    ),
                    onPressed: () async {
                      String? pasteText = await _PasteFunc();

                      if (pasteText != null) {
                        setState(() {
                          notesController.text = pasteText;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      widget.onSelected(["REJECTED", notesController.text]);
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.red),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      widget.onSelected(["APPROVED", notesController.text]);
                    },
                    child: Text("Approve")),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> _PasteFunc() async {
  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
  String? clipboardText = clipboardData?.text;
  return clipboardText;
}
