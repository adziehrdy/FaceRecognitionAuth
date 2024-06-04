import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/catering_exception_model.dart';
import 'package:face_net_authentication/models/login_model.dart';

import '../globals.dart';

class CateringExceptionRepo {
  Future<List<catering_exception_model>> getAllCateringException() async {
    LoginModel user = await getUserLoginData();
    try {
      Response res = await callApi(
          ApiMethods.GET,
          '/rig-catering-exception/get-list?branch_id=' +
              (user.branch!.branchId));
      log(json.encode(res.data));

      List<catering_exception_model> listCateringException = [];
      res.data.forEach((item) {
        listCateringException.add(catering_exception_model.fromMap(item));
      });

      return listCateringException;
    } catch (e) {
      showToast("Cek Koneksi Internet");
      print("ERROR GET LIST RIG STATUS HISTORY");
      return [];
    }
  }

  Future insertCateringException(catering_exception_model data) async {
    try {
      Response res = await callApi(
          ApiMethods.POST, '/rig-catering-exception/create',
          data: data.toMap());
      log(json.encode(res.data));
      showToast("Catering Exception Telah Ditambahkan");
      return json.encode(res.data);
    } catch (e) {
      print("ERROR SUBMIT RIGSTATUS");

      return false;
    }
  }

  Future delete(catering_exception_model data) async {
    try {
      Response res = await callApi(
          ApiMethods.DELETE, '/rig-catering-exception/delete',
          data: data.toMap());
      log(json.encode(res.data));
      return json.encode(res.data);
    } catch (e) {
      print("ERROR DELETE RIGSTATUS");

      return false;
    }
  }

  // Future updateRigStatusHistory(catering_exception_model data) async {
  //   try {
  //     Response res = await callApi(ApiMethods.POST,
  //         '/rig-catering-exception/update/' + (data.id.toString()),
  //         data: data.toMap());
  //     log(json.encode(res.data));
  //     return json.encode(res.data);
  //   } catch (e) {
  //     print("ERROR UPDATE RIGSTATUS");
  //     return false;
  //   }
  // }
}
