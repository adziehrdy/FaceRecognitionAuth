import 'package:face_net_authentication/globals.dart';
import 'package:flutter/material.dart';

class TestingAbsen extends StatefulWidget {
  const TestingAbsen({Key? key}) : super(key: key);

  @override
  _TestingAbsenState createState() => _TestingAbsenState();
}

class _TestingAbsenState extends State<TestingAbsen> {
  String absenMasuk = "22:00";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<String> times = generateTimeList();

    // for (String absen_time in times) {
    //   String? isTerlambat = checkLemburStatus(
    //       isModeMasuk: false,
    //       jamAbsen: "2024-08-11 " + absen_time,
    //       shiftKeluar: "07:00",
    //       shiftMasuk: "22:00");

    //   print(isTerlambat);

    //   // checkShiftIsOvernight("22:00", absen_time.substring(0, 5));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  List<String> generateTimeList() {
    List<String> timeList = [];

    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');

        timeList.add('$formattedHour:$formattedMinute:00');
      }
    }

    return timeList;
  }
}
