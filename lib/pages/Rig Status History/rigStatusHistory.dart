import 'package:face_net_authentication/db/database_helper_rig_status_history.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/widgets/dialog_change_rig_status.dart';
import 'package:face_net_authentication/repo/rig_status_repo.dart';
import 'package:flutter/material.dart';
// import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../models/model_rig_shift.dart';
import '../../models/rig_status_history_model.dart';
import '../../services/shared_preference_helper.dart';

class RigStatusHistory extends StatefulWidget {
  @override
  _RigStatusHistoryState createState() => _RigStatusHistoryState();
}

class _RigStatusHistoryState extends State<RigStatusHistory> {
  DatabaseHelperRigStatusHistory dbHelper =
      DatabaseHelperRigStatusHistory.instance;
  List<RigStatusHistoryModel> listStatus = [];

  RigStatusRepo repo = RigStatusRepo();

  RigStatusShift? brachStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
  }

  Future<void> initData() async {
    brachStatus = await SpGetSelectedStatusRig();
    await loadLocalData();
    await dbSync();
    // listStatus = await repo.getRigStatusHistory();
  }

  Future<void> loadLocalData() async {
    listStatus = await dbHelper.queryAllStatus();

    setState(() {
      listStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Rig Status History"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  dbHelper.deleteAll();
                },
                child: Text("delete all"))
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: listStatus.length,
            itemBuilder: (context, index) {
              return _buildTimelineTile(
                  dbHelper: dbHelper, context, data: listStatus[index]);
            },
          ),
        ));
  }

  Widget _buildTimelineTile(BuildContext context,
      {required DatabaseHelperRigStatusHistory dbHelper,
      required RigStatusHistoryModel data,
      List<String>? images,
      String? imageUrl}) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      isFirst: false,
      isLast: false,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Colors.blue,
        indicatorXY: 0.5,
      ),
      beforeLineStyle: LineStyle(
        color: Colors.blue,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: Colors.blue,
        thickness: 3,
      ),
      startChild: Container(
        constraints: BoxConstraints(
          minHeight: 120,
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Center(
            child: Text(
              formatDateString(data.date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      endChild: Container(
          padding: EdgeInsets.all(15),
          constraints: BoxConstraints(
            minHeight: 120,
          ),
          child: Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.status + " | " + (data.api_flag ?? "-"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text("Perubahan rig status ke " +
                      data.status.toLowerCase() +
                      "."),
                  if (images != null)
                    Row(
                      children: images
                          .map((url) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Image.network(
                                  url,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                  if (imageUrl != null)
                    Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialog_change_rig_status(
                                onStatusSelected: (selectedStatus) async {
                                  String selectedShift =
                                      await _showDialogPilihShift(context);

                                  RigStatusHistoryModel dataPreUpdate =
                                      RigStatusHistoryModel(
                                          id: data.id,
                                          branchId: data.branchId,
                                          branchStatusId:
                                              selectedStatus.statusBranchId ??
                                                  "-",
                                          requester: data.requester,
                                          status: selectedStatus.statusBranch ??
                                              "-",
                                          date: data.date,
                                          shift: selectedShift,
                                          api_flag: "U");

                                  await dbHelper.update(dataPreUpdate);
                                  setState(() {
                                    initData();
                                  });
                                },
                              );
                            },
                          );
                        },
                        child: Text("Edit")),
                  )
                ],
              ),
            ),
          )),
    );
  }

  dbSync() async {
    List<RigStatusHistoryModel> dataInsert = await dbHelper.queryForInsert();

    try {
      if (dataInsert.isNotEmpty) {
        for (RigStatusHistoryModel singleData in dataInsert) {
          try {
            bool result = await repo.insertRigStatusHistory(singleData);
            if (!result) {
              showToast("Kesalahan Saat insert " +
                  singleData.status +
                  " tanggal " +
                  singleData.date);
            } else {
              await dbHelper.delete(singleData);
            }
          } catch (e) {
            showToast(e.toString());
            break;
          }
        }
      }
    } catch (e) {
      // TODO
      showToast(e.toString());
    }
    getStatusAndInsertToLocal();
  }

  getStatusAndInsertToLocal() async {
    List<RigStatusHistoryModel> result = await repo.getRigStatusHistory();

    if (result.isNotEmpty) {
      await dbHelper.deleteAll();
      await dbHelper.insertAll(result);
      await loadLocalData();
    }
  }

  _showDialogPilihShift(BuildContext context) async {
    String selectedShift = "-";
    await showDialog(
      barrierDismissible: false, // add this line to disable dismiss
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Status'),
          content: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Shift"),
            items: brachStatus!.shift!.map((ShiftRig shift) {
              return DropdownMenuItem<String>(
                value: shift.id,
                child: Text(shift.id ?? "-"),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedShift = newValue ?? "-";
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle submit button
                Navigator.of(context).pop(selectedShift);
              },
            ),
          ],
        );
      },
    );
  }
}
