<<<<<<< Updated upstream
=======
import 'package:face_net_authentication/db/database_helper_rig_status_history.dart';
import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/pages/widgets/dialog_change_rig_status.dart';
import 'package:face_net_authentication/repo/rig_status_repo.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';

<<<<<<< Updated upstream
const kTileHeight = 50.0;
=======
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

  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();
    loadLocalData();
    dbSync();
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
>>>>>>> Stashed changes

class rigStatusHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Rig Status History"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add padding around the OrderTrackerZen widget for better presentation.
            Card(
                elevation: 2,
                margin: EdgeInsets.all(20),
                // OrderTrackerZen is the main widget of the package which displays the order tracking information.
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: OrderTrackerZen(
                    animation_duration: 5,
                    isShrinked: false,
                    // Provide an array of TrackerData objects to display the order tracking information.
                    tracker_data: [
                      // TrackerData represents a single step in the order tracking process.
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "",
                        // Provide an array of TrackerDetails objects to display more details about this step.
                        tracker_details: [
                          // TrackerDetails contains detailed information about a specific event in the order tracking process.
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Maintanace",
                            datetime: "Sat, 8 Apr '22 - 17:17",
                          ),
                        ],
                      ),
                      // yet another TrackerData object
                      TrackerData(
                        title: "OPERATION",
                        date: "Sat, 8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "Perubahan Rig Status Menjadi Operation",
                            datetime: "Sat, 8 Apr '22 - 17:50",
                          ),
                        ],
                      ),
                      // And yet another TrackerData object
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                      TrackerData(
                        title: "MAINTANACE",
                        date: "Sat,8 Apr '22",
                        tracker_details: [
                          TrackerDetails(
                            title: "You received your order, by MailDeli",
                            datetime: "Sat, 8 Apr '22 - 17:51",
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
=======
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Rig Status History"),
          actions: [
            // ElevatedButton(
            //     onPressed: () {
            //       dbHelper.deleteAll();
            //     },
            //     child: Text("delete all"))
>>>>>>> Stashed changes
          ],
        ),
      ),
<<<<<<< Updated upstream
=======
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
                                    "Untuk mengedit Status hari ini mohon mengganti di menu utama");
                              } else {
                                RigStatusShift? statusSelected;
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
                                      ? listShift!.shift![0].id
                                      : await _showDialogPilihShift(
                                              context, data.shift ?? "") ??
                                          null;
                                  if (selectedShift != null) {
                                    await dbHelper.update(
                                        data,
                                        statusSelected?.statusBranchId ?? "-",
                                        statusSelected?.statusBranch ?? "-",
                                        selectedShift!);
                                    await loadLocalData();
                                    await dbSync();
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

  dbSync() async {
    bool connection = await onLineChecker();

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

        loadLocalData();
      } catch (e) {}
    }
  }

  _showDialogPilihShift(BuildContext context, String lastShift) async {
    selectedShift = null;
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
>>>>>>> Stashed changes
    );
  }
}
