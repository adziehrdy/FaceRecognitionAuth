import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/reliefModel.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/relief/relief_form.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class ReliefPage extends StatefulWidget {
  const ReliefPage({Key? key}) : super(key: key);

  @override
  _ReliefPageState createState() => _ReliefPageState();
}

class _ReliefPageState extends State<ReliefPage> {
  List<ReliefModel> allListRelief = [];
  List<ReliefModel> ListReliefApproval = [];
  List<ReliefModel> ListReliefPending = [];
  int _currentIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      widgetListRelief(ListReliefApproval),
      widgetListRelief(ListReliefPending)
    ];
    getListRelief();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relief'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReliefForm()));
              getListRelief();
            },
            child: Row(children: [
              Icon(Icons.person_add),
              SizedBox(
                width: 10,
              ),
              Text("Ajukan Relief"),
              SizedBox(
                width: 10,
              ),
            ]),
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Permintaan Relief',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.outbox),
            label: 'Pengajuan Relief',
          ),
        ],
      ),

      // Card(
      //   child:
      //       Container(padding: EdgeInsets.all(10), child:
      //       Row(
      //         children: [
      //           Text("ADZIE HADI"),
      //         ],
      //       )
      //       ),
      // )
    );
  }

  Future getListRelief() async {
    LoginModel user_data = await getUserLoginData();
    String jsonRelief = await ReliefRepo().getReliefList();
    ListReliefApproval.clear();
    ListReliefPending.clear();
    final List<dynamic> parsedList = jsonDecode(jsonRelief);

    setState(() {
      allListRelief =
          parsedList.map((item) => ReliefModel.fromMap(item)).toList();

      for (var item in allListRelief) {
        if (item.toBranch == user_data.branch?.branchId) {
          ListReliefApproval.add(item);
        } else {
          ListReliefPending.add(item);
        }
      }
      _pages = [
        widgetListRelief(ListReliefApproval.reversed.toList()),
        widgetListReliefRequest(ListReliefPending.reversed.toList())
      ];
      print(allListRelief);
    });
  }
}

Widget widgetListRelief(List<ReliefModel> listRelief) {
  return listRelief.isEmpty
      ? emptyRelief()
      : ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: listRelief.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                elevation: 2,
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.swap_horizontal_circle_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                    (listRelief[index].employeeName ?? "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(
                              listRelief[index].relief_status_approve ??
                                  "BELUM DI APPROVE",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Rig Asal".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.green)),
                                Text(
                                    (listRelief[index].fromBranch ?? "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ],
                            ),
                            Icon(Icons.arrow_forward_outlined),
                            Column(
                              children: [
                                Text("Rig Tujuan".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.blue)),
                                Text(
                                    (listRelief[index].toBranch ?? "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ],
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Tanggal Mulai : " +
                        //           (formatDateOnly(
                        //               listRelief[index].reliefStartDate ??
                        //                   DateTime.now())),
                        //     ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text("Tanggal Selesai : " +
                        //         (formatDateOnly(
                        //             listRelief[index].reliefEndDate ??
                        //                 DateTime.now()))),
                        //   ],
                        // ),
                        // // Text("Status Relief : " +
                        // //     (listRelief[index].statusRelief ?? "")),
                        // Text("Deskripsi : " + (listRelief[index].desc ?? "")),
                        // Text("Notes : " + (listRelief[index].note ?? "")),
                        // Divider(),
                        SizedBox(
                          height: 5,
                        ),
                        // listRelief[index].relief_status_approve == null
                        //     ? Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceAround,
                        //         children: [
                        //           ElevatedButton(
                        //               style: ButtonStyle(
                        //                   backgroundColor:
                        //                       MaterialStatePropertyAll(
                        //                           Colors.red)),
                        //               onPressed: () async {
                        //                 await ReliefRepo().approveRelief(
                        //                     listRelief[index].reliefId ?? "-",
                        //                     "REJECT");
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Icon(
                        //                     Icons.cancel,
                        //                     color: Colors.red.shade100,
                        //                   ),
                        //                   SizedBox(
                        //                     width: 10,
                        //                   ),
                        //                   Text(
                        //                     "REJECT",
                        //                     style: TextStyle(
                        //                         color: Colors.red.shade100),
                        //                   ),
                        //                 ],
                        //               )),
                        //           ElevatedButton(
                        //               style: ButtonStyle(
                        //                   backgroundColor:
                        //                       MaterialStatePropertyAll(
                        //                           Colors.blue)),
                        //               onPressed: () async {
                        //                 await ReliefRepo().approveRelief(
                        //                     listRelief[index].reliefId ?? "-",
                        //                     "APPROVE");
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Icon(Icons.check_circle),
                        //                   SizedBox(
                        //                     width: 10,
                        //                   ),
                        //                   Text("APPROVE",
                        //                       style: TextStyle(
                        //                           color: Colors.white)),
                        //                 ],
                        //               ))
                        //         ],
                        //       )
                        //     : Text(
                        //         listRelief[index].relief_status_approve ?? "-")
                      ],
                    )),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: dialog_detail_relief(
                      data_relief: listRelief[index],
                      needApproval: true,
                    ));
                  },
                );
              },
            );
          },
        );
}

