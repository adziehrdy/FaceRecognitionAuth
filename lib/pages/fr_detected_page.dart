import 'dart:typed_data';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/repo/attendance_repos.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrDetectedPage extends StatefulWidget {
  const FrDetectedPage(
      {Key? key,
      // required this.employee_name,
      required this.textJamAbsensi,
      required this.jamAbsensi,
      required this.alamat,
      required this.lat,
      required this.long,
      // required this.company_id,
      // required this.employee_id,
      required this.type_absensi,
      required this.faceImage,
      required this.user})
      : super(key: key);
  // final String employee_name;
  final DateTime jamAbsensi;
  final String textJamAbsensi;
  final String alamat;
  final String lat;
  final String long;

  // final String company_id;
  // final String employee_id;
  final String type_absensi;
  final Uint8List faceImage;

  final User user;

  @override
  _FrDetectedPageState createState() => _FrDetectedPageState();
}

class _FrDetectedPageState extends State<FrDetectedPage> {
  intl.DateFormat dateFormatText = intl.DateFormat('hh:mm:ss');

  ButtonState buttonState = ButtonState.loading;
  String info = "";
  AttendanceRepos repo = AttendanceRepos();
  String status = "";
  bool showJam = false;
  bool isOvernight = false;
  String? note_status = null;
  String checkin_onShift = "";
  String checkOut_onShift = "";
  String branch_status_id = "";
  String attendance_location_id = "";
  String Tipe_absensi = "REGULER";

