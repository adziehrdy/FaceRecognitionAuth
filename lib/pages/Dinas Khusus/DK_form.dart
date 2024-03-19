import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/models/master_register_model.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/repo/DK_repo.dart';
import 'package:face_net_authentication/repo/relief_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DKForm extends StatefulWidget {
  const DKForm({Key? key}) : super(key: key);

  @override
  _DKFormState createState() => _DKFormState();
}

class _DKFormState extends State<DKForm> {
  // Controller untuk mengelola nilai dari TextInput
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController biayaDinasController = TextEditingController();

  // Variabel untuk menyimpan nilai dari Date dan Time Picker
  DateTime tanggalMulai = DateTime.now();
  DateTime tanggalSelesai = DateTime.now();

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
// String formattedValue = currencyFormat.format(int.parse(biayaDinasController.text));

  List<Employee> _approvalList = [];
  List<Division> _divisiList = [];
  List<Role> _roleList = [];
  bool _dataLoaded = false;
  String biaya = "0";

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

  // Method untuk menangani submit form
  Future<void> _showSummaryDialog() async {
    String superIntendentID = await getActiveSuperIntendentID();

    // Validasi nama TKJP

    if (pekerjaDropdownValue == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Nama TKJP tidak boleh kosong'),
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
                    'Tanggal Mulai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(formatDateOnly(tanggalMulai)),
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
                    'Deskripsi Dinas Khusus',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(deskripsiController.text),
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
                if(biayaDinasController.text.isNotEmpty){
                  biaya = biayaDinasController.text;
                }
                // Lakukan logika pengiriman data atau simpan ke database di sini
                // Format tanggal dan waktu untuk start_date dan end_date
                DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                String startDateFormatted = dateFormat.format(DateTime(
                  tanggalMulai.year,
                  tanggalMulai.month,
                  tanggalMulai.day,
                ));
                String endDateFormatted = dateFormat.format(DateTime(
                  tanggalSelesai.year,
                  tanggalSelesai.month,
                  tanggalSelesai.day,
                ));

                // Lakukan logika pengiriman data atau simpan ke database di sini
                print("Data yang dikirim:");
                print("Nama Pekerja: " +
                    pekerjaDropdownValue!.employee_id.toString());
                print("Tanggal Mulai: $tanggalMulai");

                print("Tanggal Selesai: $tanggalSelesai");

                print("Deskripsi Tugas: ${deskripsiController.text}");
                


                LoginModel user = await getUserLoginData();

                Map<String, dynamic> payload = {
                  "employee_id": pekerjaDropdownValue!.employee_id.toString(),
                  "branch_id" : user.branch!.branchId,
                  "from_date": startDateFormatted,
                  "to_date": endDateFormatted,
                  "desc": deskripsiController.text,
                  "amount": biaya,

                };
                print(payload);

                DKRepo repo = DKRepo();
                
                if(await repo.createDK(payload)){
                  Navigator.of(context).pop();
                 Navigator.of(context).pop();
                }

                // Lakukan pengiriman data atau simpan ke database di sini

                

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
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
                height: 50,
              ),
              Text("Form Dinas Khusus",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold, fontSize: 30),),
              SizedBox(
                height: 15,
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
                        Text(((pekerja.employee_name ?? "-").toUpperCase() +
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
                  SizedBox(width: 16.0),
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
                ],
              ),
              SizedBox(height: 16.0),

              // Date Picker dan Time Picker untuk Tanggal dan Jam Selesai

              // TextInput untuk Deskripsi Tugas
              TextFormField(
                controller: biayaDinasController,
                decoration: InputDecoration(
                  labelText: 'Biaya Dinas Khusus',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly,
                //   TextInputFormatter.withFunction((oldValue, newValue) {
                //     final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
                //     final newString = newValue.text
                //         .replaceAllMapped(regExp, (match) => '${match[1]},');
                //     return TextEditingValue(
                //       text: 'Rp. $newString',
                //       selection: TextSelection.collapsed(
                //           offset: 'Rp. $newString'.length),
                //     );
                //   }),
                // ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Dinas Khusus',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
             

              // TextInput untuk Catatan
              
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

  Future<void> _loadUserData() async {
    user_list = await _dataBaseHelper.queryAllUsers();
    // print(user_list);
    setState(() {});
  }
}
