import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/pages/setting_page.dart';
import 'package:face_net_authentication/pages/switch_supper_attendance.dart';
import 'package:face_net_authentication/pages/widgets/dialog_change_rig_status.dart';
import 'package:face_net_authentication/pages/widgets/dialog_rig_info.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';

class UserBanner extends StatefulWidget {
  const UserBanner({Key? key}) : super(key: key);

  @override
  _UserBannerState createState() => _UserBannerState();
}

class _UserBannerState extends State<UserBanner> {
  LoginModel? userInfo;
  String activeSuperAttendace = "-";
  BranchStatus? status_rig;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    userInfo = await getUserLoginData();
    status_rig = await SpGetSelectedStatusRig();

    activeSuperAttendace = await getActiveSuperIntendentName();

    // Memanggil setState untuk memicu pembaruan UI setelah mendapatkan data.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      // Tampilkan widget loading atau indikator lainnya jika data belum tersedia.
      return CircularProgressIndicator();
    } else
      // AuthModel model = Provider.of<AuthModel>(context);
      return Padding(
        padding: EdgeInsets.only(left: 16, bottom: 14, right: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 42,
                width: 42,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                    // child: Container(
                    //   height: 40,
                    //   width: 40,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //       image: model.user!.profileImage!,
                    //       fit: BoxFit.cover
                    //     )
                    //   ),
                    // ),
                    ),
              ),
            ),
            Expanded(
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SwitchSupperAttendance())),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                activeSuperAttendace.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                userInfo!.branch!.branchName ?? " ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "STATUS RIG :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontStyle: FontStyle.italic,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Text(
                                            (status_rig?.statusBranch ?? "-"),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return dialog_change_rig_status();
                                      },
                                    );
                                    status_rig = await SpGetSelectedStatusRig();
                                    setState(() {
                                      status_rig;
                                    });
                                  },
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialog_rig_info();
                              },
                            );
                          },
                          icon: Icon(
                            Icons.info,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            PinInputDialog.show(
                              context,
                              (p0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingPage(),
                                    ));
                              },
                            );
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi Logout'),
                                  content:
                                      Text('Apakah Anda yakin ingin logout?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                      },
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        logout(context);
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          )),
                    ],
                  )
                ])),
          ],
        ),
      );
  }
}