  ProgressButton progressbutt = ProgressButton(
    stateWidgets: {
      ButtonState.idle: Text(
        "Idle",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      ButtonState.loading: Text(
        "Loading",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      ButtonState.fail: Text(
        "Fail",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      ButtonState.success: Text(
        "Success",
        style: TextStyle(
            color: const Color.fromARGB(255, 53, 47, 47),
            fontWeight: FontWeight.w500),
      )
    },
    stateColors: {
      ButtonState.idle: Colors.grey.shade400,
      ButtonState.loading: Colors.blue.shade300,
      ButtonState.fail: Colors.red.shade300,
      ButtonState.success: Colors.green.shade400,
    },
    // onPressed: ,
    state: ButtonState.fail,
  );

  int _counter = 10;
  bool isLoading = true;

  void initState() {
    super.initState();

    //CHECK IS DK OR NOT
    if (DKStatusChecker(widget.user.dk_start_date, widget.user.dk_end_date)) {
      Tipe_absensi = "DINAS KHUSUS";
    }

    //CHECK IS RELIEF OR NOT

    if (widget.user.is_relief_employee == "1") {
      Tipe_absensi = "RELIEF";
    }

    try {
      SpGetSelectedStatusRig().then(
        (value) {
          branch_status_id = value!.statusBranchId!;
        },
      );
    } catch (e) {
      showToast("branch_status_id tidak ditemukan, mohon hubungi admin");
      Navigator.pop(context);
    }

    setTolerance().then((value) {
      isOvernight =
          checkShiftIsOvernight(widget.user.check_in!, widget.user.check_out!);
      getTimeOut().then((value) {
        _counter = value;
      });

      // checOut();

      if (widget.type_absensi == "MASUK") {
        saveAbsenMasuk();
      } else {
        saveAbsenKeluar();
      }
    });
  }

  Future<void> startTimer() async {
    Future.delayed(Duration(seconds: 1), () {
      if (_counter > 1) {
        setState(() {
          _counter--;
        });
        startTimer();
      } else {
        Navigator.pop(context);
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white
            ], // Ubah warna gradasi sesuai kebutuhan
            begin: Alignment.bottomRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Center(
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

              ClipOval(
                child: Image.memory(
                  widget.faceImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.user.employee_name!.toUpperCase(),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.user.shift_id!.toUpperCase(),
                  style: TextStyle(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 5),

              if (showJam)
                Column(
                  children: [
                    Text(
                      'Kordinat',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      widget.lat + "," + widget.long,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.alamat,
                        style: TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        Text(
                          'Jam Absensi',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          dateFormatText.format(widget.jamAbsensi),
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),

              SizedBox(),

              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Text(
                  status,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 10),
              // Container(
              //   width: 300,
              //   child: buildCustomButton(),
              // ),
              Text(info),
              SizedBox(height: 10),
              Text(
                'Otomatis kembali $_counter detik',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveAbsenMasuk() async {
    // LoadingDialog.showLoadingDialog(context, "Submitting absensi...");
    // Map<String, dynamic> result = await repo.canCheckIn(_employee_id);
    // bool canCheckIn = result["canCheckIn"];

    intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd');
    String attendndaceDateString = dateFormat.format(widget.jamAbsensi);

    if (widget.user.check_in != widget.user.check_out) {
      if (!isOvernight) {
        if (terlambatChecker(widget.textJamAbsensi, checkin_onShift)) {
          note_status = "TERLAMBAT";
        }
      } else {
        String? result = checkLemburStatus(
            isModeMasuk: true,
            jamAbsen: widget.textJamAbsensi,
            shiftMasuk: checkin_onShift,
            shiftKeluar: checkOut_onShift);
        if (result != null) {
          note_status = result;
        }
      }
    }

    Map<String, dynamic> sampleData = {
      "attendance_date": attendndaceDateString,
      "check_in_actual": widget.textJamAbsensi,
      "attendance_address_in": widget.alamat,
      "attendance_location_in": widget.lat + ", " + widget.long,
      "attendance_type_in": "WFO",
      "check_in": widget.textJamAbsensi,
      "company_id": widget.user.company_id,
      "employee_id": widget.user.employee_id,
      "employee_name": widget.user.employee_name,
      "type_absensi": widget.type_absensi,
      // "note_status": note_status,
      "check_in_status": note_status,
      "is_uploaded": "0",
      "shift_id": widget.user.shift_id,
      "branch_status_id": branch_status_id,
      "attendance_location_id": attendance_location_id,
      "type_attendance": Tipe_absensi
    };
    Attendance dataAbsen = Attendance.fromMap(sampleData);

    // bool result = await InternetConnectionChecker().hasConnection;
    // if (result == true) {
    //    try {
    //   Response res =
    //       await repo.verifyAbsensi(dataAbsen, "checkin", widget.employee_id);
    //   if (res.statusCode == 200) {
    //     setState(() {
    //   buttonState = ButtonState.success;
    // });
    //   } else {
    //     showToast("tejadi kesalahan :" + res.statusMessage.toString());
    //   }
    // } catch (e) {}
    // } else {
    //   print('No internet :( Reason:');
    //   insertToLocalDB(dataAbsen);
    // }

    insertToLocalDB(dataAbsen);
  }

  Future<void> saveAbsenKeluar() async {
    intl.DateFormat dateFormat = intl.DateFormat('yyyy-MM-dd');

    // Format the DateTime object into a string

    if (widget.user.check_in != widget.user.check_out) {
      if (!isOvernight) {
        if (await pulangCepatChecker(widget.textJamAbsensi, checkOut_onShift)) {
          note_status = "PULANG CEPAT";
        }
      } else {
        String? result = checkLemburStatus(
            isModeMasuk: false,
            jamAbsen: widget.textJamAbsensi,
            shiftMasuk: checkin_onShift,
            shiftKeluar: checkOut_onShift);
        if (result != null) {
          note_status = result;
        }
      }
    }
    // String attendndaceDateString = dateFormat.format(widget.jamAbsensi);
    Map<String, dynamic> sampleData = {
      // "attendance_date": attendndaceDateString,
      "check_out_actual": widget.textJamAbsensi,
      "attendance_address_out": widget.alamat,
      "attendance_location_out": widget.lat + ", " + widget.long,
      "attendance_type_out": "WFO",
      "check_out": widget.textJamAbsensi,
      // ignore: equal_keys_in_map
      "check_out_actual": widget.textJamAbsensi,
      "company_id": widget.user.company_id,
      "employee_id": widget.user.employee_id,
      "employee_name": widget.user.employee_name,
      "type_absensi": widget.type_absensi,
      // "note_status": note_status,
      "check_out_status": note_status,
      "is_uploaded": "0",
      "shift_id": widget.user.shift_id,
      "branch_status_id": branch_status_id,
      "attendance_location_id": attendance_location_id,
      "type_attendance": Tipe_absensi
    };

    Attendance dataAbsen = Attendance.fromMap(sampleData);

    //     bool result = await InternetConnectionChecker().hasConnection;
    // if (result == true) {
    //    try {
    //   Response res =
    //       await repo.verifyAbsensi(dataAbsen, "checkout", widget.employee_id);
    //       print(jsonEncode(res.data));

    //   if (res.statusCode == 200) {
    //     setState(() {
    //   buttonState = ButtonState.success;

    // });
    //   } else {
    //     showToast("tejadi kesalahan :" + res.statusMessage.toString());
    //   }
    // } catch (e) {}
    // } else {
    //   print('No internet :( Reason:');
    //   insertToLocalDB(dataAbsen);
    // }

    insertToLocalDB(dataAbsen);

    // Response res =
    //     await repo.verifyAbsensi(dataAbsen, "checkout", _employee_id);
    // if (res.statusCode == 200) {
    //   showToast("sukses CheckOut");

    // } else {
    //   showToast("tejadi kesalahan :" + res.statusMessage.toString());
    // }
  }

  Widget buildCustomButton() {
    var progressbutt = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Idle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Uploading..",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Absensi Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Absensi Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.grey.shade400,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.orange,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: () {},
      state: buttonState,
    );
    return progressbutt;
  }

  Future<void> setTolerance() async {
    LoginModel user = await getUserLoginData();

    attendance_location_id = user.branch!.branchId;

    int toleranceHour = 0;
    print(toleranceHour * toleranceHour);
    try {
      toleranceHour =
          int.parse(user.branch?.tolerance ?? "0"); // contoh 1 = 1 jam
    } catch (e) {
      showToast(e.toString());
    }

    /// GET SHIFT BY RIG STATUS
    String checkin = widget.user.check_in!;
    String checkout = widget.user.check_out!;

    RigStatusShift? statusRig = await SpGetSelectedStatusRig();

    if (statusRig != null) {
      for (ShiftRig rigShift in statusRig.shift!) {
        if (rigShift.id == widget.user.shift_id) {
          checkin = rigShift.checkin!;
          checkin = rigShift.checkout!;
          break;
        }
      }
    }

    /// GET SHIFT BY RIG STATUS

    // String checkin = widget.user.check_in!;
    // String checkout = widget.user.check_out!;

    DateTime checkinDateTime = DateTime.parse("2024-01-01 " + checkin);
    DateTime checkoutDateTime = DateTime.parse("2024-01-01 " + checkout);

    // Mengurangi toleransi dari waktu checkin dan checkout
    DateTime checkOutOnShift =
        checkoutDateTime.subtract(Duration(hours: toleranceHour));
    DateTime checkinOnShift =
        checkinDateTime.subtract(Duration(hours: (toleranceHour *= -1)));

    // Mengonversi DateTime ke string dengan format "HH:mm"
    String checkOutOnShiftString = DateFormat('HH:mm').format(checkOutOnShift);
    String checkinOnShiftString = DateFormat('HH:mm').format(checkinOnShift);

    setState(() {
      checkOut_onShift = checkOutOnShiftString;
      checkin_onShift = checkinOnShiftString;
    });

    print("checkOut_onShift: $checkOutOnShiftString");
    print("checkin_onShift: $checkinOnShiftString");
  }

  insertToLocalDB(Attendance dataAbsen) async {
    DatabaseHelperAbsensi databaseHelperAbsensi =
        DatabaseHelperAbsensi.instance;
    String statusDb = await databaseHelperAbsensi.insertAttendance(dataAbsen,
        widget.type_absensi, isOvernight, widget.user.shift_id ?? "NO SHIFT");
    setState(() {
      if (statusDb == "SUCCESS") {
        if (note_status != null) {
          showToast(note_status!);
        }

        status = "SUKSES ABSEN " + widget.type_absensi;
        showJam = true;
      } else if (statusDb == "ALLREADY") {
        status = "ANDA SUDAH ABSEN " + widget.type_absensi;
        showJam = false;
      } else {
        status = statusDb;
      }
      status;
      // buttonState = ButtonState.fail;
      // info = "Data absensi dimasukan ke local DB";
    });
    startTimer();
  }
}
