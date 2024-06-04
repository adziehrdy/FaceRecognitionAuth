import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/catering_history_model.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/rig_status_history_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../db/databse_helper_employee_relief.dart';
import '../globals.dart';
import 'user_repos.dart';

class CateringHistoryRepo {
  Future<List<CateringHistoryModel>> getCateringHistory() async {
    LoginModel user = await getUserLoginData();

    try {
      Response res = await callApi(ApiMethods.GET,
          '/rig-catering/get-list?branch_id=' + (user.branch!.branchId));
      log(json.encode(res.data));
      // return json.encode(res.data);

      List<CateringHistoryModel> listData = [];
      res.data.forEach((item) {
        listData.add(CateringHistoryModel.fromMap(item));
      });
      return listData;
    } catch (e) {
      showToast("Cek Koneksi Internet");
      print("ERROR GET LIST RIG STATUS HISTORY");
      return [];
    }
  }

  Future insertCateringHistory(CateringHistoryModel data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/rig-catering/create',
          data: data.toMap());
      log(json.encode(res.data));
      return true;
    } catch (e) {
      print("ERROR SUBMIT RIGSTATUS");
      return false;
    }
  }
}
