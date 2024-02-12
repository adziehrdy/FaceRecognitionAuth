import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/reliefModel.dart';
import 'package:face_net_authentication/pages/relief/relief_form.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';

class ReliefPage extends StatefulWidget {
  const ReliefPage({Key? key}) : super(key: key);

  @override
  _ReliefPageState createState() => _ReliefPageState();
}

class _ReliefPageState extends State<ReliefPage> {
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
          title: Text('Relief'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReliefForm()));
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
          itemCount: listRelief.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((listRelief[index].employeeName ?? "").toUpperCase(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                                      fontSize: 28,
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
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      Text("Status Relief : " +
                          (listRelief[index].statusRelief ?? "")),
                      Text("Deskripsi : " + (listRelief[index].desc ?? "")),
                      Text("Notes : " + (listRelief[index].note ?? "")),
                      Divider(),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                          ElevatedButton(
                             style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                              onPressed: () {}, child: 
                              Row(
                                children: [
                                  Icon(Icons.cancel,color: Colors.red.shade100,),
                                  SizedBox(width: 10,),
                                  Text("REJECT",style: TextStyle(color: Colors.red.shade100),),
                                ],
                              )
                              ),
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () {}, child: 
                              Row(
                                children: [
                                  Icon(Icons.check_circle),
                                  SizedBox(width: 10,),
                                  Text("APPROVE",style: TextStyle(color: Colors.white)),
                                ],
                              )
                              )
                        ],
                      )
                    ],
                  )),
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
      print(listRelief);
    });
  }
}
