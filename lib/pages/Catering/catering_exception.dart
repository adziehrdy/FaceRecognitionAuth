import 'package:face_net_authentication/db/database_helper_catering_exception.dart';
import 'package:face_net_authentication/models/catering_exception_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/repo/catering_exception_repo.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';
import '../../models/model_rig_shift.dart';
import '../../services/shared_preference_helper.dart';

class CateringException extends StatefulWidget {
  const CateringException({Key? key}) : super(key: key);

  @override
  _CateringExceptionState createState() => _CateringExceptionState();
}

class _CateringExceptionState extends State<CateringException> {
  List<User> _employeeNamesForRequest = [];
  List<catering_exception_model> listException = [];
  DatabaseHelperCateringException dbException =
      DatabaseHelperCateringException.instance;

  CateringExceptionRepo repo = CateringExceptionRepo();

  TextEditingController _notesController = TextEditingController();

  RigStatusShift? brachStatus;
  String? selectedShift;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _employeeNamesForRequest = await getAllEmployeeAndRelief();

    // await repo.insertCatering(catering_exception_model(
    //     branchId: "ICTDEV",
    //     shift: "XX",
    //     employee_id: "9999",
    //     employee_name: "ADZIE",
    //     requester: "029",
    //     status: "TIDAK AKRIF",
    //     date: "2024-05-24 00:00:00",
    //     note: "TEST123"));
    loadLocalData();
    // listException = await dbException.queryAllStatus();
    brachStatus = await SpGetSelectedStatusRig();
    // setState(() {
    //   listException;
    // });
    dbSync();
  }

  loadLocalData() async {
    listException = await dbException.queryAllStatus();
    setState(() {
      listException;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tidak Mengambil Catering"),
        actions: [
          ElevatedButton(
              onPressed: () {
                _showAddEmployeeDialog(context);
              },
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Tambah Karyawan"),
                ],
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: listException.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.food_bank_outlined,
                            size: 25,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listException[index]
                                        .employee_name
                                        .toUpperCase() +
                                    " | " +
                                    (listException[index].api_key ?? "-"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue),
                              ),
                              Row(
                                children: [
                                  Text(formatDateString(
                                      listException[index].date)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("|"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(listException[index].shift ?? "-"),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Konfirmasi"),
                                      content: Text(
                                          "Apakah Anda Yakin Ingin Menghapus Data ?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await dbException.softDelete(
                                                listException[index]);
                                            initData();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Ya",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Tidak"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: Colors.orange,
                              )),
                        ],
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        User? _selectedEmployee = null;
        DateTime? _selectedDate = null;
        return AlertDialog(
          title: Text("Tambah Karyawan"),
          content: Container(
            height: 350, // Adjusted height to accommodate notes field
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<User>(
                  decoration: InputDecoration(labelText: "Nama Karyawan"),
                  items: _employeeNamesForRequest.map((User user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.employee_name?.toUpperCase() ?? "-"),
                    );
                  }).toList(),
                  onChanged: (User? newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Shift"),
                  items: brachStatus!.shift!.map((ShiftRig shift) {
                    return DropdownMenuItem<String>(
                      value: shift.id,
                      child: Text(shift.id ?? "-"),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedShift = newValue ?? "-";
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: "Tanggal"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _selectedDate = pickedDate;
                      setState(() {
                        _selectedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd').format(_selectedDate),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: "Catatan"),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedEmployee == null ||
                    _selectedDate == null ||
                    selectedShift == null) {
                  showToast("Nama Atau Tanggal Tidak Boleh Kosong");
                } else {
                  // Save action jika karyawan dan tanggal sudah dipilih
                  insertDB(_selectedEmployee!, formatDateTime(_selectedDate!),
                      _notesController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  insertDB(User user, String tanggal, String notes) async {
    DatabaseHelperCateringException dbHelper =
        DatabaseHelperCateringException.instance;
    String branch_id = await getBranchID();
    String getSup = await getActiveSuperIntendentID();

    catering_exception_model data = catering_exception_model(
        branchId: branch_id,
        employee_id: user.employee_id ?? "-",
        employee_name: user.employee_name ?? "-",
        requester_id: getSup,
        status: "ACTIVE",
        date: tanggal,
        note: notes,
        shift: selectedShift!);
    dbHelper.insert(data);

    // repo.insertCatering(data);

    showToast("Karyawan Berhasil Ditambahkan");

    initData();
  }

  dbSync() async {
    bool connection = await onLineChecker();

    if (connection) {
      List<catering_exception_model> listDelete =
          await dbException.getAllSoftDelete();
      try {
        for (catering_exception_model singleDelete in listDelete) {
          if (await repo.delete(singleDelete) != []) {
            dbException.delete(singleDelete);
          } else {
            throw Exception();
          }
        }

        dbException.insertAll(await repo.getAllCateringException());

        loadLocalData();
      } catch (e) {}
    }
  }
}
