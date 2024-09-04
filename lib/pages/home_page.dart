import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/pages/Dinas%20Khusus/DK_page.dart';
import 'package:face_net_authentication/pages/List%20Karyawan/page_list_karyawan.dart';
import 'package:face_net_authentication/pages/Rig%20Status%20History/rigStatusHistory.dart';
import 'package:face_net_authentication/pages/history_absensi_mainPage.dart';
import 'package:face_net_authentication/pages/menu_admin.dart';
import 'package:face_net_authentication/pages/register_pin.dart';
import 'package:face_net_authentication/pages/relief/relief_page.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/pages/widgets/home_menu.dart';
import 'package:face_net_authentication/pages/widgets/home_wiget.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/pages/widgets/user-banner.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:face_net_authentication/services/location_service_helper.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';

import 'db/dbSync.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  int? waitingApproval = 0;

  double _progress = 0.0;
  String _progressMessage = "Initializing...";
  bool _loading_init = true;
  int itemPerRow = 3;

  @override
  void initState() {
    super.initState();
    // initFirebase();

    //GET MASTER DATA FOR REGIST FORM
    // GlobalRepo().getMasterRegister();
    GlobalRepo().hitApiGetMsterShift();
    GlobalRepo().hitAllMasterRigStatus(context);

    // initLocation();
    syncAllData();

    getPIN().then((value) {
      setState(() {
        if (value == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPin(),
              ));
        }
      });
    });

    // AuthModel repo = AuthModel();
    // repo.login(context, GlobalKey(), "110796", "123123", false);

    initializeDateFormatting('id');
    // initLocalNotification();
    // initFirebaseMessaging();

    if (CONSTANT_VAR.EMULATOR_MODE) {
      _loading_init = false;
    } else {
      _initializeServices();
    }

    GlobalRepo().getLatestVersion(context);
    // initLocation();

    // GlobalRepo().hitAllMasterRigStatus(context);
  }

  initLocation() async {
    if (await onLineChecker()) {
      GET_LOCATION(context);
    }
  }

  // Future<void> initFirebase() async {
  //   LoginModel user = await getUserLoginData();
  //   FirebaseCrashlytics.instance.setUserIdentifier(
  //       (user.branch?.branchName ?? "-") +
  //           "|" +
  //           (user.branch?.branchId ?? "-"));
  // }

  syncAllData() {
    dBsync().syncAllDB();
  }

  // _initializeServices() async {

  //   await _mlService.initialize();
  //   await _cameraService.initialize();
  //   _mlKitService.initialize();
  // }

  _initializeServices() async {
    try {
      // Simulate initialization for demonstration purposes
      await Future.delayed(Duration(seconds: 1));

      _updateProgress(0.33, "Initializing Face Engine...");
      await _mlService.initialize();

      await Future.delayed(Duration(seconds: 1));
      _updateProgress(0.67, "Initializing Camera Service...");
      await _cameraService.initialize();

      await Future.delayed(Duration(seconds: 1));
      _updateProgress(0.80, "Initializing Face Engine...");

      // All services initialized successfully

      _mlKitService.initialize();
      _updateProgress(1.0, "Initialization complete");

      setState(() {
        _loading_init = false;
      });
    } catch (e) {
      // An error occurred during initialization

      _progressMessage = "Error Inisialisasi Face Recognition";
    }
  }

  _updateProgress(double progress, String message) {
    setState(() {
      _progress = progress;
      _progressMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    _setItemPerRow();
    if (_loading_init) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/gear.json',
                width: 400,
                height: 400,
                fit: BoxFit.fill,
              ),
              Text(_progressMessage),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 295,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 360 * 160,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: AssetImage("assets/images/gedung_bukopin.jpg"),
                          //     fit: BoxFit.cover,
                          //     alignment: Alignment.topCenter
                          // ),
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                              Color.fromRGBO(0, 113, 182, 1),
                              Color.fromRGBO(0, 113, 182, .9),
                              Color.fromRGBO(0, 113, 182, .8),
                            ])),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 70.0),
                            ),
                            //ADZIEHRDY
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: UserBanner(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  new HomeWiget(),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height -
                    295, // Untuk menyesuaikan tinggi GridView
                child: GridView.count(
                  crossAxisCount: itemPerRow,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                  padding: EdgeInsets.all(13),
                  children: <Widget>[
                    new HomeMenu(
                      "Absen Masuk",
                      "assets/images/absent_in.png",
                      -1,
                      callback: (p0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignIn(MODE: "MASUK")));
                      },
                    ),
                    new HomeMenu(
                      "Absen Keluar",
                      "assets/images/absent_out_menu.png",
                      -1,
                      callback: (p0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignIn(MODE: "KELUAR")));
                      },
                    ),
                    new HomeMenu(
                      "History Absensi",
                      "assets/images/absent_shift.png",
                      waitingApproval!,
                      callback: (p0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryAbsensiMainPage()));
                      },
                    ),
                    // new HomeMenu(
                    //   "Daftar Karyawan",
                    //   "assets/images/absent_personal.png",
                    //   -1,
                    //   callback: (p0) {
                    //     PinInputDialog.show(context, (p0) {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => PageListKaryawan()));
                    //     });
                    //   },
                    // ),

                    new HomeMenu(
                      "Menu Admin",
                      "assets/images/admin_menu.png",
                      -1,
                      callback: (p0) {
                        PinInputDialog.show(context, (p0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MenuAdmin()));
                        });
                      },
                    ),

                    // new HomeMenu(
                    //   "Rig Status History",
                    //   "assets/images/absent_personal.png",
                    //   -1,
                    //   callback: (p0) {
                    //     PinInputDialog.show(context, (p0) {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => rigStatusHistory()));
                    //     });
                    //   },
                    // ),

                    // new HomeMenu(
                    //   "Approval",
                    //   "assets/images/absent_approval.png",
                    //   waitingApproval!,
                    //   callback: (p0) {
                    //     PinInputDialog.show(context, (p0) {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => approval_main_page()));
                    //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
                    //     });
                    //   },
                    // ),

                    // new HomeMenu(
                    //   "Relief",
                    //   "assets/images/absent_approval.png",
                    //   waitingApproval!,
                    //   callback: (p0) {
                    //     PinInputDialog.show(context, (p0) {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => ReliefPage()));
                    //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
                    //     });
                    //   },
                    // ),

                    // new HomeMenu(
                    //   "Dinas Khusus",
                    //   "assets/images/absent_approval.png",
                    //   waitingApproval!,
                    //   callback: (p0) {
                    //     Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context) => DKPage()));
                    //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
                    //   },
                    // ),

                    // new HomeMenu(
                    //   "Testing Button",
                    //   "assets/images/absent_register.png",
                    //   -1,
                    //   callback: (p0) async {
                    //     // Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => ForceUpgrade(isLoged: true,currentVersion: "1.0.0",latestVersion: "1.0.0",)));
                    //     bool? granted = await showLocationPermissionDialog(context);
                    //   },
                    // ),

                    // new HomeMenu("Shift", "assets/images/absent_shift.png",-1, callback: (p0) {
                    //   Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => ScheduleListPage()));
                    //   },
                    // ),

                    //   buildMenuCard(MdiIcons.accountArrowLeft, "ABSEN", "MASUK", (){
                    //     showAlert(
                    //         context: context,
                    //         body: "Apakah anda berada di lokasi kantor?",
                    //         actions: [
                    //           AlertAction(text: 'IYA', onPressed: () => Navigator.of(context).push(
                    //               MaterialPageRoute(builder: (context) => WFOPage(WFOPageType.WFO))
                    //           )),
                    //           AlertAction(text: 'TIDAK', onPressed: () => Navigator.of(context).push(
                    //               MaterialPageRoute(builder: (context) => WFHPage(WFHPageType.WOO))
                    //           ))
                    //         ]
                    //     );
                    //   }),
                    //   /*buildMenuCard(MdiIcons.toolboxOutline, "WORK", "OUT OF OFFICE", ()=>Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => WFHPage(WFHPageType.WOO))
                    // )),*/
                    //   buildMenuCard(MdiIcons.accountArrowRight, "ABSEN", "KELUAR", () => Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => WFHPage(WFHPageType.WFH))
                    //   )),
                    //   buildMenuCard(MdiIcons.accountDetailsOutline, "ABSENSI", "PERSONAL", ()=> Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => AbsenceListPage())
                    //   )),
                    //   //buildMenuCard(MdiIcons.accountGroupOutline, "ABSENSI", "KARYAWAN", (){}),
                    //   buildMenuCardWithBadge(MdiIcons.clipboardCheckMultipleOutline, "APPROVAL", "ABSENSI", () async{
                    //     await Navigator.of(context).push(
                    //         MaterialPageRoute(builder: (context) => ApprovalListPage())
                    //     );
                    //     countWaiting();
                    //   }, waitingApproval!),
                    //   buildMenuCard(MdiIcons.faceRecognition  , "DAFTAR", "WAJAH", ()=> Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => AbsenceListPage())
                    //   )),
                    //   buildMenuCard(MdiIcons.timetable  , "JADWAL", "SHIFT", ()=> Navigator.of(context).push(
                    //       MaterialPageRoute(builder: (context) => ScheduleListPage())
                    //   )),
                    // buildMenuCard(MdiIcons.playlistEdit, "WORKING", "REPORT",()=>Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => WorkListPage())
                    // )),
                    // buildMenuCard(MdiIcons.googleClassroom, "MEETING", " ", ()=>Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => MeetingPage())
                    // )),
                  ],
                ))
          ],
        ),
      ));
    }
  }

  Padding buildMenuCard(
      IconData icon, String text1, String text2, Function onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 113, 184, 1),
                  Color.fromRGBO(0, 113, 184, .8)
                ], stops: [
                  0.1,
                  0.7
                ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(icon, color: Colors.white, size: 25),
                  ),
                  Text(text1,
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                  text2 == null
                      ? Container()
                      : Text(text2,
                          style: TextStyle(fontSize: 10, color: Colors.white))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildMenuCardWithBadge(IconData icon, String text1, String text2,
      Function onTap, int badgeCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: onTap as void Function()?,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 113, 184, 1),
                    Color.fromRGBO(0, 113, 184, .8)
                  ], stops: [
                    0.1,
                    0.7
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    Text(text1,
                        style: TextStyle(color: Colors.white, fontSize: 10)),
                    text2 == null
                        ? Container()
                        : Text(text2,
                            style: TextStyle(fontSize: 10, color: Colors.white))
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _setItemPerRow() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      setState(() {
        itemPerRow =
            5; // Mengatur nilai itemPerRow jika orientasi adalah landscape
      });
    } else {
      setState(() {
        itemPerRow =
            3; // Mengatur nilai itemPerRow jika orientasi adalah portrait (opsional)
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
