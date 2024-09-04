import 'package:face_net_authentication/models/catering_history_model.dart';
import 'package:face_net_authentication/pages/widgets/dialog_change_catering_status.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../globals.dart';
import '../../models/model_rig_shift.dart';
import '../../repo/catering_history_repo.dart';
import '../db/database_helper_catering_status.dart';
import '../db/dbSync.dart';

class CateringHistory extends StatefulWidget {
  const CateringHistory({Key? key}) : super(key: key);

  @override
  _CateringHistoryState createState() => _CateringHistoryState();
}

DatabaseHelperCateringHistory dbHelper = DatabaseHelperCateringHistory.instance;
List<CateringHistoryModel> listStatus = [];

RigStatusShift? listShift;

CateringHistoryRepo repo = CateringHistoryRepo();

class _CateringHistoryState extends State<CateringHistory> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Catering History"),
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

  Future<void> loadLocalData() async {
    listStatus = await dbHelper.queryAllStatus();

    setState(() {
      listStatus;
    });
  }

  Future<void> initData() async {
    listShift = await SpGetSelectedStatusRig();
    loadLocalData();
    Sync();
  }

  Widget _buildTimelineTile(BuildContext context,
      {required DatabaseHelperCateringHistory dbHelper,
      required CateringHistoryModel data,
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
                        "CATERING " + data.status,
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
                  Text("Perubahan Status Catering Ke " +
                      data.status +
                      " pada shift " +
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
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    bool isActive = false;
                                    if (data.status == "AKTIF") {
                                      isActive = true;
                                    } else {
                                      isActive = false;
                                    }

                                    return dialog_change_catering_status(
                                      onStatusSelected:
                                          (shift, isActive) async {
                                        await dbHelper.update(
                                            data, shift, isActive);
                                        loadLocalData();
                                        Sync();
                                      },
                                      Lastshift: data.shift ?? "-",
                                      LastisActiveCatering: isActive,
                                      ListShift: listShift,
                                    );
                                  },
                                );
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

  Sync() async {
    if (await dBsync().dBsyncCateringHistory()) {
      loadLocalData();
    }
  }
}

// bool switchValue = false;
//                           List<String> listShift = [
//                             "Shift 1",
//                             "Shift 2",
//                             "Shift 3"
//                           ];
//                           await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text("Edit"),
//                                 content: StatefulBuilder(
//                                   builder: (context, setState) {
//                                     return Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         SwitchListTile(
//                                           title: Text("Switch"),
//                                           value: switchValue,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               switchValue = value;
//                                             });
//                                           },
//                                         ),
//                                         ListView.builder(
//                                           shrinkWrap: true,
//                                           itemCount: listShift.length,
//                                           itemBuilder: (context, index) {
//                                             return ListTile(
//                                               title: Text(listShift[index]),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           );
//                         },