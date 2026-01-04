import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/rig_status_history_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../globals.dart';
import 'user_repos.dart';

class RigStatusRepo {
  Future<List<RigStatusHistoryModel>> getRigStatusHistory() async {
    LoginModel user = await getUserLoginData();

    try {
      Response res = await callApi(ApiMethods.GET,
          '/rig-status/get-list?branch_id=' + (user.branch!.branchId));
      log(json.encode(res.data));
      // return json.encode(res.data);

      List<RigStatusHistoryModel> listData = [];
      res.data.forEach((item) {
        listData.add(RigStatusHistoryModel.fromMap(item));
      });
      return listData;
    } catch (e) {
      showToast("Cek Koneksi Internet");
      print("ERROR GET LIST RIG STATUS HISTORY");
      return [];
    }
  }

  Future insertRigStatusHistory(RigStatusHistoryModel data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/rig-status/create',
          data: data.toMap());
      log(json.encode(res.data));
      return true;
    } catch (e) {
      print("ERROR SUBMIT RIGSTATUS");
      return false;
    }
  }

  Future updateRigStatusHistory(RigStatusHistoryModel data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/api/rig-status/update',
          data: data.toMap());
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR UPDATE RIGSTATUS");
      return false;
    }
  }
}
