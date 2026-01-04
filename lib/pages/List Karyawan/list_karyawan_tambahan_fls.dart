import 'dart:convert';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/widgets/personViewRelief.dart';
import 'package:face_net_authentication/pages/widgets/personViewTambahanFLS.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';

import '../db/databse_helper_employee_relief.dart';

class ListKaryawanTambahanFLS extends StatefulWidget {
  const ListKaryawanTambahanFLS({Key? key}) : super(key: key);

  @override
  _ListKaryawanTambahanFLSState createState() =>
      _ListKaryawanTambahanFLSState();
}

class _ListKaryawanTambahanFLSState extends State<ListKaryawanTambahanFLS> {
  DatabaseHelperEmployeeRelief _dataBaseHelperRelief =
      DatabaseHelperEmployeeRelief.instance;
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
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
        title: const Text('Daftar Karyawan Tambahan'),
        toolbarHeight: 35,
        centerTitle: false,
        actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  showSearchKaryawan(
                    context,
                    () {
                      setState(() async {
                        loadUserData();
                      });
                    },
                  );
                },
                child: Row(children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Tambah Karyawan"),
                  SizedBox(
                    width: 10,
                  ),
                ]),
              ),
              // isLoked ? Icon(Icons.lock,color: Colors.grey,): Icon(Icons.lock_open,color: Colors.blue,),
              // SizedBox(width: 15),
              // ElevatedButton(
              //   onPressed: () {
              //     showConfirmationDialog(
              //       context,
              //       () {
              //         setState(() async {
              //           await repo.refreshEmployeeRelief(context);
              //           loadUserData();
              //         });
              //       },
              //     );
              //   },
              //   child: Row(children: [
              //     Icon(Icons.refresh),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Text("Update data"),
              //     SizedBox(
              //       width: 10,
              //     ),
              //   ]),
              // ),
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
                PersonViewTambahanFLS(
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
                Text('Anda yakin ingin memperbarui data karyawan Tambahan?'),
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

  Future<void> showSearchKaryawan(
      BuildContext context, Function() callback) async {
    TextEditingController nikController = TextEditingController();
    User? foundUser;
    bool isLoading = false;
    String errorMsg = "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Cari Karyawan",
                style: TextStyle(fontSize: 12),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (foundUser == null) ...[
                      TextField(
                        controller: nikController,
                        decoration: const InputDecoration(
                          labelText: "NIP",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    if (isLoading) const CircularProgressIndicator(),
                    if (errorMsg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorMsg,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (foundUser != null) ...[
                      contentBox(context, foundUser!),
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () => Navigator.of(context).pop(),
                ),

                /// BUTTON CARI
                if (foundUser == null)
                  ElevatedButton(
                    child: const Text("Cari"),
                    onPressed: () async {
                      if (nikController.text.isEmpty) return;

                      setDialogState(() {
                        isLoading = true;
                        errorMsg = "";
                      });

                      try {
                        final user = await GlobalRepo()
                            .getKaryawanTambahanFLS(nikController.text);

                        setDialogState(() {
                          foundUser = user;
                          isLoading = false;
                          if (user == null) {
                            errorMsg = "Karyawan tidak ditemukan";
                          }
                        });
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorMsg = "Terjadi kesalahan";
                        });
                      }
                    },
                  ),

                if (foundUser != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah"),
                    onPressed: () async {
                      bool exists = await checkCrewTambahanIsExist(
                          foundUser!.employee_id!);
                      if (exists) {
                        showToast("Karyawan ini sudah ada di list Karyawan");
                      } else {
                        try {
                          final DateTime now = DateTime.now();

                          // Relief start = hari ini
                          final String reliefStartDate =
                              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                          // Relief end = 1 tahun dari hari ini
                          final DateTime twoYearLater =
                              DateTime(now.year + 2, now.month, now.day);

                          final String reliefEndDate =
                              "${twoYearLater.year}-${twoYearLater.month.toString().padLeft(2, '0')}-${twoYearLater.day.toString().padLeft(2, '0')}";

                          foundUser!.relief_start_date = reliefStartDate;
                          foundUser!.relief_end_date = reliefEndDate;
                          foundUser!.is_relief_employee = "1";

                          // ⏳ Insert ke database
                          await _dataBaseHelperRelief.insert(foundUser!);

                          // ✅ Feedback sukses
                          showToast("Karyawan berhasil ditambahkan");
                          loadUserData();

                          // 🔙 Kembali ke halaman sebelumnya
                          Navigator.of(context).pop(true);
                        } catch (e, s) {
                          debugPrint("Insert karyawan gagal: $e");
                          debugPrintStack(stackTrace: s);

                          showToast("Gagal menambahkan karyawan");
                        }
                      }
                    },
                  )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> loadUserData() async {
    // selected = await refreshEmployeeRelief(context);
    user_list = await _dataBaseHelperRelief.queryAllUsers();
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

  contentBox(context, User user_detail) {
    return SingleChildScrollView(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 10),
              blurRadius: 100,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 15),
            Container(
              height: 150,
              width: 150,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: checkFrPhoto(user_detail.employee_fr_image),
              ),
            ),
            SizedBox(height: 10),
            Text(
              (user_detail.employee_name ?? "-").toUpperCase(),
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            Divider(),
            Text(
              (user_detail.employee_position ?? "-"),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            Divider(),
            Text(
              (user_detail.employee_id ?? "-") +
                  " - RIG ASAL = " +
                  (user_detail.branch_id ?? "-"),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkCrewTambahanIsExist(String employeeId) async {
    try {
      final bool existInRelief =
          await _dataBaseHelperRelief.isExistingInDB(employeeId);

      if (existInRelief) return true;

      final bool existInMain = await _dataBaseHelper.isExistingInDB(employeeId);

      return existInMain;
    } catch (e) {
      debugPrint("checkCrewTambahanIsExist error: $e");
      return false;
    }
  }
}
