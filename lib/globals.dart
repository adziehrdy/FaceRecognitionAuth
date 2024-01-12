import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/pages/force_upgrade.dart';
import 'package:face_net_authentication/pages/login.dart';
import 'package:face_net_authentication/pages/models/login_model.dart';
import 'package:face_net_authentication/pages/models/model_master_shift.dart';
import 'package:face_net_authentication/repo/custom_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart' as imglib;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_location/trust_location.dart';
import 'package:unique_identifier/unique_identifier.dart';

String? endpointUrl;
late String publicUrl;
bool bypass_office_location_range = false;
// StreamSubscription<LocationData>? locationStream;

String token = "";

void showToast(String msg){
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
}

void showToastShort(String msg){
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
}

getCurrentLocation() async {
LatLongPosition? position;
  
TrustLocation.start(5);

/// the stream getter where others can listen to.
TrustLocation.onChange.listen((values) =>
position = values
    // print('${values.latitude} ${values.longitude} ${values.isMockLocation}')
);

print(position?.latitude.toString() ?? "0");
return position;
}

  

enum ApiMethods {
  GET,
  POST
}

Future<bool?> showAlert({
  required BuildContext context,
  String? body,
  List<DialogButton>? actions,
  String? title,
}) {
  return Alert(
    context: context,
    title: title,
    desc: body,
    buttons: actions,
  ).show();
}

class RaisedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final ButtonStyle? style;
  final Clip? clipBehavior;
  final Color? color;

  const RaisedButton({
    Key? key,
    this.onPressed,
    this.child,
    this.style,
    this.clipBehavior,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.blue;

    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: style?.copyWith(backgroundColor: MaterialStateProperty.all<Color>(primaryColor)),
      clipBehavior: clipBehavior!,
    );
  }
}

BaseOptions options = BaseOptions(
  baseUrl: endpointUrl!,
);
Dio dio = Dio(options);

// Future<void> getEndpointURL() async {
//   if (endpointUrl == null) {
//     if (kReleaseMode) {
//       endpointUrl = COSTANT_VAR.BASE_URL_API;
//       publicUrl = COSTANT_VAR.BASE_URL_PUBLIC;
//     } else {
//       endpointUrl = COSTANT_VAR.BASE_URL_API;
//       publicUrl = COSTANT_VAR.BASE_URL_PUBLIC;
//     }

//     print(endpointUrl);
//   }
// }

// Future<Response> callApi(ApiMethods method, String url, {Map<String, dynamic>? data}) async {
//   await getEndpointURL();

//   Map<String, dynamic> headers;

//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString("TOKEN");

//   if (token != null) {
//     headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//     var test = url.split('?');
//     if (test.length > 1) {
//       url = test[0] + '?token=$token&' + test[1];
//     } else {
//       url = url + "?token=$token";
//     }
//   } else {
//     headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//   }

//   dio.options.headers = headers;

//   if (method == ApiMethods.GET) {
//     return dio.get(url);
//   } else if (method == ApiMethods.POST) {
//     return dio.post(
//       url,
//       data: data != null ? json.encode(data) : "",
//     );
//   }
// }

