import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class RegisterPin extends StatefulWidget {
  const RegisterPin({Key? key}) : super(key: key);

  @override
  _RegisterPinState createState() => _RegisterPinState();
}

class _RegisterPinState extends State<RegisterPin> {
  String pin1 = "";
  String pin2 = "";
  bool enableNextButton = false;
  String superAttedance = "-";

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getActiveSuperIntendentName().then((value) {
      setState(() {
        superAttedance = value;
      });
    });
  }

  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Orientation.portrait == true ?
                Lottie.asset(
                  'assets/lottie/pin_regis.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fill,
                ) : Lottie.asset(
                  'assets/lottie/pin_regis.json',
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 15,
                ),
                
                Text(
                  "Registrasi PIN Baru",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                

                // Text(
                //     textAlign: TextAlign.center,
                //     "PIN ini akan digunakan untuk mengakses \n Menu Setting dan Approval",
                //     style: TextStyle(fontSize: 12, color: Colors.grey)),
                //      SizedBox(
                //   height: 5,
                // ),

                Text(
                    textAlign: TextAlign.center,
                    "Untuk",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                     SizedBox(
                  height: 5,
                ),
                    Text(
                  superAttedance,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black),
                ),

                SizedBox(
                  height: 20,
                ),
                Text("Masukan PIN"),

                
                SizedBox(
                  height: 5,
                ),
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
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    setState(() {
                      enableNextButton = false;
                    });
                  },
                  onCompleted: (pin) {
                    setState(() {
                      pin1 = pin;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Konfirmasi PIN"),
                SizedBox(
                  height: 5,
                ),
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
                    if (pin1 == pin2) {
                    } else {
                      return "Pin Tidak Sesuai";
                    }
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onChanged: (value) {
                    setState(() {
                      enableNextButton = false;
                    });
                  },
                  onCompleted: (pin) {
                    setState(() {
                      pin2 = pin;
                    });
                    checkPin();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                    visible: enableNextButton,
                    child: ElevatedButton(
                      onPressed: () async {
                        await savePIN(pin1);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));

                      },
                      child: Text("Selanjutnya"),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkPin() {
    setState(() {});
    if (pin1 != pin2 && pin1 != "" && pin2 != "") {
      // PINs do not match, show error message and clear PINs

      setState(() {
        enableNextButton = false;
      });
    } else {
      setState(() {
        enableNextButton = true;
      });

      // PINs match, continue with your logic
      // You can add your logic here
    }
  }
}
