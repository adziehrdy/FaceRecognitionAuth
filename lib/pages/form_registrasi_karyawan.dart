// import 'package:face_net_authentication/globals.dart';
// import 'package:face_net_authentication/models/master_register_model.dart';
// import 'package:flutter/material.dart';

// class FormRegistrasiKaryawan extends StatefulWidget {
//   const FormRegistrasiKaryawan({Key? key}) : super(key: key);

//   @override
//   _FormRegistrasiKaryawanState createState() => _FormRegistrasiKaryawanState();
// }

// class _FormRegistrasiKaryawanState extends State<FormRegistrasiKaryawan> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   master_register_model? master_data;

//   String _nama = '';
//   int _nip = 0;
//   String _email = '';
//   DateTime _tanggalLahir = DateTime.now();
//   String _nomorTelepon = '';
//   String _jabatan = '';
//   String _statusPegawai = '';
//   String _status = '';
//   String _password = "";
//   Employee? _approval;
//   Division? _divisi;
//   Location? _lokasi;
//   Role? _role;
//   bool _dataLoaded = false;

//   List<String> _statusPegawaiList = ["CONTRACT", "PERMANENT"];
//   // List<String> _statusList = ["AKTIF","TIDAK AKTIF"];
//   List<Employee> _approvalList = [];
//   List<Division> _divisiList = [];
//   List<Location> _lokasiList = [];
//   List<Role> _roleList = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     hitGetMasterRegister();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_dataLoaded) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(), // Tampilkan loading indicator
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Form Pendaftaran Karyawan'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Nama'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Nama tidak boleh kosong';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _nama = value;
//                     });
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'NIP'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null ||
//                         value.isEmpty ||
//                         int.tryParse(value) == null) {
//                       return 'NIP harus berupa angka';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _nip = int.tryParse(value) ?? 0;
//                     });
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Email'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Email tidak boleh kosong';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _email = value;
//                     });
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Tanggal Lahir: '),
//                     ElevatedButton(
//                       onPressed: () {
//                         _selectDate(context);
//                       },
//                       child: Text('Pilih Tanggal'),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   formatDateRegisterForm(_tanggalLahir),
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Nomor Telepon'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Nomor Telepon tidak boleh kosong';
//                     }
//                     // Tambahkan validasi nomor telepon sesuai kebutuhan
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _nomorTelepon = value;
//                     });
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Jabatan'),
//                   onChanged: (value) {
//                     setState(() {
//                       _jabatan = value;
//                     });
//                   },
//                 ),
//                 DropdownButtonFormField(
//                   decoration: InputDecoration(labelText: 'Status Pegawai'),
//                   items: _statusPegawaiList.map((status) {
//                     return DropdownMenuItem(
//                       value: status,
//                       child: Text(status),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _statusPegawai = value.toString();
//                     });
//                   },
//                 ),

//                 DropdownButtonFormField<Employee>(
//                   value: _approval,
//                   onChanged: (Employee? newValue) {
//                     setState(() {
//                       _approval = newValue;
//                     });
//                   },
//                   items: _approvalList
//                       .map<DropdownMenuItem<Employee>>((Employee employee) {
//                     return DropdownMenuItem<Employee>(
//                       value: employee,
//                       child: Text(employee.employeeName),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Approval',
//                     // Add any other decoration properties as needed
//                   ),
//                 ),

//                 DropdownButtonFormField<Division>(
//                   value: _divisi,
//                   onChanged: (Division? newValue) {
//                     setState(() {
//                       _divisi = newValue;
//                     });
//                   },
//                   items: _divisiList
//                       .map<DropdownMenuItem<Division>>((Division division) {
//                     return DropdownMenuItem<Division>(
//                       value: division,
//                       child: Text(division.group),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Divisi',
//                     // Add any other decoration properties as needed
//                   ),
//                 ),

