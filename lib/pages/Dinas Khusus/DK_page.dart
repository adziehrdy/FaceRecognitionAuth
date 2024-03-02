import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/reliefModel.dart';
import 'package:face_net_authentication/pages/Dinas%20Khusus/DK_form.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';

class DKPage extends StatefulWidget {
  const DKPage({Key? key}) : super(key: key);

  @override
  _DKPageState createState() => _DKPageState();
}

class _DKPageState extends State<DKPage> {
  List<ReliefModel> listRelief = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListRelief();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dinas Khusus'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DKForm()));
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

            ListView.builder(
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
                          children: [
                            Icon(Icons.swap_horizontal_circle_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                (listRelief[index].employeeName ?? "")
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
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
                                        fontSize: 11, color: Colors.red)),
                                Text(
                                    (listRelief[index].fromBranch ?? "")
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Tanggal Mulai : " +
                                  (formatDateOnly(
                                      listRelief[index].reliefStartDate ??
                                          DateTime.now())),
                            ),
                            Text("Tanggal Selesai : " +
                                (formatDateOnly(
                                    listRelief[index].reliefEndDate ??
                                        DateTime.now()))),
                          ],
                        ),
                        // Text("Status Relief : " +
                        //     (listRelief[index].statusRelief ?? "")),
                        Text("Deskripsi : " + (listRelief[index].desc ?? "")),
                        Text("Notes : " + (listRelief[index].note ?? "")),
                        Divider(),
                        SizedBox(
                          height: 5,
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
                                      style:
                                          TextStyle(color: Colors.red.shade100),
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
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: dialog_detail_relief(
                            data_relief: listRelief[index]));
                  },
                );
              },
            );
          },
        ));
  }

  Future getListRelief() async {
    String jsonRelief = await ReliefRepo().getReliefList();
    final List<dynamic> parsedList = jsonDecode(jsonRelief);
    setState(() {
      listRelief = parsedList.map((item) => ReliefModel.fromMap(item)).toList();
      print(listRelief);
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
                  SizedBox(width: 10,),
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

              // Text("Status Relief : " +
              //     (listRelief[index].statusRelief ?? "")),
              // Text("Deskripsi : " + (data_relief.desc ?? "")),
              // Text("Notes : " + (data_relief.note ?? "")),
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
