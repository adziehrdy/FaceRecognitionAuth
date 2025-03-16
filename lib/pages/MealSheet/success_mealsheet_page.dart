import 'dart:typed_data';

import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/MealSheet/database_helper_mealsheet.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_const.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_func.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/repo/attendance_repos.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class successMealSheetPage extends StatefulWidget {
  const successMealSheetPage(
      {Key? key,
      required this.jamAbsensi,
      required this.faceImage,
      required this.user})
      : super(key: key);
  final DateTime jamAbsensi;
  final Uint8List faceImage;
  final User user;

  @override
  _successMealSheetPageState createState() => _successMealSheetPageState();
}

class _successMealSheetPageState extends State<successMealSheetPage> {
  intl.DateFormat dateFormatText = intl.DateFormat('hh:mm:ss');

  bool showJam = true;
  Color statusColor = Colors.white;
  String statusMessage = "...";
  bool isSuccess = false;

  DatabaseHelperMealsheet databaseHelperMealsheet =
      DatabaseHelperMealsheet.instance;

  int _counter = 10;
  bool isLoading = true;
  String foodAnim = foodAnimation[randomIndex(foodAnimation.length)];

  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    String? actived_shedule = classifyMealTime(DateTime.now()
        .add(Duration(hours: CONSTANT_VAR.MEAL_SUBSTACT_FOR_DEBUG)));
    String result = await databaseHelperMealsheet.insertOrUpdateData(
        widget.user,
        DateTime.now()
            .add(Duration(hours: CONSTANT_VAR.MEAL_SUBSTACT_FOR_DEBUG)),
        actived_shedule!);
    setState(() {
      if (result == "SUCCESS") {
        isSuccess = true;
        statusColor = Colors.blue;
        statusMessage = "Absen $actived_shedule berhasil";
      } else {
        isSuccess = false;
        statusColor = Colors.red;
        statusMessage = result;
      }
    });
    if (isSuccess) {
      await successSound();
    }
    // startTimer();
  }

  Future<void> startTimer() async {
    Future.delayed(Duration(seconds: 1), () async {
      if (_counter > 1) {
        setState(() {
          _counter--;
        });
        startTimer();
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        bool isSingleAbsensi = prefs.getBool("SINGLE_ATTENDANCE_MODE") ?? false;

        if (isSingleAbsensi) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  Future<int> getTimeOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _delayTimeout = await prefs.getInt('DELAY_TIMEOUT') ?? 3;
    return _delayTimeout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Colors.indigo,
              statusColor
            ], // Ubah warna gradasi sesuai kebutuhan
            begin: Alignment.bottomRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _attendanceCard(),
            isSuccess ? _greetingCard() : SizedBox()
          ],
        )),
      ),
    );
  }

  Widget _attendanceCard() {
    return Card(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   'assets/lottie/success.json',
          //   width: 200,
          //   height: 200,
          //   fit: BoxFit.fill,
          // ),
          Container(
            height: 170,
            width: 170,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: 1.5, // Adjust the scale factor to zoom in
                      child: LottieBuilder.asset(
                        "assets/lottie/face_circle.json",
                        height: 250,
                        width: 250,
                        repeat: false,
                        frameRate: FrameRate(30),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.memory(
                      widget.faceImage,
                      width: 125,
                      height: 125,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.user.employee_name!.toUpperCase(),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Text(
          //     widget.user.shift_id!.toUpperCase(),
          //     style: TextStyle(fontSize: 15),
          //     maxLines: 1,
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          SizedBox(height: 15),

          if (isSuccess)
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                    ),
                    Column(
                      children: [
                        Text(
                          formatHourOnly(widget.jamAbsensi),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),

          SizedBox(),

          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
            decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Text(
              statusMessage,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Otomatis kembali $_counter detik',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    ));
  }

  Widget _greetingCard() {
    return Expanded(
        child: Card(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Selamat Makan!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Lottie.asset(
                                'assets/lottie/mealsheet/$foodAnim.json',
                                width: 230,
                                height: 250),
                            Container(
                              width: 300,
                              child: Text(
                                  textAlign: TextAlign.center,
                                  ucapanSelamatMakan[
                                      randomIndex(ucapanSelamatMakan.length)],
                                  maxLines: 4,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }
}
