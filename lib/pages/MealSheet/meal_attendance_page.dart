import 'dart:async';

import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/MealSheet/face_detection_view.dart';
import 'package:face_net_authentication/pages/MealSheet/meal_fr_scan.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_const.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_func.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:one_clock/one_clock.dart';

class MealAttendancePage extends StatefulWidget {
  const MealAttendancePage({Key? key}) : super(key: key);

  @override
  _MealAttendancePageState createState() => _MealAttendancePageState();
}

class _MealAttendancePageState extends State<MealAttendancePage> {
  String? actived_shedule = null;
  List<MealSchedule> mealList = List.empty();
  String titleMessage = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentMealTime();
    Timer.periodic(Duration(minutes: 1), (timer) {});
    getCurrentMealTime();
    if (actived_shedule != null) {
      titleMessage = "Waktunya $actived_shedule !";
    } else {
      titleMessage = "Waktu Makan Belum Dimulai";
    }
    mealList = parseMealSchedule(mealSheetSchedule);
  }

  void getCurrentMealTime() {
    setState(() {
      actived_shedule = classifyMealTime(DateTime.now()
          .add(Duration(hours: CONSTANT_VAR.MEAL_SUBSTACT_FOR_DEBUG)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Meal Schedule",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    mealshift(mealList[0].name, mealList[0].startTime,
                        mealList[0].endTime),
                    mealshift(mealList[1].name, mealList[1].startTime,
                        mealList[1].endTime),
                    mealshift(mealList[2].name, mealList[2].startTime,
                        mealList[2].endTime),
                    mealshift(mealList[3].name, mealList[3].startTime,
                        mealList[3].endTime),
                    mealshift(mealList[4].name, mealList[4].startTime,
                        mealList[4].endTime),
                  ]),
              // Card(
              //     child: Container(
              //   padding: EdgeInsets.all(20),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Container(
              //         width: 200,
              //         child: Text(
              //             maxLines: 30,
              //             mealTips[randomIndex(mealTips.length)],
              //             style: TextStyle(fontSize: 15)),
              //       )
              //     ],
              //   ),
              // )),
              Expanded(
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
                                      DigitalClock(
                                          textScaleFactor: 1,
                                          showSeconds: true,
                                          isLive: true,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              )),
                                          datetime: DateTime.now().add(Duration(
                                              hours: CONSTANT_VAR
                                                  .MEAL_SUBSTACT_FOR_DEBUG))),
                                      Text(
                                        titleMessage,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                      Lottie.asset(
                                          'assets/lottie/mealsheet/mealsheet1.json',
                                          width: 230,
                                          height: 250),
                                      Container(
                                        width: 300,
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            ucapanPolaMakanSehat[randomIndex(
                                                ucapanPolaMakanSehat.length)],
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13)),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      actived_shedule != null
                                          ? ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue)),
                                              onPressed: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MealFRScan(
                                                        MODE: actived_shedule!,
                                                      ),
                                                    ));
                                                getCurrentMealTime();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  "Ambil Makan Untuk $actived_shedule",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ))
                                          : Text(
                                              "Mohon Kembali Saat Waktu Makan Sudah Dimulai",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))))
            ],
          ),
        ));
  }

  Widget mealshift(String name, String start, String end) {
    List<Color> colorStatus = [Colors.blue, Colors.indigo];
    String status = "Waktu tidak aktif";
    bool isActive = false;
    if (actived_shedule == name) {
      isActive = true;
    }
    if (isActive) {
      colorStatus = [Colors.green, Colors.blue];
      status = "Waktu Makan Sedang Belangsung";
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: List.generate(
            5,
            (index) => BoxShadow(
              color: Colors.grey.withAlpha(100),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: colorStatus,
            begin: Alignment.bottomRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.local_dining,
                  color: Colors.white.withAlpha(200), size: 15),
            ),
            isActive
                ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Lottie.asset(
                        'assets/lottie/mealsheet/mealsheet1.json',
                        reverse: true,
                        width: 40,
                        height: 40),
                  )
                : SizedBox(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.fastfood_rounded,
                        color: Colors.white.withAlpha(200), size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Text(
                        name,
                        style: TextStyle(
                            color: Colors.white.withAlpha(200),
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        color: Colors.white.withAlpha(200), size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Text(
                        start + " - " + end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    status,
                    style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