Widget widgetListReliefRequest(List<ReliefModel> listRelief) {
  return listRelief.isEmpty
      ? emptyRelief()
      : ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: listRelief.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                elevation: 2,
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            listRelief[index].relief_status_approve ??
                                "MENUNGGU APPROVAL",
                            style: TextStyle(
                                color:
                                    listRelief[index].relief_status_approve ==
                                            "APPROVED"
                                        ? Colors.green
                                        : (listRelief[index]
                                                    .relief_status_approve ==
                                                null
                                            ? Colors.orange
                                            : Colors.red)),
                          ),
                        ),
                        Divider(),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text("Status : APPROVE",
                        //             style: TextStyle(
                        //                 fontSize: 16, fontWeight: FontWeight.bold)),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: ((MediaQuery.of(context).size.width / 2) -
                                  50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("NAMA".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                  Text(
                                      (listRelief[index].employeeName ?? "")
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_outlined),
                            Container(
                              width: ((MediaQuery.of(context).size.width / 2) -
                                  50),
                              child: Column(
                                children: [
                                  Text("Rig Tujuan".toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black)),
                                  Text(
                                      (listRelief[index].toBranch ?? "")
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            )
                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "Tanggal Mulai : " +
                        //           (formatDateOnly(
                        //               listRelief[index].reliefStartDate ??
                        //                   DateTime.now())),
                        //     ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text("Tanggal Selesai : " +
                        //         (formatDateOnly(
                        //             listRelief[index].reliefEndDate ??
                        //                 DateTime.now()))),
                        //   ],
                        // ),
                        // // Text("Status Relief : " +
                        // //     (listRelief[index].statusRelief ?? "")),
                        // Text("Deskripsi : " + (listRelief[index].desc ?? "")),
                        // Text("Notes : " + (listRelief[index].note ?? "")),
                        // Divider(),
                        SizedBox(
                          height: 5,
                        ),

                        // listRelief[index].relief_status_approve == null
                        //     ? Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceAround,
                        //         children: [
                        //           ElevatedButton(
                        //               style: ButtonStyle(
                        //                   backgroundColor:
                        //                       MaterialStatePropertyAll(
                        //                           Colors.red)),
                        //               onPressed: () async {
                        //                 await ReliefRepo().approveRelief(
                        //                     listRelief[index].reliefId ?? "-",
                        //                     "REJECT");
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Icon(
                        //                     Icons.cancel,
                        //                     color: Colors.red.shade100,
                        //                   ),
                        //                   SizedBox(
                        //                     width: 10,
                        //                   ),
                        //                   Text(
                        //                     "REJECT",
                        //                     style: TextStyle(
                        //                         color: Colors.red.shade100),
                        //                   ),
                        //                 ],
                        //               )),
                        //           ElevatedButton(
                        //               style: ButtonStyle(
                        //                   backgroundColor:
                        //                       MaterialStatePropertyAll(
                        //                           Colors.blue)),
                        //               onPressed: () async {
                        //                 await ReliefRepo().approveRelief(
                        //                     listRelief[index].reliefId ?? "-",
                        //                     "APPROVE");
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Icon(Icons.check_circle),
                        //                   SizedBox(
                        //                     width: 10,
                        //                   ),
                        //                   Text("APPROVE",
                        //                       style: TextStyle(
                        //                           color: Colors.white)),
                        //                 ],
                        //               ))
                        //         ],
                        //       )
                        //     : Text(
                        //         listRelief[index].relief_status_approve ?? "-")
                      ],
                    )),
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: dialog_detail_relief(
                      data_relief: listRelief[index],
                      needApproval: false,
                    ));
                  },
                );
              },
            );
          },
        );
}

