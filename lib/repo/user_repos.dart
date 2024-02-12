import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class UserRepo {
  String hashPassword(String pass) {
    var bytes = utf8.encode(pass);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future changePassword(String oldPassword, String newPassword) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/user/password/change',
          data: {'old': oldPassword, 'new': newPassword});
    } catch (e) {
      throw e;
    }
  }

  Future resetPassword(String userId) async {
    try {
      Response res =
          await callApi(ApiMethods.POST, '/user/password/reset/$userId');
    } catch (e) {
      throw e;
    }
  }

  Future changeDeviceId(String userId, String deviceId) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/user/device/reset',
          data: {'sub': userId, 'deviceId': deviceId});
    } catch (e) {
      throw e;
    }
  }

  Future<String?> apiGetAllEmployee() async {
    Response res = await callApi(ApiMethods.GET, '/master/employees');
    return json.encode(res.data);
  }

  Future<String?> apiGetAllEmployeeByBranch(String id_branch) async {
    print(id_branch);
    try {
      Response res =
          await callApi(ApiMethods.GET, '/master/employees/' + id_branch);
      return json.encode(res.data);
    } catch (e) {
      throw e;
    }
  }



  Future registerFcmToken(User user, String token) async {
    try {
      await callApi(ApiMethods.POST, '/notification/set-token', data: {
        'user_id': user.employee_id,
        'device_id': await getDeviceId(),
        'company_id': user.company_id,
        'token': token
      });
    } catch (e) {
      print(e);
    }
  }

  Future upload_face_template(String id, String faceTemplate) async {
    try {
      await callApi(ApiMethods.POST, '/employee/update-fr', data: {
        'employee_id': id,
        'face_template': faceTemplate,
      });
    } catch (e) {
      print(e);
    }
  }


  Future<void> hitLogin(context, id, String password, String versionLabel) async {
    showDialog(
      context: context,
      barrierDismissible: true, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Show CircularProgressIndicator
        );
      },
    );

    try {
      Map<String, dynamic> data;

      if(password == "mbed-recn-uhva-ycsy"){
         data = {
        "deviceId": "GOOGLE_PLAY_DEMO",
        "password": password,
        "version": versionLabel
      };

      }else{
         data = {
        "deviceId": id,
        "password": password,
        "version": versionLabel
      };
      }
      
      Response res = await callApiWithoutToken(ApiMethods.POST, '/device/login',
          data: data);
      print(res);
      if (res.statusCode == 200) {
        // Parse the response JSON
        log(res.data.toString());
        Map<String, dynamic> responseJson = res.data;

        // Assuming your response JSON structure matches the provided example

        // Create LoginModel and Branch instances
        LoginModel data = LoginModel.fromMap(responseJson);

        // Store login data in shared preferences
        if (data.branch?.branchId != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('LOGIN_DATA', json.encode(data.toMap()));
          await prefs.setString('TOKEN', data.accessToken!);
          await prefs.setBool('IS_LOGIN', true);

          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        } else {
          Navigator.pop(context);
          showToast("Branch id kosong, mohon setUp di website");
        }
      }
    } catch (e) {
      if (e is DioException) {
        showToast(e.response!.data['message']);
      } else {
        showToast(e.toString());
      }
      Navigator.pop(context);
    }
  }

      Future<bool> uploadFR(String employee_id, String face_template, String face_image) async{

    try {
      Response res = await callApi(ApiMethods.POST, '/employee/upload-fr', data: {
        "employee_id": employee_id,
        "face_template": face_template,
        "face_image": "data:image/png;base64,"+face_image
      });

      // log(res.data);

      if(res.statusCode == 200){
         return true;
      }else{
        
        return false;
      }
      

    } catch (e) {
      showToast("Terjadi Kesalahan Saat Upload FR ke Server " );
      showToast(e.toString());
      throw e;
    }
  }

  Future<bool> hitApproveFR(String employee_id) async{
    
    String id_superIntendent = await getActiveSuperIntendentID();
         

    List<String> list_id = [employee_id];

    
    try {
      Response res = await callApi(ApiMethods.POST, '/employee/approval-fr', data: {
        "employee_id": list_id,
         "approved_by": id_superIntendent,
          "is_approved": true,
      });



      if(res.statusCode == 200){
         return true;
      }else{
        return false;
      }
      

    } catch (e) {
      showToast("Terjadi Kesalahan Saat Approve FR ke Server");
      throw e;
    }
  }


  Future<bool> hitApproveEmployee(String employee_id) async{
    try {
      Response res = await callApi(ApiMethods.POST, '/employee/approval-new-employee', data: {
        "employee_id": employee_id,
      });
      print(res.data);

      if(res.statusCode == 200){
         return true;
      }else{
        return false;
      }
    } catch (e) {
      showToast("Terjadi Kesalahan Saat Approve FR ke Server");
      throw e;
    }
  }
}
