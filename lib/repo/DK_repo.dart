import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';

import '../globals.dart';

class DKRepo {
  Future getListDK() async {
    LoginModel user = await getUserLoginData();

    try {
      Response res =
          await callApi(ApiMethods.GET, '/dk/list/' + user.branch!.branchId);
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR GET LIST DK");
      return [];
    }
  }

  Future createDK(Map<String, dynamic> form_data) async {
    try {
      Response res =
          await callApi(ApiMethods.POST, '/dk/create', data: form_data);
      log(json.encode(res.data));
      showToast("Dinas Khusus Telah Ditambahkan");
      return true;
    } catch (e) {
      print("ERROR SUBMIT DK");
      return false;
    }
  }

  Future approvalDK(String id_dk, Map<String, dynamic> form_data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/dk/approved/' + id_dk,
          data: form_data);
      log(json.encode(res.data));
      return true;
    } catch (e) {
      print("ERROR Approval DK");
      return false;
    }
  }
}
