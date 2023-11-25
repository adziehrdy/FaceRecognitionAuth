import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/models/login_model.dart';
import 'package:face_net_authentication/pages/setting_page.dart';
import 'package:face_net_authentication/pages/switch_supper_attendance.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:flutter/material.dart';

class UserBanner extends StatefulWidget {
  const UserBanner({ Key? key }) : super(key: key);

  @override
  _UserBannerState createState() => _UserBannerState();


}

class _UserBannerState extends State<UserBanner> {
  LoginModel? userInfo;
  String activeSuperAttendace = "-";

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadUserInfo();


  }

    Future<void> _loadUserInfo() async {
    userInfo = await getUserLoginData();
    activeSuperAttendace = await getActiveSuperIntendentName();

    // Memanggil setState untuk memicu pembaruan UI setelah mendapatkan data.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

     if (userInfo == null) {
      // Tampilkan widget loading atau indikator lainnya jika data belum tersedia.
      return CircularProgressIndicator();
    }else
    // AuthModel model = Provider.of<AuthModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 14, right: 20),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SwitchSupperAttendance())
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(activeSuperAttendace.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),),
                    Text(userInfo!.branch!.branchName ?? " ", style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic,overflow: TextOverflow.ellipsis),),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                IconButton(onPressed: () {
                                                PinInputDialog.show(context, (p0) {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage(),));
                              },);
                  
                }, icon: Icon(Icons.settings)),
                IconButton(onPressed: () {
                  logout(context);
                }, icon: Icon(Icons.exit_to_app)),
              ],
            )
          ],
        ),
      ),
    );
  }
}