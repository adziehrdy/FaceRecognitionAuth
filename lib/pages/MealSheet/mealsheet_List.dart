import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/pages/MealSheet/database_helper_mealsheet.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/history_absensi.dart';
import 'package:flutter/material.dart';

class MealHistoryList extends StatefulWidget {
  const MealHistoryList({Key? key}) : super(key: key);
  @override
  _MealHistoryListState createState() => _MealHistoryListState();
}

DatabaseHelperMealsheet databaseHelperMealsheet =
    DatabaseHelperMealsheet.instance;
List<MealSheetModel> Historydata = [];

class _MealHistoryListState extends State<MealHistoryList> {
  @override
  initState() {
    super.initState();
    initData();
  }

  initData() {
    Historydata = [];
    databaseHelperMealsheet.getAllData().then((value) {
      setState(() {
        Historydata = value.reversed.toList();
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meal attendance Reguler"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Historydata.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          Historydata[index]
                                              .employeeName
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formatDateFriendly(
                                              Historydata[index].initDate!),
                                          style: TextStyle(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Historydata[index].accommodation != null
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "|  + Akomodasi",
                                                    style: TextStyle(
                                                        color: Colors.indigo),
                                                  ),
                                                  // Icon(
                                                  //   Icons.bed,
                                                  //   size: 20,
                                                  // ),
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                width: 1,
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  sheetItem(
                                      "Sahur", Historydata[index].sahur_time),
                                  sheetItem("Breakfast",
                                      Historydata[index].bFastTime),
                                  sheetItem(
                                      "Lunch", Historydata[index].lunchTime),
                                  sheetItem(
                                      "Dinner", Historydata[index].dinnerTime),
                                  sheetItem(
                                      "Supper", Historydata[index].supperTime),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    color: Colors.grey,
                                    onPressed: () {
                                      Dialog simpleDialog = Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12.0)), //this right here
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Meal Sheet Detail",
                                                textAlign: TextAlign.start,
                                              ),
                                              mealSheetDetail(
                                                  Historydata[index]),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Close"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleDialog);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ));
  }

  Widget mealCard(MealSheetModel data) {
    return Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.employeeName.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text(data.initDate!.toIso8601String() ?? ""),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 1,
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      sheetItem("Sahur", data.sahur_time),
                      sheetItem("Breakfast", data.bFastTime),
                      sheetItem("Lunch", data.lunchTime),
                      sheetItem("Dinner", data.dinnerTime),
                      sheetItem("Supper", data.supperTime),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: 20,
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget sheetItem(String name, DateTime? time) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (time != null) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Container(
      width: 120,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: statusColor,
          begin: Alignment.bottomRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.fastfood_rounded, color: Colors.white, size: 15),
          SizedBox(
            width: 2,
          ),
          Container(
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          time != null
              ? Row(
                  children: [
                    Container(
                      width: 1,
                      height: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      formatHourOnly(time),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget mealSheetDetail(MealSheetModel mealSheet) {
    int mealSheetFilledCount = 0;
    if (mealSheet.sahur_time != null) {
      mealSheetFilledCount += 1;
    }
    if (mealSheet.bFastTime != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.lunchTime != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.dinner != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.supper != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.accommodation != null) {
      mealSheetFilledCount += 1;
    }
    return Card(
      child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    mealSheet.employeeName.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    formatDateFriendly(mealSheet.initDate!),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                sheetItemEdit(mealSheet.id.toString(), "Sahur",
                    mealSheet.sahur_time, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Breakfast",
                    mealSheet.bFastTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Lunch",
                    mealSheet.lunchTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Dinner",
                    mealSheet.dinnerTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Supper",
                    mealSheet.supperTime, mealSheetFilledCount),
                accomodationCardEdit(mealSheet.id.toString(), "Akomodasi",
                    mealSheet.accommodation, mealSheetFilledCount),
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     //Breakfast
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ),
              //     //Lunch
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ),
              //     //Dinner
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ), //Supper
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     )
              //   ],
              // )
            ],
          )),
    );
  }

  Widget sheetItemEdit(
      String record_id, String name, DateTime? time, int filledCount) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (time != null) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 115,
          height: 115,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: List.generate(
              5,
              (index) => BoxShadow(
                color: statusColor[0],
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: statusColor,
              begin: Alignment.bottomRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.fastfood_rounded,
                      color: Colors.white.withAlpha(200), size: 15),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              time != null
                  ? Row(
                      children: [
                        Text(
                          formatHourOnly(time),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Belum\nMengambil \n$name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
              time != null
                  ? Row(
                      children: [
                        Container(
                          width: 1,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatDateFriendly(time),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        time != null
            ? IconButton(
                onPressed: () {
                  _showDeleteConfirmation(
                    context,
                    record_id,
                    name,
                    filledCount,
                    () {
                      Navigator.of(context).pop();
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : SizedBox(
                height: 50,
              )
      ],
    );
  }

  Widget accomodationCardEdit(String record_id, String name,
      String? accommodationData, int filledCount) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (accommodationData != null) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 115,
          height: 115,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: List.generate(
              5,
              (index) => BoxShadow(
                color: statusColor[0],
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: statusColor,
              begin: Alignment.bottomRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.bed, color: Colors.white.withAlpha(200), size: 15),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              accommodationData != null
                  ? Row(
                      children: [
                        Text(
                          "Akomodasi\ntelah\nditambahkan",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Akomodasi\ntidak\nditambahkan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
              accommodationData != null
                  ? Row(
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        accommodationData != null
            ? IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Konfirmasi"),
                        content: Text(
                            "Apakah Anda yakin ingin menghapus data $name?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Tutup dialog tanpa menghapus
                            },
                            child: Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () async {
                              String status = await databaseHelperMealsheet
                                  .updateAccomodation(record_id, null);
                              if (status == "SUCCESS") {
                                showToast("Akomodasi Telah Dihapus");
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Ya, Hapus",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : IconButton(
                onPressed: () async {
                  String status = await databaseHelperMealsheet
                      .updateAccomodation(record_id, "YES");
                  if (status == "SUCCESS") {
                    showToast("Akomodasi Telah Ditambahkan");
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 25,
                ),
              )
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String record_id,
      String name, int filledCount, VoidCallback close) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin menghapus data $name?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog tanpa menghapus
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                String status = await databaseHelperMealsheet.clearOrDelete(
                    record_id, name, filledCount);
                if (status == "SUCCESS") {
                  Navigator.of(context).pop();
                  showToast("Data Telah Diupdate");
                  initData();

                  close();
                } else {
                  showToast(status);
                }
              },
              child: Text(
                "Ya, Hapus",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
