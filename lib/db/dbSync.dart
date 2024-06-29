import 'package:face_net_authentication/db/database_helper_catering_exception.dart';
import 'package:face_net_authentication/db/database_helper_catering_status.dart';
import 'package:face_net_authentication/db/database_helper_rig_status_history.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/catering_exception_model.dart';
import 'package:face_net_authentication/models/catering_history_model.dart';
import 'package:face_net_authentication/models/rig_status_history_model.dart';
import 'package:face_net_authentication/repo/catering_exception_repo.dart';
import 'package:face_net_authentication/repo/catering_history_repo.dart';
import 'package:face_net_authentication/repo/rig_status_repo.dart';

class dBsync {
  Future<bool> dbSyncCateringException() async {
    CateringExceptionRepo repo = CateringExceptionRepo();
    bool connection = await onLineChecker();
    DatabaseHelperCateringException dbException =
        DatabaseHelperCateringException.instance;
    if (connection) {
      List<catering_exception_model> listDelete =
          await dbException.getAllSoftDelete();
      try {
        for (catering_exception_model singleDelete in listDelete) {
          if (await repo.delete(singleDelete) != []) {
            dbException.delete(singleDelete);
          } else {
            throw Exception();
          }
        }
        dbException.insertAll(await repo.getAllCateringException());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> dBsyncCateringHistory() async {
    DatabaseHelperCateringHistory dbHelper =
        DatabaseHelperCateringHistory.instance;
    bool connection = await onLineChecker();
    CateringHistoryRepo repo = CateringHistoryRepo();

    if (connection) {
      List<CateringHistoryModel> listUpdate =
          await dbHelper.queryForUpdateOnline();
      try {
        for (CateringHistoryModel singleDelete in listUpdate) {
          if (await repo.insertCateringHistory(singleDelete) != []) {
            dbHelper.softDelete(singleDelete);
          } else {
            throw Exception();
          }
        }

        dbHelper.insertAll(await repo.getCateringHistory());
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> dbSyncRigHistory() async {
    bool connection = await onLineChecker();
    DatabaseHelperRigStatusHistory dbHelper =
        DatabaseHelperRigStatusHistory.instance;

    RigStatusRepo repo = RigStatusRepo();

    if (connection) {
      List<RigStatusHistoryModel> listUpdate =
          await dbHelper.queryForUpdateOnline();
      try {
        for (RigStatusHistoryModel singleDelete in listUpdate) {
          if (await repo.insertRigStatusHistory(singleDelete) != []) {
            dbHelper.softDelete(singleDelete);
          } else {
            throw Exception();
          }
        }

        dbHelper.insertAll(await repo.getRigStatusHistory());

        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  syncAllDB() async {
    await dbSyncCateringException();
    await dbSyncRigHistory();
    await dBsyncCateringHistory();
  }
}
