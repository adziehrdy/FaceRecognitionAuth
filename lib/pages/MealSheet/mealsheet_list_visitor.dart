import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/pages/MealSheet/database_helper_mealsheet.dart';
import 'package:face_net_authentication/pages/MealSheet/database_helper_mealsheet_visitor.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:face_net_authentication/pages/history_absensi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MealHistoryListVisitor extends StatefulWidget {
  const MealHistoryListVisitor({Key? key}) : super(key: key);
  @override
  _MealHistoryListVisitorState createState() => _MealHistoryListVisitorState();
}

DatabaseHelperMealsheetVisitor databaseHelperMealsheetVisitor =
    DatabaseHelperMealsheetVisitor.instance;
List<MealSheetVisitorModel> Historydata = [];

class _MealHistoryListVisitorState extends State<MealHistoryListVisitor> {
  @override
  initState() {
    super.initState();
    initData();
  }

  initData() {
    Historydata = [];
    databaseHelperMealsheetVisitor.getAllData().then((value) {
      setState(() {
        Historydata = value.reversed.toList();
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meal attendance Visitor"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  _showVisitorType(context);
                },
                child: Text("Tambahkan Visitor +"))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Historydata.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Historydata[index].type == "personal"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                (Historydata[index]
                                                            .employeeName ??
                                                        "-")
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("" +
                                                  Historydata[index].guestType +
                                                  ""),
                                              Historydata[index]
                                                          .accommodation !=
                                                      null
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          " |  + Akomodasi",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo),
                                                        ),
                                                        // Icon(
                                                        //   Icons.bed,
                                                        //   size: 20,
                                                        // ),
                                                      ],
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                          Text(
                                            formatDateFriendly(
                                                Historydata[index].initDate!),
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 11),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.group_outlined,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                (Historydata[index].company ??
                                                        "-")
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text("" +
                                              Historydata[index].guestType +
                                              " - Group " +
                                              Historydata[index]
                                                  .person_count
                                                  .toString() +
                                              " Orang"),
                                          Text(
                                            formatDateFriendly(
                                                Historydata[index].initDate!),
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 11),
                                          ),
                                        ],
                                      ),
                              ),
                              Container(
                                color: Colors.grey,
                                width: 1,
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  sheetItem("Sahur", Historydata[index].sahur),
                                  sheetItem(
                                      "Breakfast", Historydata[index].bFast),
                                  sheetItem("Lunch", Historydata[index].lunch),
                                  sheetItem(
                                      "Dinner", Historydata[index].dinner),
                                  sheetItem(
                                      "Supper", Historydata[index].supper),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                    ),
                                    color: Colors.grey,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Konfirmasi"),
                                            content: Text(
                                                "Apakah Anda yakin ingin menghapus data "),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Tutup dialog tanpa menghapus
                                                },
                                                child: Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  databaseHelperMealsheetVisitor
                                                      .deleteData(
                                                          Historydata[index]
                                                              .id!);

                                                  initData();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Ya, Hapus",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ));
  }

  Widget mealCard(MealSheetVisitorModel data) {
    return Card(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data.employeeName!.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text(data.initDate!.toIso8601String() ?? ""),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 1,
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      sheetItem("Sahur", data.sahur),
                      sheetItem("Breakfast", data.bFast),
                      sheetItem("Lunch", data.lunch),
                      sheetItem("Dinner", data.dinner),
                      sheetItem("Supper", data.supper),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.grey,
                        size: 20,
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget sheetItem(String name, String? time) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (time != null) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Container(
      width: 105,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: statusColor,
          begin: Alignment.bottomRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.fastfood_rounded, color: Colors.white, size: 15),
          SizedBox(
            width: 2,
          ),
          Container(
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 2,
          ),
        ],
      ),
    );
  }

  Widget mealSheetDetail(MealSheetVisitorModel mealSheet) {
    int mealSheetFilledCount = 0;
    if (mealSheet.bFastTime != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.lunchTime != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.dinner != null) {
      mealSheetFilledCount += 1;
    } else if (mealSheet.supper != null) {
      mealSheetFilledCount += 1;
    }
    return Card(
      child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    mealSheet.employeeName!.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    formatDateFriendly(mealSheet.initDate!),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                sheetItemEdit(mealSheet.id.toString(), "Breakfast",
                    mealSheet.bFastTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Lunch",
                    mealSheet.lunchTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Dinner",
                    mealSheet.dinnerTime, mealSheetFilledCount),
                sheetItemEdit(mealSheet.id.toString(), "Supper",
                    mealSheet.supperTime, mealSheetFilledCount),
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     //Breakfast
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ),
              //     //Lunch
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ),
              //     //Dinner
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     ), //Supper
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.delete_forever_rounded,
              //         color: Colors.grey,
              //         size: 25,
              //       ),
              //     )
              //   ],
              // )
            ],
          )),
    );
  }

  Widget sheetItemEdit(
      String record_id, String name, DateTime? time, int filledCount) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (time != null) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            boxShadow: List.generate(
              5,
              (index) => BoxShadow(
                color: statusColor[0],
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: statusColor,
              begin: Alignment.bottomRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.fastfood_rounded,
                      color: Colors.white.withAlpha(200), size: 15),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              time != null
                  ? Row(
                      children: [
                        Text(
                          formatHourOnly(time),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Belum\nMengambil \n$name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
              time != null
                  ? Row(
                      children: [
                        Container(
                          width: 1,
                          height: 15,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatDateFriendly(time),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        time != null
            ? IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : SizedBox(
                height: 50,
              )
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showVisitorType(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return AlertDialog(
        //   title: Text("Pilih tipe visitor"),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //         {
        //           Dialog simpleDialog = Dialog(
        //             shape: RoundedRectangleBorder(
        //                 borderRadius:
        //                     BorderRadius.circular(12.0)), //this right here
        //             child: Container(
        //                 padding: EdgeInsets.all(20),
        //                 width: 720,
        //                 child: InvitedForm(
        //                   mode: "invited",
        //                   onSuccess: () {
        //                     setState(() {
        //                       initData();
        //                     });
        //                   },
        //                 )),
        //           );
        //           showDialog(
        //               context: context,
        //               builder: (BuildContext context) => simpleDialog);
        //         }
        //         ;
        //       },
        //       child: Text("Invited"),
        //     ),
        //     TextButton(
        //       onPressed: () async {
        //         Navigator.pop(context);
        //         {
        //           Dialog simpleDialog = Dialog(
        //             shape: RoundedRectangleBorder(
        //                 borderRadius:
        //                     BorderRadius.circular(12.0)), //this right here
        //             child: Container(
        //                 padding: EdgeInsets.all(20),
        //                 width: 720,
        //                 child: InvitedForm(
        //                   mode: "uninvited",
        //                   onSuccess: () {
        //                     setState(() {
        //                       initData();
        //                     });
        //                   },
        //                 )),
        //           );
        //           showDialog(
        //               context: context,
        //               builder: (BuildContext context) => simpleDialog);
        //         }
        //       },
        //       child: Text(
        //         "Uninvited",
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     ),
        //   ],
        // );

        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pilih Tipe Visitor",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  LottieBuilder.asset(
                    "assets/lottie/mealsheet/visitor.json",
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      onPressed: () {
                        Navigator.pop(context);
                        {
                          Dialog simpleDialog = Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0)), //this right here
                            child: Container(
                                padding: EdgeInsets.all(20),
                                width: 720,
                                child: InvitedForm(
                                  mode: "invited",
                                  onSuccess: () {
                                    setState(() {
                                      initData();
                                    });
                                  },
                                )),
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => simpleDialog);
                        }
                      },
                      child: Text(
                        "Invited Visitor",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      onPressed: () {
                        Navigator.pop(context);
                        {
                          Dialog simpleDialog = Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0)), //this right here
                            child: Container(
                                padding: EdgeInsets.all(20),
                                width: 720,
                                child: InvitedForm(
                                  mode: "uninvited",
                                  onSuccess: () {
                                    setState(() {
                                      initData();
                                    });
                                  },
                                )),
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => simpleDialog);
                        }
                      },
                      child: Text(
                        "Uninvited Visitor",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ));
      },
    );
  }
}