class dialog_detail_relief extends StatelessWidget {
  const dialog_detail_relief({
    super.key,
    required this.data_relief,
    required this.needApproval,
  });

  final ReliefModel data_relief;
  final bool needApproval;

  @override
  Widget build(BuildContext context) {
    final ReliefRepo repo = ReliefRepo();
    return Container(
      width: double.maxFinite,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.swap_horizontal_circle_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text((data_relief.employeeName ?? "").toUpperCase(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                Center(
                  heightFactor: 1.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Rig Asal".toUpperCase(),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          Text((data_relief.fromBranch ?? "").toUpperCase(),
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ],
                      ),
                      Icon(Icons.arrow_forward_outlined),
                      Column(
                        children: [
                          Text("Rig Tujuan".toUpperCase(),
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          Text((data_relief.toBranch ?? "").toUpperCase(),
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Text(
                  "Nama",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  (data_relief.employeeName ?? "").toUpperCase(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Mulai",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          (formatDateOnly(
                              data_relief.reliefStartDate ?? DateTime.now())),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Selesai",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          (formatDateOnly(
                              data_relief.reliefEndDate ?? DateTime.now())),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deskripsi Tugas",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  data_relief.desc ?? "-",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Catatan",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  data_relief.note ?? "-",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                needApproval
                    ? (data_relief.relief_status_approve == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                  onPressed: () async {
                                    var result = await ReliefRepo()
                                        .approveRelief(
                                            data_relief.reliefId ?? "-",
                                            "REJECTED");
                                    if (result != []) {
                                      showToast("Relief Berhasil di reject");
                                      await repo.refreshEmployeeRelief(context);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      showToast("Relief gagal di reject");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red.shade100,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "REJECT",
                                        style: TextStyle(
                                            color: Colors.red.shade100),
                                      ),
                                    ],
                                  )),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.blue)),
                                  onPressed: () async {
                                    var result = await ReliefRepo()
                                        .approveRelief(
                                            data_relief.reliefId ?? "-",
                                            "APPROVED");
                                    if (result != []) {
                                      showToast("Relief Berhasil di Approve");
                                      await repo.refreshEmployeeRelief(context);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      showToast("Relief gagal di Approve");
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("APPROVE",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ))
                            ],
                          )
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                  "STATUS",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data_relief.relief_status_approve ?? "-",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ))
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              "STATUS",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            data_relief.relief_status_approve == null
                                ? Text(
                                    "MENUNGGU APPROVAL",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    data_relief.relief_status_approve ?? "-",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )
                          ],
                        ),
                      )
              ])),
    );
  }
}

Widget emptyRelief() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
            textAlign: TextAlign.center,
            "Permintaan Relief",
            style: TextStyle(
                fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
        Lottie.asset(
          'assets/lottie/nodata.json',
          width: 300,
          height: 300,
          fit: BoxFit.fill,
        ),
        Text(
            textAlign: TextAlign.center,
            "Tidak Ada Permintaan Relief",
            style: TextStyle(fontSize: 15)),
      ],
    ),
  );
}
