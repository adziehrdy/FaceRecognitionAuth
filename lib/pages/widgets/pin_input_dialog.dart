import 'package:face_net_authentication/globals.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class CustomPinDialog extends StatefulWidget {
  final Function(String) onPinEntered;

  CustomPinDialog({required this.onPinEntered});

  @override
  _CustomPinDialogState createState() => _CustomPinDialogState();
}

class _CustomPinDialogState extends State<CustomPinDialog> {
  String? CorrectPin;
  String SuperIntendentName = "-";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPIN().then((value) {
      setState(() {
        CorrectPin = value;
      });
    });

    getActiveSuperIntendentName().then((value) {
      setState(() {
        SuperIntendentName = value;
      });
    },);

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
    return 
    SingleChildScrollView(child: Container(
      padding: EdgeInsets.all(20),
      width: 400,
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
         SizedBox(height: 15),
          Lottie.asset(
            'assets/lottie/pin_regis.json',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 0),
          Text(
            'Masukan PIN',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          Text(
            SuperIntendentName.toUpperCase(),
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
           SizedBox(height: 15),
          Pinput(
            defaultPinTheme: defaultPinTheme.copyDecorationWith(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(100)),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration?.copyWith(
                color: Color.fromRGBO(234, 239, 243, 1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            length: 6,
            keyboardType: TextInputType.number,
            obscureText: true,
            validator: (s) {
              return s == CorrectPin ? null : 'Pin Salah, Mohon Coba Kembali';
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) {
              if (pin == CorrectPin) {
                Navigator.of(context).pop();
                widget.onPinEntered(pin);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ),
        ],
      ),
    ),);
  }
}

class PinInputDialog {
  static void show(BuildContext context, Function(String) onPinEntered) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPinDialog(onPinEntered: onPinEntered);
      },
    );
  }
}
