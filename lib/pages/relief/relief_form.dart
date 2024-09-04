import 'dart:convert';
import 'dart:developer';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/master_register_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/databse_helper_employee.dart';

class ReliefForm extends StatefulWidget {
  const ReliefForm({Key? key}) : super(key: key);

  @override
  _ReliefFormState createState() => _ReliefFormState();
}

class _ReliefFormState extends State<ReliefForm> {
  // Controller untuk mengelola nilai dari TextInput
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

  // Variabel untuk menyimpan nilai dari Date dan Time Picker
  DateTime tanggalMulai = DateTime.now();
  TimeOfDay jamMulai = TimeOfDay(hour: 0, minute: 0);
  DateTime tanggalSelesai = DateTime.now();
  TimeOfDay jamSelesai = TimeOfDay(hour: 0, minute: 0);

  master_register_model? master_data;

  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  List<User> user_list = [];

  // Daftar pekerja dan rig tujuan
  List<String> daftarRigTujuan = [];

  // Method untuk menampilkan DatePicker
  Future<void> _selectDate(
      BuildContext context, bool isStartDate, String title) async {
    DateTime? selectedDate = await showDatePicker(
      helpText: title,
      context: context,
      initialDate: isStartDate ? tanggalMulai : tanggalSelesai,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null &&
        selectedDate != (isStartDate ? tanggalMulai : tanggalSelesai)) {
      setState(() {
        if (isStartDate) {
          tanggalMulai = selectedDate;
        } else {
          tanggalSelesai = selectedDate;
        }
      });
    }
  }

