import 'package:dio/dio.dart';
import 'package:face_net_authentication/pages/models/approval.dart';

import '../globals.dart';

class ApprovalRepo {
  Future<int?> countApproval() async{
    try {
      Response res = await callApi(ApiMethods.GET, '/approval/count');
      return res.data['count'];
    } catch (e) {
      return 0;
    }
  }

  Future getApprovalList(int page, String status) async{
    try {
      Response res = await callApi(ApiMethods.GET, '/approval/paginate/$status?page=$page');
      return res.data;
    } catch (e) {
      return [];
    }
  }

  Future update(Approval data) async {
    try {
      Response res = await callApi(ApiMethods.POST, '/approval/update/${data.id}', data: data.toUpdateMap());
    } catch (e) {
      throw e;
    }
  }
}