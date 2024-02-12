import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/attendance.dart';
import 'package:face_net_authentication/models/attendance_approval.dart';
import 'package:face_net_authentication/models/branch.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class AttendanceRepos {
  Future<Response> afterScanCheck(Map<String, dynamic> map, String type) async{
    return await callApi(ApiMethods.POST, '/attendance/after-scan-check/$type', data: map);
  }

  // Future verifyAbsensi(Attendance attendance, AttendanceApproval? attendanceApproval,  AttendanceApproval? outOfficeApproval, String? mode) async{
  //   return await callApi(ApiMethods.POST, '/attendance/wfoinput/$mode', data: <String, dynamic>{
  //     "attendance": attendance.toCreateMap(),
  //     "attendanceApproval": attendanceApproval?.toMap(),
  //     "outOfficeApproval": outOfficeApproval?.toMap()
  //   });
  // }

    Future uploadAbsensi(Attendance attendance, String id) async{
      
     Map <String, dynamic> data ={
      "attendance": attendance.toCreateMapForHitAPI(),
      "attendanceApprovalIn": attendance.toCreateMapForHit_Approval_in(),
      "attendanceApprovalOut": attendance.toCreateMapForHit_Approval_out(),
      //       "attendanceApprovalIn": null,
      // "attendanceApprovalOut": null,
    };

    

    

    String param = jsonEncode(data);


    


    return await callApi(ApiMethods.POST, '/attendance/demo/wfoinput', data: data);
  }

  Future verifyAbsensiWFH(File image, Attendance attendance, AttendanceApproval? attendanceApproval, String? mode) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString("TOKEN");
    String? token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMDMuNDEuMjA1LjQyXC9zaWthcFwvc2lrYXAtYXBpXC9hcGlcL2F1dGhcL2xvZ2luIiwiaWF0IjoxNjkwNDg0MzUzLCJleHAiOjE2OTMwNzYzNTMsIm5iZiI6MTY5MDQ4NDM1MywianRpIjoiMWtYUmtEQ3QzVkJ4eHFVMiIsInN1YiI6IjExMDc5NiIsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEiLCJhcGsiOiIxLjAuNiIsIm9zIjoiYW5kcm9pZCJ9.2UOpslKN-YUMWUYIfpP_1vMIWVaQerDzv5h21DEeQjg";
    Map<String, String> headers;

    if(token != null){
      print(token);
      headers = {
        "Content-Type": "false",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };
    } else {
      headers = {
        "Content-Type": "false",
        "Accept": "application/json"
      };
    }

    String ext = extension(image.path);
    String filename = DateTime.now().millisecondsSinceEpoch.toString() + ext;

    try {
      Uri url = Uri.parse(endpointUrl! + '/attendance/demo/wfhinput/$mode?token=$token');
       
      http.MultipartRequest req = http.MultipartRequest('POST', url)
        ..fields['attendance'] = json.encode(attendance.toCreateMap())
        ..files.add(await http.MultipartFile.fromPath('file', image.path, filename: filename))
        ..headers.addAll(headers);
      
      if(attendanceApproval != null){
        req.fields["attendanceApproval"] = json.encode(attendanceApproval.toMap());
      }


      http.StreamedResponse res = await req.send();
      if(res.statusCode == 200){
        return null;
      } else {
        final str = json.decode(await res.stream.bytesToString());
        return str["message"];
      }
    } catch (e) {
      String errorMessage = 'Error Occurred';
    if (e is DioError) {
      if (e.response?.data != null) {
        errorMessage = e.response!.data.toString();
      } else {
        errorMessage = e.message.toString();
      }
    } else {
      errorMessage = e.toString();
    }
    return errorMessage;
    }
  }
Future<Map<String, dynamic>> canCheckIn(String id) async {
  print(id);
  try {
    Response res = await callApi(ApiMethods.POST, '/attendance/demo/can-checkin',data: {
      "employee_id":id
    });
    if (res.statusCode == 200) {
      return {
        "canCheckIn": res.data['canCheckIn'],
        "lastAttendance": res.data['lastAttendance'] == null ? null : Attendance.fromMap(res.data['lastAttendance'])
      };
    }
  } catch (e) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool b = pref.getBool('CANCHECKIN') ?? true;
    return {
      "canCheckIn": b,
      "lastAttendance": null
    };
  }
  
  // Add a return statement here to handle the case when none of the conditions above are met
  return {
    "canCheckIn": false,
    "lastAttendance": null
  };
}

  Future<Map<String, dynamic>> canCheckOut(String pageType, String id) async{
    print(id);
    try{
    Response res = await callApi(ApiMethods.POST, '/attendance/demo/can-checkout/$pageType',data: {
      "employee_id":id
    });
    if (res.statusCode == 200) {
      return {
        "canCheckOut": res.data['canCheckOut'],
        "lastAttendance": res.data['lastAttendance'] == null ? null : Attendance.fromMap(res.data['lastAttendance'])
      };
    }

   } catch (e) {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool b = pref.getBool('CANCHECKOUT') ?? true;
    return {
      "canCheckOut": b,
      "lastAttendance": null
    };
  }
  
  // Add a return statement here to handle the case when none of the conditions above are met
  return {
    "canCheckOut": false,
    "lastAttendance": null
  };
  }



  List<Map<String, dynamic>> checkGeofencing(double? lat, double? lng, List<Branch> branches){
    final Distance distance = new Distance();
    List<Map<String, dynamic>> map = [];
    for(Branch branch in branches){
      final meter = distance.as(
        LengthUnit.Meter, LatLng(lat!, lng!), LatLng(branch.branchLat, branch.branchLng));
      map.add({
        "branch": branch,
        "result": meter <= branch.branchGeofencing!,
        "distance": meter
      });
    }
    
    return map;
  }

  double calculateDistance1(double lat, double lng, Branch branch){
    final Distance distance = new Distance();
    final meter = distance.as(
      LengthUnit.Meter, LatLng(lat, lng), LatLng(branch.branchLat, branch.branchLng));
    return meter;
  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos as double Function(num?);
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future setCheckInPreferences(bool val) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("CANCHECKIN", val);
  }

  Future setLastAttendanceTypePreference(String val) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("LASTATTENDANCETYPE", val);
  }

  Future<Map<String, dynamic>?> getAttendanceList(String? month, int page, List<String?>? absenStatus, List<String>?ijinStatus) async{
    try {
      Response res = await callApi(ApiMethods.POST, '/attendance/list-kehadiran/$month?page=$page', data: {
        "absenStatus": absenStatus,
        "ijinStatus": ijinStatus
      });
      return res.data;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getAttendanceListDateRange(String start, String end, int page, List<String?>? absenStatus, List<String>?ijinStatus) async{
    try {
      Response res = await callApi(ApiMethods.POST, '/attendance/list-kehadiran/$start/$end?page=$page', data: {
        "absenStatus": absenStatus,
        "ijinStatus": ijinStatus
      });
      return res.data;
    } catch (e) {
      throw e;
    }
  }


}