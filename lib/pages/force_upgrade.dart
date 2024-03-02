import 'dart:io';

import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/pages/history_absensi_mainPage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpgrade extends StatefulWidget {
  const ForceUpgrade({Key? key, required this.isLoged, required this.currentVersion, required this.latestVersion}) : super(key: key);

  @override
  _ForceUpgradeState createState() => _ForceUpgradeState();

  final bool isLoged;
  final String currentVersion;
  final String latestVersion;
}

class _ForceUpgradeState extends State<ForceUpgrade> {

Future<void> _launchUrl() async {
  late Uri _url ;
  if(Platform.isAndroid){
    _url = Uri.parse(CONSTANT_VAR.PLAYSTORE_URL);
  }else{
     _url = Uri.parse(CONSTANT_VAR.PLAYSTORE_URL);
  }
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: 
      Container(
        
        child: 
        SingleChildScrollView(child: Center(
          child: 
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15),
                Lottie.asset(
                  'assets/lottie/force_upgrade.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fill,
                ),
                Text(
                  'Aplikasi Perlu Di Upgrade',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Aplikasi yang terinstall terlalu usang ( v.'+widget.currentVersion+' ), mohon untuk upgrade aplikasi agar bisa digunakan kembali',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                SizedBox(height: 15),
                Visibility(
                  visible: widget.isLoged,
                    child: Column(
                  children: [
                    Text(
                      'Pastikan data History Absensi di upload terlebih dahulu sebelum upgrade agar data sebelumnya tidak terhapus.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: () {
                         
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryAbsensiMainPage(),));
                        

                        },
                        child: Text("Lihat History Absensi"))
                  ],
                )),
                SizedBox(height: 15),
                ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      _launchUrl();
                    },
                    child: Text("UPGRADE KE V."+widget.latestVersion))
              ],
            ),
          ),
        ),)
      ),
    );
    
  }


}
