import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';

import '../globals.dart';

class ReliefRepo {
  Future getReliefList() async{
    LoginModel user = await getUserLoginData();

    try {
      Response res = await callApi(ApiMethods.GET, '/master/list-relief/LUWUK-04-3');
      // Response res = await callApi(ApiMethods.GET, 'api/master/list-relief/'+(user.branch!.branchId));
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR GET LIST RELIEF");
      return [];
    }
  }

}