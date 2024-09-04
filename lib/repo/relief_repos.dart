import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../globals.dart';
import '../pages/db/databse_helper_employee_relief.dart';
import 'user_repos.dart';

class ReliefRepo {
  Future getReliefList() async {
    LoginModel user = await getUserLoginData();

    try {
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
      showToast(
          "RELIEF SUKSES DI AJUKAN, MOHON MENUNGGU APPROVE DARI RIG TUJUAN");
      return json.encode(res.data);
    } catch (e) {
      print("ERROR SUBMIT RELIEF");
      return false;
    }
  }

  Future approveRelief(String relief_id, String status) async {
    String supt_id = await getActiveSuperIntendentID();
    Map<String, dynamic> form_data;
    form_data = {
      "relief_id": relief_id,
      "relief_status": status,
      "approved_by": supt_id
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

  Future<List<bool>> refreshEmployeeRelief(BuildContext context) async {
    LoginModel loginData = await getUserLoginData();
    String branchID = loginData.branch!.branchId;
    List<User> user_list = [];
    List<bool> selected = [];
    DatabaseHelperEmployeeRelief _dataBaseHelper =
        DatabaseHelperEmployeeRelief.instance;
    UserRepo userRepo = UserRepo();
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Fetching data...');
    String? jsonKaryawan = await userRepo
        .apiGetAllEmployeeRelief(branchID)
        .onError((error, stackTrace) {
      progressDialog.close();
    });

    if (jsonKaryawan != null) {
      // jsonKaryawan = DummyJson;
      print(jsonKaryawan);
      try {
        List<dynamic> jsonDataList = jsonDecode(jsonKaryawan);

        user_list.clear();
        _dataBaseHelper.deleteAll();

        int totalItems = jsonDataList.length;
        int processedItems = 0;

        try {
          for (var jsonData in jsonDataList) {
            var person = User.fromMap(jsonData);
            await _dataBaseHelper.insert(person);

            processedItems++;
            progressDialog.update(
              value: ((processedItems / totalItems) * 100).toInt(),
              msg: 'Updating data... ($processedItems/$totalItems)',
            );
            selected.add(false);
          }
        } catch (e) {
          await _dataBaseHelper.deleteAll();
          print(e.toString());
        }

        return selected;
        // await loadUserData();
      } catch (e) {
        print(e);
        progressDialog.close();
      } finally {
        progressDialog.close();
      }
    } else {
      showToast('Terjadi kesalahan saat mengambil data karyawan');
      progressDialog.close();
    }
    return selected;
  }
}
