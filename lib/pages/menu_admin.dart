import 'package:face_net_authentication/pages/Rig%20Status%20History/rigStatusHistory.dart';
import 'package:face_net_authentication/pages/history_absensi_mainPage.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/pages/widgets/home_menu.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:flutter/material.dart';

import 'Dinas Khusus/DK_page.dart';
import 'List Karyawan/page_list_karyawan.dart';
import 'relief/relief_page.dart';

class MenuAdmin extends StatefulWidget {
  const MenuAdmin({Key? key}) : super(key: key);

  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  int? waitingApproval = 0;
  int itemPerRow = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu Admin"),
        ),
        body: Container(
            child: GridView.count(
          crossAxisCount: itemPerRow,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          padding: EdgeInsets.all(13),
          children: <Widget>[
            //
            // new HomeMenu(
            //   "History Absensi",
            //   "assets/images/absent_shift.png",
            //   waitingApproval!,
            //   callback: (p0) {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => HistoryAbsensiMainPage()));
            //   },
            // ),
            new HomeMenu(
              "Daftar Karyawan",
              "assets/images/absent_personal.png",
              -1,
              callback: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PageListKaryawan()));
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

            new HomeMenu(
              "Relief",
              "assets/images/relief.png",
              waitingApproval!,
              callback: (p0) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReliefPage()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
                ;
              },
            ),

            new HomeMenu(
              "Dinas Khusus",
              "assets/images/DK.png",
              waitingApproval!,
              callback: (p0) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DKPage()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
              },
            ),

            new HomeMenu(
              "Rig Status History",
              "assets/images/rig_history.png",
              waitingApproval!,
              callback: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RigStatusHistory()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
              },
            ),

            new HomeMenu(
              "Catering",
              "assets/images/food.png",
              waitingApproval!,
              callback: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RigStatusHistory()));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPin()));
              },
            ),

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
        )));
  }
}
