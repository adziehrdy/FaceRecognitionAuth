import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/models/user.dart';
import 'package:flutter/material.dart';

class ReliefForm extends StatefulWidget {
  const ReliefForm({ Key? key }) : super(key: key);

  @override
  _ReliefFormState createState() => _ReliefFormState();
}

class _ReliefFormState extends State<ReliefForm> {
  // Controller untuk mengelola nilai dari TextInput
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController catatanController = TextEditingController();

  // Variabel untuk menyimpan nilai dari Date dan Time Picker
  DateTime tanggalMulai = DateTime.now();
  TimeOfDay jamMulai = TimeOfDay.now();
  DateTime tanggalSelesai = DateTime.now();
  TimeOfDay jamSelesai = TimeOfDay.now();

  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  List<User> user_list = [];

  // Daftar pekerja dan rig tujuan
  List<String> daftarRigTujuan = ["Rig A", "Rig B", "Rig C"];

  // Method untuk menampilkan DatePicker
  Future<void> _selectDate(BuildContext context, bool isStartDate,String title) async {
    DateTime? selectedDate = await showDatePicker(
      helpText: title,
      context: context,
      initialDate: isStartDate ? tanggalMulai : tanggalSelesai,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != (isStartDate ? tanggalMulai : tanggalSelesai)) {
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

    if (selectedTime != null && selectedTime != (isStartTime ? jamMulai : jamSelesai)) {
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
  void _submitForm() {
    // Lakukan logika pengiriman data atau simpan ke database di sini
    print("Data yang dikirim:");
    // print("Nama Pekerja: "+pekerjaDropdownValue!.employee_id.toString());
    print("Rig Tujuan: ${rigTujuanDropdownValue}");
    print("Tanggal Mulai: $tanggalMulai");
    print("Jam Mulai: $jamMulai");
    print("Tanggal Selesai: $tanggalSelesai");
    print("Jam Selesai: $jamSelesai");
    print("Deskripsi Tugas: ${deskripsiController.text}");
    print("Catatan: ${catatanController.text}");
  }

  // Nilai default untuk dropdown
  User? pekerjaDropdownValue;
  String? rigTujuanDropdownValue;


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
              SizedBox(height: 20,),
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
                        Icon(Icons.person_pin,color: Theme.of(context).colorScheme.primary,),
                        SizedBox(width: 10,),
                        Text(((pekerja.employee_name ?? "-")+" - ("+(pekerja.employee_id ?? "-")+")")),
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
                    child:
                    Row(
                      children: [
                        Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary,),
                        SizedBox(width: 10,),
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
                          formatDateRegisterForm(tanggalMulai),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Jam Mulai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          "${jamMulai.format(context)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Date Picker dan Time Picker untuk Tanggal dan Jam Selesai
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false, "Tanggal Selesai"),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Selesai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          formatDateRegisterForm(tanggalSelesai),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Jam Selesai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          "${jamSelesai.format(context)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
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
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserData() async {
  user_list = await _dataBaseHelper.queryAllUsers();
  // print(user_list);
  setState(() {});}
}