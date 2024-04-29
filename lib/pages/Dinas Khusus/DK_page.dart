import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/dk_list_model.dart';
import 'package:face_net_authentication/models/reliefModel.dart';
import 'package:face_net_authentication/pages/Dinas%20Khusus/DK_form.dart';
import 'package:face_net_authentication/pages/widgets/pin_input_dialog.dart';
import 'package:face_net_authentication/repo/DK_repo.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DKPage extends StatefulWidget {
  const DKPage({Key? key}) : super(key: key);

  @override
  _DKPageState createState() => _DKPageState();
}

class _DKPageState extends State<DKPage> {
  List<DK_data> listDK = [];

  @override
  void initState() {
    // TODO: implement initState
    // refreshEmployee(context);

    super.initState();
    getListDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dinas Khusus'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DKForm()))
                    .then((value) {
                  getListDK();
                });
              },
              child: Row(children: [
                Icon(Icons.person_add),
                SizedBox(
                  width: 10,
                ),
                Text("Ajukan Dinas Khusus"),
                SizedBox(
                  width: 10,
                ),
              ]),
            )
          ],
        ),
        body:
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

            listDK.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            textAlign: TextAlign.center,
                            "Dinas Khusus Kosong",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        Lottie.asset(
                          'assets/lottie/no_data.json',
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                        Text(
                            textAlign: TextAlign.center,
                            "Untuk Menambahkan Dinas Khusus, Pilih 'Ajukan Dinas Khusus'\n pada pojok kanan atas.",
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: listDK.length,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.badge),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              (listDK[index].employee_name ??
                                                      "")
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      (listDK[index].status ?? "") != ""
                                          ? Row(
                                              children: [
                                                Icon(Icons.check),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  listDK[index].status,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ],
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  Divider(),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Tanggal Mulai : " +
                                            (formatDateOnly(
                                                listDK[index].fromDate ??
                                                    DateTime.now())),
                                      ),
                                      Icon(
                                        Icons.arrow_right_rounded,
                                        color: Colors.blue,
                                      ),
                                      Text("Tanggal Selesai : " +
                                          (formatDateOnly(
                                              listDK[index].toDate ??
                                                  DateTime.now()))),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.date_range,
                                  //       color: Colors.blue,
                                  //     ),
                                  //     SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     Text("Tanggal Selesai : " +
                                  //         (formatDateOnly(
                                  //             listDK[index].toDate ?? DateTime.now()))),
                                  //   ],
                                  // ),

                                  // Text("Status Relief : " +
                                  //     (listRelief[index].statusRelief ?? "")),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Biaya : " +
                                          formatRupiah((int.parse(
                                              listDK[index].amount ?? "0")))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.note_alt_sharp,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Deskripsi : " +
                                          (listDK[index].desc ?? "")),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  (listDK[index].status ?? "") != ""
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.red)),
                                                onPressed: () async {
                                                  await _approval(
                                                      listDK[index]
                                                          .id
                                                          .toString(),
                                                      "REJECT");
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.cancel,
                                                      color:
                                                          Colors.red.shade100,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "REJECT",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade100),
                                                    ),
                                                  ],
                                                )),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blue)),
                                                onPressed: () async {
                                                  await _approval(
                                                      listDK[index]
                                                          .id
                                                          .toString(),
                                                      "APPROVE");
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.check_circle),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("APPROVE",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ))
                                          ],
                                        )
                                ],
                              )),
                        ),
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //         content: dialog_detail_relief(
                          //             data_relief: listDK[index]));
                          //   },
                          // );
                        },
                      );
                    },
                  ));
  }

  Future<void> _approval(String id, String type) async {
    PinInputDialog.show(context, (p0) async {
      String id_rigsub = await getActiveSuperIntendentID();
      Map<String, dynamic> payload = {
        "status": type,
        "approval": id_rigsub,
      };

      bool result = await DKRepo().approvalDK(id, payload);
      if (result == true) {
        await refreshEmployee(context);
        showToast("Dinas Khusus telah di " + type);
        getListDK();
      } else {
        showToast("Kesalahan Pada Saat Approval");
      }
    });
  }

  Future getListDK() async {
    String jsonRelief = await DKRepo().getListDK();

    setState(() {
      DkListModel dk = dkListModelFromJson(jsonRelief);
      listDK = dk.data!;
      listDK = listDK.reversed.toList();
      print(listDK);
    });
  }
}

class dialog_detail_relief extends StatelessWidget {
  const dialog_detail_relief({
    super.key,
    required this.data_relief,
  });

  final ReliefModel data_relief;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.swap_horizontal_circle_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text((data_relief.employeeName ?? "").toUpperCase(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () {},
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
                            style: TextStyle(color: Colors.red.shade100),
                          ),
                        ],
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue)),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(
                            width: 10,
                          ),
                          Text("APPROVE",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ))
                ],
              )
            ],
          )),
    );
  }
}
