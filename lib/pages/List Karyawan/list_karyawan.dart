import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/widgets/personview.dart';
import 'package:flutter/material.dart';

import '../db/databse_helper_employee.dart';

class ListKaryawan extends StatefulWidget {
  const ListKaryawan({Key? key}) : super(key: key);

  @override
  _ListKaryawanState createState() => _ListKaryawanState();
}

class _ListKaryawanState extends State<ListKaryawan> {
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  List<User> user_list = [];
  List<bool> selected = [];
  String branchID = "";

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
        title: const Text('Daftar Karyawan'),
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
                    () async {
                      await refreshEmployee(context);
                      loadUserData();
                    },
                  );
                },
                child: Row(children: [
                  Icon(Icons.refresh),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Update Karyawan"),
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
                PersonView(
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
                Text('Anda yakin ingin memperbarui data karyawan?'),
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
    user_list = await _dataBaseHelper.queryAllUsers();
    if (user_list.isEmpty) {
      // await refreshEmployee(context);
      // loadUserData();
    }
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
