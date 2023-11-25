import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/home_page.dart';
import 'package:face_net_authentication/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool('IS_LOGIN') ?? false;

   DeviceOrientation.portraitUp;
   
  bool is_landscape = prefs.getBool("LANDSCAPE_MODE") ?? false;

  if(is_landscape){
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
]);
  }else{
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
]);
  }


  getThreshold().then((value) {
    if(value == null){
      saveThreshold("0.8");
    }
  },);

  
  runApp(MyApp(isLoggedIn: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}
