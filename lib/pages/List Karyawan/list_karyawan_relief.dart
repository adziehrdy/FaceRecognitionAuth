import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/widgets/personViewRelief.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';

import '../db/databse_helper_employee_relief.dart';

class ListKaryawanRelief extends StatefulWidget {
  const ListKaryawanRelief({Key? key}) : super(key: key);

  @override
  _ListKaryawanReliefState createState() => _ListKaryawanReliefState();
}

class _ListKaryawanReliefState extends State<ListKaryawanRelief> {
  DatabaseHelperEmployeeRelief _dataBaseHelper =
      DatabaseHelperEmployeeRelief.instance;
  List<User> user_list = [];
  List<bool> selected = [];
  String branchID = "";
  ReliefRepo repo = ReliefRepo();

  @override
  void initState() {
    // TODO: implement initState
    loadUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Karyawan Relief'),
        toolbarHeight: 35,
        centerTitle: true,
        actions: [
          Row(
            children: [
              // isLoked ? Icon(Icons.lock,color: Colors.grey,): Icon(Icons.lock_open,color: Colors.blue,),
              // SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(
                    context,
                    () {
                      setState(() async {
                        await repo.refreshEmployeeRelief(context);
                        loadUserData();
                      });
                    },
                  );
                },
                child: Row(children: [
                  Icon(Icons.refresh),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Update Karyawan Relief"),
                  SizedBox(
                    width: 10,
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),

            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            // Text("Daftar Karyawan"),
            Expanded(
                child: Stack(
              children: [
                PersonViewRelief(
                  personList: user_list,
                  onFinish: () {
                    loadUserData();
                  },
                  onUserSelected: (int) {
                    print(int.toString());
                    print(selected);
                  },
                  selected: [],
                  onShiftUpdated: () {
                    loadUserData();
                  },
                  // homePageState: this,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[],
                )
              ],
            )),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, Function() callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi',
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Anda yakin ingin memperbarui data karyawan Relief?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUserData() async {
    // selected = await refreshEmployeeRelief(context);
    user_list = await _dataBaseHelper.queryAllUsers();
    if (user_list.isEmpty) {
      // selected = await repo.refreshEmployeeRelief(context);
      // await refreshEmployee(context);
      // loadUserData();
    }
    print(user_list);
    setState(() {
      user_list;
    });
  }

  void _onUserSelected(int index) {
    setState(() {
      selected[index] = !selected[index];
    });
  }
}