Future<Response<dynamic>> callApi(ApiMethods method, String url, {Map<String, dynamic>? data}) async {

  final dio = Dio();

  try {
    // await getEndpointURL();
    url = COSTANT_VAR.BASE_URL_API + "" + url;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await getUserLoginData().then((value) => token = value.accessToken!);

    

    // print("PAYLOAD = "+jsonEncode(data));
    log("PAYLOAD = "+jsonEncode(data));
    

    Map<String, dynamic> headers;


    print("HITTED ENDPOINT - "+url);

    if (token != null) {
      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      var test = url.split('?');
      if (test.length > 1) {
        url = test[0] + '?token=$token&' + test[1];
      } else {
        url = url + "?token=$token";
      }
    } else {
      headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    dio.options.headers = headers;

    print(url);

    if (method == ApiMethods.GET) {
      return await dio.get(url);
    } else if (method == ApiMethods.POST) {
      String jsonSting = jsonEncode(data);
      print(jsonSting);
      return await dio.post(
        url,
        data: data != null ? json.encode(data) : "",
      );
    }
    
  } catch (error) {
    print(error.toString());
    if (error is DioException){
     if (error.response!.statusCode == 400 || error.response!.statusCode == 500) {
      print(error.response!.data['message']);
       showToast(error.response!.data['message']);
    }else{
      
      showToast(error.response?.statusMessage.toString() ?? "Error");
    }
    }

    
    rethrow; // Re-throw the error after handling it
  }

  throw Exception("Invalid API method");
}


Future<Response<dynamic>> callApiWithoutToken(ApiMethods method, String url, {Map<String, dynamic>? data}) async {
  final dio = Dio();

  try {

      // await getEndpointURL();



    Map<String, dynamic> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    url = COSTANT_VAR.BASE_URL_API + "" + url;

    print(url);
    
    dio.options.headers = headers;

    if (method == ApiMethods.GET) {
      return await dio.get(url);
    } else if (method == ApiMethods.POST) {
      String jsonString = jsonEncode(data);
      print(jsonString);
      return await dio.post(
        url,
        data: data != null ? json.encode(data) : "",
      );
    }
  } catch (error) {
    print(error.toString());
    if (error is DioError) {
      if (error.response != null) {
        if (error.response!.statusCode == 400 || error.response!.statusCode == 500) {
          
          showToast(error.response!.data['message']);
          print(error.response!.data['message']);
        } else {
          showToast(error.response!.statusMessage.toString() ?? "Error");
           print(error.response!.statusMessage.toString() ?? "Error");
        }
      } else {
        showToast(error.response.toString());
      }
    }
    
    rethrow; // Re-throw the error after handling it
  }

  throw Exception("Invalid API method");
}




void handleError(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, Object ex) {
  if (scaffoldKey == null) {
    if (ex != null) {
      showAlert(
        context: context,
        title: 'Error',
        body: ex.toString(),
      );
      return;
    }
  } else {
    if (ex != null) {
      if (ex is DioException) {
        if (ex.response!.statusCode == 401) {
          Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
        } else if (ex.response!.statusCode == 400 || ex.response!.statusCode == 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ex.response!.data['message']), duration: Duration(milliseconds: 2500)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ex.response!.statusMessage!), duration: Duration(milliseconds: 2500)),
          );
        }
      } else if (ex is CustomException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ex.cause), duration: Duration(milliseconds: 2500)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ex.toString()), duration: Duration(milliseconds: 2500)),
        );
      }
      return;
    }
  }
}

class AlertAction extends DialogButton {
  AlertAction({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Text(text),
          onPressed: onPressed,
        );
}

class TimeModel extends ChangeNotifier {
  String _currentTime = '';

  String get currentTime => _currentTime;

  void updateTime() {
    _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    notifyListeners();
  }
}



// class LocationDisplayWidget extends StatefulWidget {
//   @override
//   _LocationDisplayWidgetState createState() => _LocationDisplayWidgetState();
// }

// class _LocationDisplayWidgetState extends State<LocationDisplayWidget> {
//   String latLongText = "Fetching location...";

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _getCurrentLocation() async {
//     try {
//       LatLongPosition latLongPosition = await getCurrentLocation();
//       setState(() {
//         latLongText =
//             "Latitude: ${latLongPosition.latitude.toString()}, Longitude: ${latLongPosition.longitude.toString()}";
//       });
//     } catch (e) {
//       setState(() {
//         latLongText = "Error fetching location";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       latLongText,
//       style: TextStyle(fontSize: 16),
//     );
//   }
// }

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}



String formatDate(DateTime dateTime) {
  DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  return formatter.format(dateTime);
}

String formatDateRegisterForm(DateTime dateTime) {
  DateFormat formatter = DateFormat("dd-MM-yyyy");
  return formatter.format(dateTime);
}

