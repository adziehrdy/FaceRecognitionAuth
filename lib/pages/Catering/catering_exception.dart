import 'package:face_net_authentication/db/database_helper_catering_exception.dart';
import 'package:face_net_authentication/db/databse_helper_employee.dart';
import 'package:face_net_authentication/models/catering_exception_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/repo/catering_exception_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../globals.dart';

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

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() async {
    listException = await repo.getAllCateringException();
    _employeeNamesForRequest = await getAllEmployeeAndRelief();
    // listException = await dbException.queryAllStatus();
    setState(() {
      _employeeNamesForRequest;
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
      body: ListView.builder(
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
                              listException[index].employee_name.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                            Text(formatDateString(listException[index].date))
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.orange,
                            ))
                      ],
                    )
                  ],
                )),
          );
        },
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
                if (_selectedEmployee == null || _selectedDate == null) {
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
        requester: getSup,
        status: "ACTIVE",
        date: tanggal,
        notes: notes);
    dbHelper.insert(data);

    repo.insertCatering(data);

    showToast("Karyawan Berhasil Ditambahkan");

    initData();
  }
}
