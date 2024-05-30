import 'package:face_net_authentication/db/database_helper_catering_status.dart';
import 'package:face_net_authentication/models/catering_history_model.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../db/database_helper_rig_status_history.dart';
import '../../globals.dart';
import '../../models/rig_status_history_model.dart';
import '../widgets/dialog_change_rig_status.dart';

class CateringHistory extends StatefulWidget {
  const CateringHistory({Key? key}) : super(key: key);

  @override
  _CateringHistoryState createState() => _CateringHistoryState();
}

DatabaseHelperCateringHistory dbHelper = DatabaseHelperCateringHistory.instance;
List<CateringHistoryModel> listStatus = [];

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

  Future<void> loadLocalData() async {
    listStatus = await dbHelper.queryAllStatus();

    setState(() {
      listStatus;
    });
  }

  Future<void> initData() async {
    await loadLocalData();
    // listStatus = await repo.getRigStatusHistory();
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
                  Text(
                    "CATERING " + data.status + " | " + (data.api_flag ?? "-"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
                    child: ElevatedButton(
                        onPressed: () async {
                          // await showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {},
                          // );
                        },
                        child: Text("Edit")),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