  String uint8listToString(Uint8List uint8listData) {
    return base64.encode(uint8listData);
  }

  Uint8List stringToUint8list(String stringData) {
    return base64.decode(stringData);
  }

  Future<LoginModel> getUserLoginData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String JsonData = await prefs.getString("LOGIN_DATA")!;
      LoginModel data = LoginModel.fromMap(json.decode(JsonData));
      
      return data;
      
    
  }

  Future<void> logout(context)async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
      
}


String encode_FR_ToBase64(dynamic data) {
  String encodedData = base64Encode(utf8.encode(jsonEncode(data)));
  return encodedData;
}


List<dynamic> decode_FR_FromBase64(String encodedData) {
  List<int> byteData = base64Decode(encodedData);
  String jsonString = utf8.decode(byteData);
  dynamic decodedData = jsonDecode(jsonString);
  return decodedData;
}

Future<void> savePIN(String pin) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   int active_super_attendance = prefs.getInt("ACTIVE_SUPER_ATTENDANCE") ?? 0;
   prefs.setString("PIN_"+active_super_attendance.toString(), pin);
}

Future<String?> getPIN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int active_super_attendance = prefs.getInt("ACTIVE_SUPER_ATTENDANCE") ?? 0;
   return prefs.getString("PIN_"+active_super_attendance.toString());
}

Future<void> checkIsNeedForceUpgrade(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? latestVersion = await prefs.getString("LATEST_VERSION");

      PackageInfo info = await PackageInfo.fromPlatform();

    
  String currentVersion = info.version;

  if(latestVersion != null){
    List<String> latestParts = latestVersion.split('.');
  List<String> currentParts = currentVersion.split('.');

  // Menentukan panjang maksimum dari kedua versi
  int maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;

  for (int i = 0; i < maxLength; i++) {
    int latest = i < latestParts.length ? int.parse(latestParts[i]) : 0;
    int current = i < currentParts.length ? int.parse(currentParts[i]) : 0;

    if (latest > current) {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForceUpgrade(isLoged: true,currentVersion: currentVersion,latestVersion: latestVersion),));
     
    } else if (latest < current) {
      
    }
    // Jika kedua versi sama pada bagian ini, lanjutkan perbandingan untuk bagian berikutnya
  }
  }
  
}

Future<List<int>> convertXFIleToImage(XFile file) async {
  // String path = file.path;
  // final bytes = await File(path).readAsBytes();
  // final img.Image? image = img.decodeImage(bytes);
  // return image;

  final bytes = await file.readAsBytes();
      img.Image image = img.decodeImage(bytes.toList())!;
      List<int> jpg = img.encodeJpg(image);
      return jpg;
}

Future<String> imageToBase64(List<int> file) async {
  return base64Encode(file);
}

Uint8List decodeToBase64ToImage(String input) {
    return base64Decode(input);
  }

    Future<double?>  getThreshold() async {
    double? threshold;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    threshold = await prefs.getDouble("threshold") ?? null;

    return threshold;
  }

    saveThreshold(String tresh) async {
    double newThreshold = double.parse(tresh);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('threshold', newThreshold);
  }

   bool terlambatChecker(String jamMasuk, String jamShift) {
    // Memisahkan tanggal dan waktu pada time1
    List<String> splitTime1 = jamMasuk.split(' ');
    // Menggabungkan waktu dari time1 dengan tanggal dari time2
    String combinedTime = "${splitTime1[0]} $jamShift";

    // Konversi string waktu menjadi objek DateTime
    DateTime dateTime1 = DateTime.parse(combinedTime);
    DateTime dateTime2 = DateTime.parse(jamMasuk);

    // Bandingkan waktu
    if (dateTime2.isAfter(dateTime1)) {
      return true;
    } else {
      return false;
    }
  }

     bool pulangCepatChecker(String jamKeluar, String jamShift) {
    // Memisahkan tanggal dan waktu pada time1
    List<String> splitTime1 = jamKeluar.split(' ');
    // Menggabungkan waktu dari time1 dengan tanggal dari time2
    String combinedTime = "${splitTime1[0]} $jamShift";

    // Konversi string waktu menjadi objek DateTime
    DateTime dateTime1 = DateTime.parse(combinedTime);
    DateTime dateTime2 = DateTime.parse(jamKeluar);

    // Bandingkan waktu
    if (dateTime2.isBefore(dateTime1)) {
      return true;
    } else {
      return false;
    }
  }


