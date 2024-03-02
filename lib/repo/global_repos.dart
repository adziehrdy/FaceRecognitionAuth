import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:face_net_authentication/models/appversion_model.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/model_master_branch.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class GlobalRepo {
  Future<void> getLatestVersion(context) async {
    try {
      Response res =
          await callApi(ApiMethods.GET, '/auth/getversion', data: {});
      if (res.statusCode == 200) {
        String latestVersion =
            ""; // Inisialisasi variabel latestVersion sebagai String

        print(res.data);

        final appversionModel = appversionModelFromMap(jsonEncode(res.data));

        String platform = Platform.isAndroid ? 'android' : 'ios';

        latestVersion = appversionModel.data.multiple
            .firstWhere(
              (item) => item.os == platform,
            )
            .version;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            "LATEST_VERSION", latestVersion); // Simpan nilai latestVersion
      } else {
        print("Failed to get Latest Version");
      }
    } catch (e) {
      print(e);
      await checkIsNeedForceUpgrade(context);
      throw e;
    }

    await checkIsNeedForceUpgrade(context);
  }


  Future<String?> getMasterRegister() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response res =
          await callApi(ApiMethods.GET, '/employee/master-register', data: {});

      if (res.statusCode == 200) {
        await prefs.setString(
            "MASTER_REGISTER", jsonEncode(res.data).toString());
        return jsonEncode(res.data).toString();
      } else {
        print("Failed to retrieve data from master register");
        return prefs.getString("MASTER_REGISTER");
      }
    } on DioError catch (e) {
      print("Dio error: $e");
      throw e;
    } catch (e) {
      print("Error: $e");
      throw e;
    }
  }

  Future<String?> hitApiGetMsterShift() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response res = await callApi(ApiMethods.GET, '/master/shift');

    if (res.statusCode == 200) {
      await prefs.setString("MASTER_SHIFT", jsonEncode(res.data).toString());
      return jsonEncode(res.data).toString();
    } else {
      print("Failed to retrieve data from master register");
      return prefs.getString("MASTER_SHIFT");
    }
  }

  Future<bool> hitUpdateMasterShift(String employee_id, String shift_id) async {
    String approver = await getActiveSuperIntendentID();

    try {
      Response res = await callApi(ApiMethods.POST, '/employee/change-shift',
          data: {
            "employee_id": employee_id,
            "shift_id": shift_id,
            "approved_by": approver
          });

      if (res.statusCode == 200) {
        try {
          int code = res.data['code'];
          if (code == 200) {
            return true;
          } else {
            showToast(res.data["message"]);
            return false;
          }
        } catch (e) {
          print(e.toString());
          showToast(e.toString());
          return false;
        }
      } else {
        showToast("Terjadi Kesalahan, mohon cek koneksi internet");
        return false;
      }
    } catch (e) {
      showToast("Terjadi Kesalahan, mohon cek koneksi internet");
      return false;
    }
  }

  Future<bool> hitUpdateLokasi(String latlong, String Alamat) async {
    String id = await getActiveSuperIntendentID();
    String branch_id = await getBranchID();

    try {
      Response res =
          await callApi(ApiMethods.POST, '/master/update-location', data: {
        "branch_id": branch_id,
        "coordinate": latlong,
        "employee_id": id,
        "branch_address": Alamat
      });

      if (res.statusCode == 200) {
        showToast("Lokasi Berhasil Di Update");
        return true;
      } else {
        showToast("Mohon Cek Koneksi Internet | " +
            (res.statusCode ?? "").toString());
        return false;
      }
    } on DioError catch (e) {
      print("Dio error: $e");
      throw e;
    } catch (e) {
      showToast("Error: $e");
      throw e;
    }
  }


  Future<void> hitAllMasterRigStatus() async {

    LoginModel user = await getUserLoginData();
    Response res = await callApi(ApiMethods.GET, '/master/branch-statuses/'+user.branch!.branchId);

    if (res.statusCode == 200) {
      await SpSetALLStatusRig(res.data.toString());
      print(jsonEncode(res.data.toString()));
      if(await SpGetSelectedStatusRig() == null){

        List<BranchStatus> all_status = await SpGetALLStatusRig();
        
        // await await SpSetSelectedStatusRig(jsonDecode(all_status[0].toString()));
      }
      
    } else {
      showToast("Failed to retrieve data from MASTER_RIG_STATUS " + res.statusCode.toString());
    }
  }



  Future<List<MasterBranches?>> hitGetMasterBranches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response res = await callApi(ApiMethods.GET, '/master/branches');

    if (res.statusCode == 200) {
      await prefs.setString("MASTER_BRANCHES", jsonEncode(res.data.toString()).toString());
      return MasterBranches.listFromJson(jsonDecode(res.data.toString()));
    } else {
      print("Failed to retrieve data from MASTER_BRANCHES ");
      return MasterBranches.listFromJson(
          jsonDecode(await prefs.getString("MASTER_BRANCHES") ?? "[]"));
    }
  }
}
