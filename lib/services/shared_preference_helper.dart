import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> initSP() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

SpSetLastLoc(double lat, double long, String loc) async {
  SharedPreferences sp = await initSP();
  await sp.setDouble("LAT", lat);
  await sp.setDouble("LONG", long);
  await sp.setString("LOC", loc);
}

SpSetStatusRig(String status) async {
  SharedPreferences sp = await initSP();
  await sp.setString("RIG_STATUS", status);
}

Future<String> SpGetStatusRig() async {
  SharedPreferences sp = await initSP();
 String RIG_STATUS = await sp.getString("RIG_STATUS") ?? "-";
 return RIG_STATUS;
}

Future<double> SpGetLastLat() async {
  SharedPreferences sp = await initSP();

  double? lat = await sp.getDouble("LAT");

  if (lat != null) {
    return lat;
  } else {
    LoginModel data = await getUserLoginData();

    return convertLatLongString(data.branch!.branchLocation!, true);
  }
}

Future<double> SpGetLastlong() async {
  SharedPreferences sp = await initSP();

  double? long = await sp.getDouble("LONG");

  if (long != null) {
    return long;
  } else {
    LoginModel data = await getUserLoginData();

    return convertLatLongString(data.branch!.branchLocation!, false);
  }
}


Future<String> SpGetLastLatlong() async {
  double lat = await SpGetLastLat();
   double long = await SpGetLastlong();

   return lat.toString()+" , "+long.toString();

}

Future<String> SpGetLastAlamat() async {
  SharedPreferences sp = await initSP();
  

  String? alamat =  await sp.getString("LOC");

  if(alamat != null){
    return alamat;
  }else{
    LoginModel data = await getUserLoginData();
    return data.branch!.branchName!;
  }

  

}

double convertLatLongString(String coordinates, bool isGetLat) {
  List<String> parts = coordinates.split(',');

  if (isGetLat) {
    return double.parse(
        parts[0]); // Mengonversi bagian pertama menjadi double (latitude)
  } else {
    return double.parse(
        parts[1]); // Mengonversi bagian kedua menjadi double (longitude)
  }
}