String? checkLemburStatus({
  required bool isModeMasuk,
  required String jamAbsen,
  required String shiftMasuk,
  required String shiftKeluar,
}) {

  DateTime dateTime = DateTime.parse(jamAbsen);
  String timeOnly = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

try{
  final DateTime jamAbsenDT = DateTime.parse("2024-01-02 $timeOnly");
  final DateTime shiftKeluarDT = DateTime.parse("2024-01-03 $shiftKeluar");
  final DateTime shiftMasukDT = DateTime.parse("2024-01-01 $shiftMasuk");
  

  


  if (isModeMasuk) {
    if (jamAbsenDT.isAfter(shiftMasukDT)) {
      return "TERLAMBAT";
    } else if (jamAbsenDT.isBefore(shiftMasukDT) || jamAbsenDT.isAtSameMomentAs(shiftMasukDT)) {
      return null;
    }
  } else {
    if (jamAbsenDT.isBefore(shiftKeluarDT)) {
      return "PULANG CEPAT";
    } else if (jamAbsenDT.isAfter(shiftKeluarDT) || jamAbsenDT.isAtSameMomentAs(shiftKeluarDT)) {
      return null;
    }
  }
  }catch (e){
  print(e);
}

  return "UNKNOW";
}

  Uint8List convertImagelibToUint8List(imglib.Image? image) {
  // Konversi imglib.Image menjadi format PNG
  imglib.PngEncoder pngEncoder = imglib.PngEncoder();
  List<int> png = pngEncoder.encodeImage(image!);

  // Konversi List<int> menjadi Uint8List
  Uint8List uint8list = Uint8List.fromList(png);
  return uint8list;
}

String convertImagelibToBase64JPG(imglib.Image image) {
  // Konversi imglib.Image menjadi format JPEG
  imglib.JpegEncoder jpegEncoder = imglib.JpegEncoder();
  List<int> jpg = jpegEncoder.encodeImage(image);

  // Konversi List<int> menjadi Uint8List
  Uint8List uint8list = Uint8List.fromList(jpg);

  // Encode Uint8List menjadi string base64
  String base64String = base64Encode(uint8list);
  return base64String;
}


Future<void> setActiveSuperIntendent(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("ACTIVE_SUPER_ATTENDANCE", index);
}

Future<int> getActiveSuperIntendent(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("ACTIVE_SUPER_ATTENDANCE") ?? 0;
}

Future<String> getActiveSuperIntendentName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int sa_index = prefs.getInt("ACTIVE_SUPER_ATTENDANCE") ?? 0;
    LoginModel user = await getUserLoginData();
    return user.superAttendence[sa_index].name;
}

Future<String> getActiveSuperIntendentID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int sa_index = prefs.getInt("ACTIVE_SUPER_ATTENDANCE") ?? 0;
    LoginModel user = await getUserLoginData();
    return user.superAttendence[sa_index].id;
}

Future<String> getBranchID() async {
    LoginModel user = await getUserLoginData();
    return user.branch!.branchId;
}