//                 DropdownButtonFormField<Location>(
//                   value: _lokasi,
//                   onChanged: (Location? newValue) {
//                     setState(() {
//                       _lokasi = newValue;
//                     });
//                   },
//                   items: _lokasiList
//                       .map<DropdownMenuItem<Location>>((Location location) {
//                     return DropdownMenuItem<Location>(
//                       value: location,
//                       child: Text(location.branchName),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Lokasi',
//                     // Add any other decoration properties as needed
//                   ),
//                 ),

//                 DropdownButtonFormField<Role>(
//                   value: _role,
//                   onChanged: (Role? newValue) {
//                     setState(() {
//                       _role = newValue;
//                     });
//                   },
//                   items: _roleList.map<DropdownMenuItem<Role>>((Role role) {
//                     return DropdownMenuItem<Role>(
//                       value: role,
//                       child: Text(role.id),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(
//                     labelText: 'Pilih Role',
//                     // Add any other decoration properties as needed
//                   ),
//                 ),
//                 //                  DropdownButtonFormField(
//                 //   decoration: InputDecoration(labelText: 'Status'),
//                 //   items: _statusList.map((status) {
//                 //     return DropdownMenuItem(
//                 //       value: status,
//                 //       child: Text(status),
//                 //     );
//                 //   }).toList(),
//                 //   onChanged: (value) {
//                 //     setState(() {
//                 //       _status = value.toString();
//                 //     });
//                 //   },
//                 // ),

//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Password'),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Password tidak boleh kosong';
//                     } else if (value.length < 6) {
//                       return 'Password minimal harus 6 karakter';
//                     }
//                     // Tambahkan validasi nomor telepon sesuai kebutuhan
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _password = value;
//                     });
//                   },
//                 ),

//                 SizedBox(
//                   height: 30,
//                 ),

//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       if(checkAllFieldsFilled()){

//                       }
                     
//                     }
//                   },
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _tanggalLahir,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null && picked != _tanggalLahir) {
//       setState(() {
//         _tanggalLahir = picked;
//       });
//     }

//     // Tambahkan pengecekan apakah semua field sudah terisi di sini
//     checkAllFieldsFilled();
//   }

//   Future<void> hitGetMasterRegister() async {
//     // String? data = await GlobalRepo().getMasterRegister();
//     // setState(() {
//     //   if (data != null) {
//     //     master_data = master_register_model.fromJson(json.decode(data));
//     //     _divisiList = master_data!.data.division;
//     //     _roleList = master_data!.data.role;

//     //     getUserLoginData().then((device_data) {
//     //       setState(() {
//     //         _approvalList.add(Employee(
//     //           employeeId: device_data.superAttendence[0].id ?? "",
//     //           employeeName: device_data.superAttendence[0].name ?? "",
//     //         ));
//     //         _lokasiList.add(Location(
//     //           branchId: device_data.branch?.branchId ?? "",
//     //           branchName: device_data.branch?.branchName ?? "",
//     //         ));
//     //         _dataLoaded = true; // Tandai bahwa semua data sudah terambil
//     //       });
//     //     });

//     //     print(_approvalList[0]);
//     //   }
//     // });
//   }

//   bool checkAllFieldsFilled() {
//     if (_nama.isNotEmpty &&
//         _nip != 0 &&
//         _email.isNotEmpty &&
//         _nomorTelepon.isNotEmpty &&
//         _password.isNotEmpty &&
//         _tanggalLahir != null &&
//         _jabatan.isNotEmpty &&
//         _statusPegawai.isNotEmpty &&
//         _approval != null &&
//         _divisi != null &&
//         _lokasi != null &&
//         _role != null) {
//           return true;
//       // Jika semua field sudah terisi, izinkan pengguna untuk submit
//     } else {
//       showToast("Mohon Isi Semua data");
//       return false;
//       // Jika masih ada field yang kosong, tetap tampilkan pesan
//     }
//   }
// }