class InvitedForm extends StatefulWidget {
  final String mode;
  final VoidCallback? onSuccess;

  InvitedForm({Key? key, required this.mode, required this.onSuccess})
      : super(key: key);
  @override
  _InvitedFormState createState() => _InvitedFormState();
}

class _InvitedFormState extends State<InvitedForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipNikController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _branchIdController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _costCenterController = TextEditingController();

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _jumlahOrangController = TextEditingController();

  String _selectedType =
      "personal"; // State untuk menyimpan pilihan radio button

  bool isBreakfast = false;
  bool isLunch = false;
  bool isDinner = false;
  bool isSupper = false;
  bool isSahur = false;
  bool isAccommodation = false;

  String? _validateNotNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini tidak boleh kosong';
    }
    return null;
  }

  void _resetData() {
    _formKey.currentState?.reset();
    isBreakfast = false;
    isLunch = false;
    isDinner = false;
    isSupper = false;
    isSahur = false;
    isAccommodation = false;
    _nameController.clear();
    _nipNikController.clear();
    _companyController.clear();
    _notesController.clear();
    _branchIdController.clear();
    _departmentController.clear();
    _costCenterController.clear();
    _jumlahOrangController.text = "1";
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    _nameController.dispose();
    _nipNikController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    _jumlahOrangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.mode} visitor",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Radio<String>(
                value: "personal",
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _resetData();
                    _selectedType = value!;
                  });
                },
              ),
              Text("Personal"),
              Radio<String>(
                value: "group",
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _resetData();
                    _selectedType = value!;
                  });
                },
              ),
              Text("Group"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isSahur,
                            onChanged: (value) {
                              setState(() {
                                isSahur = value!;
                              });
                            },
                          ),
                          _mealSelection("Sahur", isSahur)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isBreakfast,
                            onChanged: (value) {
                              setState(() {
                                isBreakfast = value!;
                              });
                            },
                          ),
                          _mealSelection("Breakfast", isBreakfast)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isLunch,
                            onChanged: (value) {
                              setState(() {
                                isLunch = value!;
                              });
                            },
                          ),
                          _mealSelection("Lunch", isLunch)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isDinner,
                            onChanged: (value) {
                              setState(() {
                                isDinner = value!;
                              });
                            },
                          ),
                          _mealSelection("Dinner", isDinner)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isSupper,
                            onChanged: (value) {
                              setState(() {
                                isSupper = value!;
                              });
                            },
                          ),
                          _mealSelection("Supper", isSupper)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isAccommodation,
                            onChanged: (value) {
                              setState(() {
                                isAccommodation = value!;
                              });
                            },
                          ),
                          _mealSelection("Akomodasi", isAccommodation)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_selectedType == "personal") ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: "Nama"),
                          validator: _validateNotNull,
                        ),
                        if (widget.mode == "invited")
                          TextFormField(
                            controller: _nipNikController,
                            decoration:
                                InputDecoration(labelText: "NIP atau NIK"),
                            validator: _validateNotNull,
                          ),
                        TextFormField(
                          controller: _companyController,
                          decoration:
                              InputDecoration(labelText: "Company/Alamat"),
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _departmentController,
                          decoration: InputDecoration(labelText: "Departemen"),
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _costCenterController,
                          decoration: InputDecoration(labelText: "Cost Center"),
                          keyboardType: TextInputType.phone,
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(labelText: "Notes"),
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _companyController,
                          decoration:
                              InputDecoration(labelText: "Company/Alamat"),
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _departmentController,
                          decoration: InputDecoration(labelText: "Departemen"),
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _jumlahOrangController,
                          decoration:
                              InputDecoration(labelText: "Jumlah Orang"),
                          keyboardType: TextInputType.number,
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _costCenterController,
                          decoration: InputDecoration(labelText: "Cost Center"),
                          keyboardType: TextInputType.phone,
                          validator: _validateNotNull,
                        ),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(labelText: "Notes"),
                        ),
                      ],
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          bool enable_submit = true;
                          if (_selectedType == "personal") {
                            _jumlahOrangController.text = "1";
                          }
                          if (_jumlahOrangController.text == "0") {
                            enable_submit = false;
                            showToast("Jumlah Orang Tidak Boleh Kosong");
                          }

                          if (isBreakfast == false &&
                              isLunch == false &&
                              isDinner == false &&
                              isAccommodation == false &&
                              isSupper == false) {
                            showToast("Pilihan Meal tidak boleh kosong");
                            enable_submit = false;
                          }

                          if (_formKey.currentState!.validate()) {
                            if (enable_submit) {
                              LoginModel loginData = await getUserLoginData();
                              DatabaseHelperMealsheetVisitor dbHelper =
                                  DatabaseHelperMealsheetVisitor.instance;

                              MealSheetVisitorModel data =
                                  MealSheetVisitorModel(
                                employee_id: _nipNikController.text,
                                employeeName: _nameController.text,
                                company: _companyController.text,
                                person_count:
                                    int.parse(_jumlahOrangController.text),
                                bFast: isBreakfast ? "YES" : null,
                                dinner: isDinner ? "YES" : null,
                                lunch: isLunch ? "YES" : null,
                                supper: isSupper ? "YES" : null,
                                sahur: isSahur ? "YES" : null,
                                accommodation: isAccommodation ? "YES" : null,
                                brachID: loginData.branch!.branchId,
                                department: _departmentController.text,
                                constCenter: _costCenterController.text,
                                initDate: DateTime.now(),
                                guestType: widget.mode,
                                type: _selectedType,
                              );

                              String status =
                                  await dbHelper.insertMealAttendance(data);
                              if (status == "SUCCESS") {
                                showToast("Data Berhasil Ditambahkan");
                                Navigator.pop(context);
                                widget.onSuccess!();
                              } else {
                                showToast("Error -" + status);
                              }

                              print(data);
                            }
                          }
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mealSelection(String name, bool isChecked) {
    List<Color> statusColor = [Colors.grey, Colors.grey];
    if (isChecked) {
      statusColor = [Colors.blue, Colors.indigo];
    }
    return Container(
      width: 130,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: List.generate(
          5,
          (index) => BoxShadow(
            color: statusColor[0],
            blurRadius: 0,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: statusColor,
          begin: Alignment.bottomRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.fastfood_rounded,
                  color: Colors.white.withAlpha(200), size: 15),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
