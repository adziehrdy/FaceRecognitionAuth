import 'package:face_net_authentication/db/database_helper_rig_status_history.dart';
import 'package:face_net_authentication/db/dbSync.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
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
  RigStatusShift? statusSelected;

  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
    loadLocalData();
    sync();
  }

  String? selectedShift;

  Future<void> initData() async {
    // brachStatus = await SpGetSelectedStatusRig();
    brachStatus = await SpGetSelectedStatusRig();
    // await dbSync();
    // listStatus = await repo.getRigStatusHistory();
    setState(() {
      listStatus;
    });
    // await dbSync();

    // await repo.insertRigStatusHistory(RigStatusHistoryModel(
    //     branchId: "ICTDEV",
    //     branchStatusId: "99",
    //     requester: "001",
    //     status: "TEST 2",
    //     date: "2024-06-01 21:29:56",
    //     api_flag: "",
    //     shift: "PDC_MALAM"));
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
            // ElevatedButton(
            //     onPressed: () {
            //       dbHelper.deleteAll();
            //     },
            //     child: Text("delete all"))
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
                  Row(
                    children: [
                      Text(
                        data.status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      data.api_flag != null
                          ? Icon(
                              size: 20,
                              Icons.cloud_off,
                              color: Colors.orange,
                            )
                          : SizedBox()
                    ],
                  ),
                  SizedBox(height: 6),
                  Text("Perubahan rig status ke " +
                      data.status.toLowerCase() +
                      " pada Shift " +
                      (data.shift ?? "-")),
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
                    child: data.approver == null
                        ? ElevatedButton(
                            onPressed: () async {
                              if (isTodayChecker(DateTime.now(), data.date)) {
                                showToast(
                                    "Untuk Mengedit Status Hari Ini Mohon Edit Di menu Utama");
                              } else {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialog_change_rig_status(
                                      onStatusSelected: (selectedStatus) async {
                                        statusSelected = selectedStatus;
                                      },
                                    );
                                  },
                                );

                                if (statusSelected != null) {
                                  data.shift == "-"
                                      ? brachStatus!.shift![0].id
                                      : await _showDialogPilihShift(context,
                                              data.shift ?? "", data) ??
                                          null;
                                  if (selectedShift != null) {
                                    await dbHelper.update(
                                        data,
                                        statusSelected?.statusBranchId ?? "-",
                                        statusSelected?.statusBranch ?? "-",
                                        selectedShift!);
                                    await loadLocalData();
                                    await sync();
                                  }
                                }
                              }
                            },
                            child: Text("Edit"))
                        : Text(
                            "SUDAH DI APPROVE",
                            style: TextStyle(color: Colors.blue),
                          ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  sync() async {
    if (await dBsync().dbSyncRigHistory()) {
      loadLocalData();
    }
  }

  _showDialogPilihShift(BuildContext context, String lastShift,
      RigStatusHistoryModel data) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Status'),
          content: DropdownButtonFormField<String>(
            value: lastShift,
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
              onPressed: () async {
                await dbHelper.update(
                    data,
                    statusSelected?.statusBranchId ?? "-",
                    statusSelected?.statusBranch ?? "-",
                    selectedShift!);
                await loadLocalData();
                await sync();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
