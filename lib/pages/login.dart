import 'dart:io';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/repo/user_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:lottie/lottie.dart';
// import 'package:get_mac_address/get_mac_address.dart';
// import 'package:imei/imei.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _focusUsername = FocusNode();
  FocusNode _focusPassword = FocusNode();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? rememberMe;
  bool showPassword = false;
  TextEditingController? nipCtrl;
  TextEditingController? passCtrl;
  String versionLabel = ' ';
  String deviceID = "-";
  // final _getMacAddressPlugin = GetMacAddress();
  UserRepo repo = UserRepo();

  @override
  void initState() {
    super.initState();

    setDeviceOrientationByDevice();

    rememberMe = true;
    showPassword = false;
    nipCtrl = TextEditingController();
    passCtrl = TextEditingController();

    // initPlatformState();

    getPackageLabel();

    _focusUsername.addListener(() {
      setState(() {});
    });
    _focusPassword.addListener(() {
      setState(() {});
    });
  }

  getPackageLabel() async {
    PackageInfo info = await PackageInfo.fromPlatform();

    // deviceID = await getDeviceId();

    deviceID = await FlutterUdid.udid;

    if (Platform.isIOS) {
      deviceID = deviceID.substring(0, 18);
    }

    setState(() {
      versionLabel = 'v.' + info.version;
      deviceID;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF015284), // Set the status bar color
    ));

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 100),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child:
                      // Image.asset(
                      //   "assets/images/image_login.png",
                      //   width: MediaQuery.of(context).size.width,
                      //   fit: BoxFit.fitHeight,
                      //   height: 250,
                      // ),
                      Container(
                    height: 200,
                    child: Lottie.asset("assets/lottie/opening.json",
                        animate: true, repeat: true),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _focusUsername.hasFocus
                              ? Color(0xFF0073BD)
                              : Colors.grey,
                          width: _focusUsername.hasFocus ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("DEVICE ID - " + deviceID),
                    ),
                    Container(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _focusPassword.hasFocus
                              ? Color(0xFF0073BD)
                              : Colors.grey,
                          width: _focusPassword.hasFocus ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Focus(
                        focusNode: _focusPassword,
                        child: TextField(
                          controller: passCtrl,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: _setShowPassword,
                              child: Icon(
                                showPassword
                                    ? Icons.remove_red_eye
                                    : Icons.password_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                    ),
                    Container(
                      height: 8,
                    ),
                    Container(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        ///ADZIEHRDY
                        await repo.hitLogin(context, deviceID,
                            passCtrl!.value.text, versionLabel);
                        // PinInputDialog.show(context, (p0) {
                        //   print("xx"+p0);
                        // },);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x40B4FF), Colors.blue],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(versionLabel, style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onRememberMe(bool? val) {
    setState(() {
      rememberMe = val;
    });
  }

  // Future<void> initPlatformState() async {
  //   String macAddress;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     macAddress =
  //         await _getMacAddressPlugin.getMacAddress() ?? 'Unknown mac address';
  //   } on PlatformException {
  //     macAddress = 'Failed to get mac address.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     deviceID = macAddress;
  //   });
  // }

  Widget buildTextFieldContainer({TextField? child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        height: 49,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.4),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(padding: const EdgeInsets.only(top: 2.0), child: child),
      ),
    );
  }

  _setShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void dispose() {
    _focusUsername.dispose();
    super.dispose();
  }
}