bool checkShiftIsOvernight(String checkin, String checkout) {
  // Mengonversi string menjadi waktu dalam format DateTime
  DateTime checkinTime = DateTime.parse("2023-01-01 " + checkin);
  DateTime checkoutTime = DateTime.parse("2023-01-01 " + checkout);

  // Jika jam checkin lebih besar dari jam checkout, itu artinya overnight
  if (checkinTime.isAfter(checkoutTime)) {
    return true;
  } else {
    return false;
  }
}

//  Future<String> getDeviceId() async {

//   if(!COSTANT_VAR.EMULATOR_MODE){

  
//     DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//     if(Platform.isAndroid){
//       AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
//       return info.id;
//     } else if(Platform.isIOS){
//       IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
//       return info.identifierForVendor ?? "IOS";
//     }
//     else{
//       return ("cant find device id");
//     }
//   }else{
//  return "f9fccbf3a669cab4";
//   }

//     // BYPASS DEVICE ID

   
//   }


Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Platform.isAndroid) {
    deviceId = await UniqueIdentifier.serial;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor; // Gunakan salah satu ID yang tersedia
  }
  if(deviceId != null){
    return deviceId;
  }else{
    return "UNABLE TO GET DEVICE ID";
  }
  
}


Future<void> setDeviceOrientationByDevice() async {
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String? deviceType;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceType =  androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceType = iosInfo.identifierForVendor;
}

print(deviceType);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(deviceType == "TP1A.220624.014"){
    await prefs.setBool("LANDSCAPE_MODE",true);
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
]);
  }else{
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
]);
  }
}


    Widget checkFrPhoto(String? file){

      if(file == null){
        return Image.asset("assets/images/blank-profile-pic.png");
      }else{
            try{
      return Image.memory(
            decodeToBase64ToImage(file!),

            fit: BoxFit.cover, // Sesuaikan sesuai kebutuhan Anda
          );
    }catch(e){
      return Image.network(COSTANT_VAR.BASE_URL_PUBLIC + file!);
    }
      }
  }

  Future<List<ShiftData>> getMasterShift() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? stringMastershift = prefs.getString("MASTER_SHIFT");
    if(stringMastershift != null){
      model_master_shift shift = model_master_shift.fromJson(jsonDecode(stringMastershift));
      return shift.data;
    }else{
      return [];
    }

  }




// Image imageFromCameraImage(CameraImage cameraImage) {
//   final width = cameraImage.width;
//   final height = cameraImage.height;
//   final Y = cameraImage.planes[0].bytes;
//   final U = cameraImage.planes[1].bytes;
//   final V = cameraImage.planes[2].bytes;

//   final uvRowStride = cameraImage.planes[1].bytesPerRow;
//   final uvPixelStride = cameraImage.planes[1].bytesPerPixel;

//   final imgData = Uint8List(width * height * 4);

//   int n = 0;
//   for (int y = 0; y < height; y++) {
//     int uvIndex = uvRowStride * (y ~/ 2);
//     for (int x = 0; x < width; x++) {
//       final yIndex = y * width + x;
//       final uvIndex2 = uvIndex + (x ~/ 2) * uvPixelStride!;
//       final y = Y[yIndex];
//       final u = U[uvIndex2];
//       final v = V[uvIndex2];

//       // Konversi YUV ke RGB
//       int r = (y + 1.13983 * (v - 128)).toInt();
//       int g = (y - 0.39465 * (u - 128) - 0.5806 * (v - 128)).toInt();
//       int b = (y + 2.03211 * (u - 128)).toInt();

//       // Pastikan nilai RGB berada dalam rentang 0-255
//       r = r.clamp(0, 255);
//       g = g.clamp(0, 255);
//       b = b.clamp(0, 255);

//       imgData[n++] = b;
//       imgData[n++] = g;
//       imgData[n++] = r;
//       imgData[n++] = 255; // Alpha channel
//     }
//   }

//   final ui.Image img = ui.Image.memory(imgData, width: width, height: height);

//   return Image(image: MemoryImage(Uint8List.fromList(imgData)));
// }


  