  // Method untuk menampilkan TimePicker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? jamMulai : jamSelesai,
    );

    if (selectedTime != null &&
        selectedTime != (isStartTime ? jamMulai : jamSelesai)) {
      setState(() {
        if (isStartTime) {
          jamMulai = selectedTime;
        } else {
          jamSelesai = selectedTime;
        }
      });
    }
  }

  // Method untuk menangani submit form
  Future<void> _showSummaryDialog() async {
    // Validasi nama TKJP
    if (pekerjaDropdownValue == null || rigTujuanDropdownValue == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Nama TKJP dan Rig Tujuan tidak boleh kosong'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apakah Data Sudah Benar ?'),
          content: SingleChildScrollView(
              child: Container(
            width: 500,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Nama Pekerja',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(pekerjaDropdownValue!.employee_name ?? "-"),
                ),
                ListTile(
                  title: Text(
                    'Rig Tujuan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(rigTujuanDropdownValue ?? "-"),
                ),
                ListTile(
                  title: Text(
                    'Tanggal Mulai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(formatDateOnly(tanggalMulai)),
                ),
                ListTile(
                  title: Text(
                    'Jam Mulai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${jamMulai.format(context)}"),
                ),
                ListTile(
                  title: Text(
                    'Tanggal Selesai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(formatDateOnly(tanggalSelesai)),
                ),
                ListTile(
                  title: Text(
                    'Jam Selesai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${jamSelesai.format(context)}"),
                ),
                ListTile(
                  title: Text(
                    'Deskripsi Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(deskripsiController.text),
                ),
                ListTile(
                  title: Text(
                    'Catatan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(catatanController.text),
                ),
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Lakukan logika pengiriman data atau simpan ke database di sini
                // Format tanggal dan waktu untuk start_date dan end_date
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                String startDateFormatted = dateFormat.format(DateTime(
                    tanggalMulai.year,
                    tanggalMulai.month,
                    tanggalMulai.day,
                    jamMulai.hour,
                    jamMulai.minute));
                String endDateFormatted = dateFormat.format(DateTime(
                    tanggalSelesai.year,
                    tanggalSelesai.month,
                    tanggalSelesai.day,
                    jamSelesai.hour,
                    jamSelesai.minute));

                // Lakukan logika pengiriman data atau simpan ke database di sini
                print("Data yang dikirim:");
                print("Nama Pekerja: " +
                    pekerjaDropdownValue!.employee_id.toString());
                print("Rig Tujuan: ${rigTujuanDropdownValue}");
                print("Tanggal Mulai: $tanggalMulai");
                print("Jam Mulai: $jamMulai");
                print("Tanggal Selesai: $tanggalSelesai");
                print("Jam Selesai: $jamSelesai");
                print("Deskripsi Tugas: ${deskripsiController.text}");
                print("Catatan: ${catatanController.text}");

                Map<String, dynamic> payload = {
                  "employee_id": pekerjaDropdownValue!.employee_id.toString(),
                  "start_date": startDateFormatted,
                  "end_date": endDateFormatted,
                  "desc": deskripsiController.text,
                  "note": catatanController.text,
                  "total_days":
                      tanggalSelesai.difference(tanggalMulai).inDays + 1,
                  "to_branch": rigTujuanDropdownValue
                };
                print(payload);

                ReliefRepo repo = ReliefRepo();
                await repo.hitFormRelief(payload);

                // Lakukan pengiriman data atau simpan ke database di sini

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Nilai default untuk dropdown
  User? pekerjaDropdownValue;
  String? rigTujuanDropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
    hitGetMasterRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   surfaceTintColor: Colors.blue,
      //   titleTextStyle: TextStyle(fontSize: 18),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   title: Text('Form Pengajuan Relief'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Nama TKJP"),
              // Dropdown untuk Nama Pekerja
              DropdownButtonFormField<User>(
                value: pekerjaDropdownValue,
                hint: Text('Pilih TKJP'),
                onChanged: (newValue) {
                  setState(() {
                    pekerjaDropdownValue = newValue;
                  });
                },
                items: user_list.map((User pekerja) {
                  return DropdownMenuItem<User>(
                    value: pekerja,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(((pekerja.employee_name ?? "-") +
                            " - (" +
                            (pekerja.employee_id ?? "-") +
                            ")")),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),

              // Dropdown untuk Rig Tujuan
              Text("RIG Tujuan"),
              DropdownButtonFormField<String>(
                value: rigTujuanDropdownValue,
                hint: Text('Pilih Rig Tujuan'),
                onChanged: (String? newValue) {
                  setState(() {
                    rigTujuanDropdownValue = newValue;
                  });
                },
                items: daftarRigTujuan.map((String rigTujuan) {
                  return DropdownMenuItem<String>(
                    value: rigTujuan,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(rigTujuan),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),

              // Date Picker dan Time Picker untuk Tanggal dan Jam Mulai
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true, "Tanggal Mulai"),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Mulai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          formatDateOnly(tanggalMulai),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 16.0),
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () => _selectTime(context, true),
                  //     child: InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Jam Mulai',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       child: Text(
                  //         "${jamMulai.format(context)}",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 16.0),

              // Date Picker dan Time Picker untuk Tanggal dan Jam Selesai
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          _selectDate(context, false, "Tanggal Selesai"),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Selesai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          formatDateOnly(tanggalSelesai),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 16.0),
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () => _selectTime(context, false),
                  //     child: InputDecorator(
                  //       decoration: InputDecoration(
                  //         labelText: 'Jam Selesai',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       child: Text(
                  //         "${jamSelesai.format(context)}",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 16.0),

              // TextInput untuk Deskripsi Tugas
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),

              // TextInput untuk Catatan
              TextFormField(
                controller: catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 32.0),

              // Tombol Submit
              ElevatedButton(
                onPressed: _showSummaryDialog,
                child: Text('Submit'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> hitGetMasterRegister() async {
    String? data = await GlobalRepo().getMasterRegister();
    String rigAsal = await getBranchID();

    setState(() {
      if (data != null) {
        log(json.decode(data).toString());
        master_data = master_register_model.fromJson(json.decode(data));
        log(json.decode(data).toString());
        // _divisiList = master_data!.data.division;
        // _roleList = master_data!.data.role;

        getUserLoginData().then((device_data) {
          setState(() {
            for (Location lokasi in master_data!.data!.location) {
              // _lokasiList.add(Location(
              // branchId: device_data.branch?.branchId ?? "",
              // branchName: device_data.branch?.branchName ?? "",
              if (lokasi.branchId != rigAsal) {
                daftarRigTujuan.add(
                  lokasi.branchId ?? "-",
                );
              }
            }
          });
        });
      }
    });
  }

  Future<void> _loadUserData() async {
    user_list = await _dataBaseHelper.queryAllUsers();
    // print(user_list);
    setState(() {});
  }
}
