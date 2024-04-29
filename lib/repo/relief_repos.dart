import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';

import '../globals.dart';

class ReliefRepo {
  Future getReliefList() async {
    LoginModel user = await getUserLoginData();

    try {
      // Response res = await callApi(ApiMethods.GET, '/master/list-relief/LUWUK-04-3');
      Response res = await callApi(
          ApiMethods.GET, '/master/list-relief/' + (user.branch!.branchId));
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR GET LIST RELIEF");
      return [];
    }
  }

  Future hitFormRelief(Map<String, dynamic> form_data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/master/employee-relief',
          data: form_data);
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR SUBMIT RELIEF");
      return false;
    }
  }

  Future approveRelief(String relief_id, String status) async {
    Map<String, dynamic> form_data;
    form_data = {
      "relief_id": relief_id,
      "relief_status": status,
    };
    try {
      Response res = await callApi(
          ApiMethods.POST, '/master/approved-employee-relief',
          data: form_data);
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR SUBMIT RELIEF");
      return false;
    }
  }
}
