import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/home_page.dart';
import 'package:face_net_authentication/pages/login.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  
  watchKioskMode().listen((mode) async {
    if (mode != KioskMode.enabled){
    // await startKioskMode();
    }
  });
  await setDeviceOrientationByDevice();


  setupServices();

  // GlobalRepo repo= GlobalRepo();
  // List<MasterBranches?> branches = await repo.hitGetMasterBranches();
  // log(jsonEncode(branches));



  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool('IS_LOGIN') ?? false;
  getThreshold().then(
    (value) {
      if (value == null) {
        saveThreshold(CONSTANT_VAR.DEFAULT_TRESHOLD.toString());
      }
    },
  );

  runApp(MyApp(isLoggedIn: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  
  

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {

    
   
    return MaterialApp(
      
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: isLoggedIn ? HomePage() : LoginPage(),

      
      // builder: EasyLoading.init(),

    );
  }
}
