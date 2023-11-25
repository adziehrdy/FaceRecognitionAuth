import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/form_registrasi_karyawan.dart';
import 'package:face_net_authentication/pages/models/login_model.dart';
import 'package:face_net_authentication/pages/models/user.dart';
import 'package:face_net_authentication/pages/widgets/personview.dart';
import 'package:face_net_authentication/repo/user_repos.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ListKaryawan extends StatefulWidget {
  const ListKaryawan({Key? key}) : super(key: key);

  @override
  _ListKaryawanState createState() => _ListKaryawanState();
}

class _ListKaryawanState extends State<ListKaryawan> {
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  List<User> user_list = [];
  String branchID = "";

  @override
  void initState() {
    // TODO: implement initState
    _loadUserData();

    getUserLogin();
    super.initState();
  }

  Future<void> getUserLogin() async {
    LoginModel loginData = await getUserLoginData();
      branchID = loginData.branch!.branchId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Karyawan'),
        toolbarHeight: 70,
        centerTitle: true,
        actions: [PopupMenuButton(
          itemBuilder: (context){
            return [
                  // PopupMenuItem<int>(
                  //     value: 0,
                  //     child: Row(children: [Icon(Icons.person_add,color: Colors.black,),SizedBox(width: 15,),Text("Registrasi Karyawan Baru")],),
                  // ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(children: [Icon(Icons.sync,color: Colors.black,),SizedBox(width: 15,),Text("Update Ulang Data Karyawan")],),
                  ),

              ];
          },
          onSelected:(value){
            if(value == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FormRegistrasiKaryawan(),));
            }else if(value == 1){
              showConfirmationDialog(context,() {
                refreshEmployee(context);
                
              },);
            }

          }
        ),],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       flex: 1,
            //       child: ElevatedButton.icon(
            //         label: const Text('Update ulang data karyawan'),
            //         icon: const Icon(
            //           Icons.person_add,
            //           // color: Colors.white70,
            //         ),
            //         style: ElevatedButton.styleFrom(
            //             padding: const EdgeInsets.only(top: 10, bottom: 10),
            //             // foregroundColor: Colors.white70,
            //             backgroundColor:
            //                 Theme.of(context).colorScheme.primaryContainer,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //             )),
            //         onPressed: () {
            //           showConfirmationDialog(context);
            //         },
            //         // onPressed: () {

            //         // },
            //       ),
            //     ),
            //     const SizedBox(width: 20),
            //   ],
            // ),
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
                  personList: user_list, onFinish: () { 
                    _loadUserData();
                   },
                  // homePageState: this,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  ],
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


  Future<void> showConfirmationDialog(BuildContext context, Function() callback) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi',style: TextStyle(color: Colors.red),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Anda yakin ingin memperbarui data karyawan? data wajah sebelumnya akan terhapus'),
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
            child: Text('Ya',style :TextStyle(color: Colors.red)),
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

  Future<void> refreshEmployee(BuildContext context) async {
    UserRepo userRepo = UserRepo();
    ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Fetching data...');
    String? jsonKaryawan = await userRepo.apiGetAllEmployeeByBranch(branchID).onError((error, stackTrace) {
      progressDialog.close();
    });

    if (jsonKaryawan != null) {
    // jsonKaryawan = DummyJson;
      print(jsonKaryawan);
      try {
        List<dynamic> jsonDataList = jsonDecode(jsonKaryawan);

        user_list.clear();
        _dataBaseHelper.deleteAll();

        int totalItems = jsonDataList.length;
        int processedItems = 0;

        try {
          for (var jsonData in jsonDataList) {
            var person = User.fromMap(jsonData);
            await _dataBaseHelper.insert(person);

            processedItems++;
            progressDialog.update(
              value: ((processedItems / totalItems) * 100).toInt(),
              msg: 'Fetching data... ($processedItems/$totalItems)',
            );
          }
        } catch (e) {
          await _dataBaseHelper.deleteAll();
          print(e.toString());
        }

        await _loadUserData();

      } catch (e) {
        print(e); progressDialog.close();

      } finally {
        progressDialog.close();
      }
    } else {
      showToast('Terjadi kesalahan saat mengambil data karyawan');
       progressDialog.close();
    }

  }

  Future<void> _loadUserData() async {
  user_list = await _dataBaseHelper.queryAllUsers();
  // print(user_list);
  setState(() {});
}
}
