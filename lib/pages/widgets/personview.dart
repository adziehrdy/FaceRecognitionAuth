import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/model_master_shift.dart';
import 'package:face_net_authentication/models/model_rig_shift.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:face_net_authentication/pages/widgets/dialog_detail_employee.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PersonView extends StatefulWidget {
  final List<User> personList;
  final Function(int) onUserSelected;
  final List<bool> selected;
  final VoidCallback onShiftUpdated;

  // final MyHomePageState homePageState;

  const PersonView({
    super.key,
    required this.personList,
    required this.onFinish,
    required this.onUserSelected,
    required this.selected,
    required this.onShiftUpdated,
  });

  final VoidCallback onFinish;

  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  TextEditingController _searchController = TextEditingController();
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  String _searchText = "";
  List<ShiftRig> listShift = [];

  List<bool> selectedPerson = [];
  deletePerson(int index) async {
    // await widget.homePageState.deletePerson(index);
  }

  updatePerson(int index) async {
    // await widget.homePageState.updatePerson(index,context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });

    // getMasterShift().then((value) {
    //   setState(() {
    //     listShift = value;
    //   });
    // });

    SpGetSelectedStatusRig().then(
      (value) {
        setState(() {
          listShift = value!.shift!;
          listShift.add(ShiftRig(id: "PDC_OFF", checkin: null, checkout: null));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari Berdasarkan Nama',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
            child: Stack(
          children: [
            ListView.builder(
                itemCount: widget.personList.length,
                itemBuilder: (BuildContext context, int index) {
                  // Lakukan filtering disini berdasarkan _searchText

                  selectedPerson.add(false);
                  if (_searchText.isNotEmpty &&
                      !widget.personList[index].employee_name!
                          .toLowerCase()
                          .contains(_searchText.toLowerCase())) {
                    return Container(); // Item tidak cocok, jadi tidak ditampilkan
                  }
                  bool warningButton = false;
                  String WarningReson = "";
                  if (widget.personList[index].employee_status != "ACTIVE") {
                    warningButton = true;
                    WarningReson = WarningReson +
                        "Registrasi Karyawan Belum Di Approve Oleh Superintendent \n\n";
                  }
                  if (widget.personList[index].face_template == "" ||
                      widget.personList[index].face_template == null) {
                    warningButton = true;
                    WarningReson = WarningReson +
                        "Face Recognition Belum di Daftarkan \n\n";
                  }

                  if (widget.personList[index].is_verif_fr == "0") {
                    warningButton = true;
                    WarningReson = WarningReson +
                        "Face Recognition Belum Di Approve Oleh Superintendent\n\n";
                  }
                  if (widget.personList[index].check_in == null ||
                      widget.personList[index].check_out == null) {
                    warningButton = true;
                    WarningReson =
                        WarningReson + "Shift Karyawan Belum di pilih";
                  }
                  // print(widget.personList[index].check_in);
                  // print(widget.personList[index].check_out);
                  // print(widget.personList[index].check_out);

                  return InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return widget_detail_employee(
                              user_detail: widget.personList[index],
                            );
                          },
                        );
                        widget.onFinish();
                      },
                      onLongPress: () {
                        widget.onUserSelected(index);
                        print("LONG PRESS" +
                            (widget.personList[index].employee_name ?? " * "));
                        setState(() {
                          selectedPerson[index] = !selectedPerson[index];
                          isAnySelectedChecker();
                        });
                      },
                      overlayColor: widget.selected == true
                          ? MaterialStatePropertyAll(
                              Colors.blue.withOpacity(0.2))
                          : null,
                      child: SizedBox(
                          child: Card(
                              child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            isAnySelectedChecker() == true
                                ? Checkbox(
                                    value: selectedPerson[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedPerson[index] = value!;
                                        isAnySelectedChecker();
                                      });
                                    },
                                  )
                                : SizedBox(),
                            //ADZIEHRDY
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(28.0),
                            //   child: widget.personList[index].faceJpg != null ? Image.memory(
                            //     widget.personList[index].faceJpg !,
                            //     width: 56,
                            //     height: 56,
                            //   ) : Text(""),
                            // ),
                            Row(
                              children: [
                                Container(
                                    child: warningButton
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 25,
                                              color: Colors.orangeAccent,
                                            ),
                                            onPressed: () {
                                              showWarningDialog(
                                                  context, WarningReson);
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              size: 25,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {},
                                          )),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            widget.personList[index]
                                                    .employee_name!
                                                    .toUpperCase() ??
                                                "Unknown",
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          DKStatusChecker(
                                                  widget.personList[index]
                                                      .dk_start_date,
                                                  widget.personList[index]
                                                      .dk_end_date)
                                              ? Text(
                                                  "( Dinas Khusus )",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          (widget.personList[index].shift_id ??
                                                  "Shift Belum Di Assign, Mohon Hubungi Admin") +
                                              " | " +
                                              (widget.personList[index]
                                                      .company_id ??
                                                  "-"),
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    widget.personList[index].face_template ==
                                            null
                                        ? Icons.face_retouching_off
                                        : Icons.face_rounded,
                                    color: widget.personList[index]
                                                .face_template ==
                                            null
                                        ? Colors.red
                                        : null, // Use null to keep the default color
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignUp(
                                                user: widget.personList[index]),
                                      ),
                                    );
                                    widget.onFinish();
                                    ;
                                  },
                                ),
                              ],
                            ),
                            // GestureDetector(
                            //   onLongPress: () => deletePerson(index),
                            //   child: IconButton(
                            //     icon: const Icon(Icons.delete),
                            //     onPressed: () {},
                            //   ),
                            // ),
                          ],
                        ),
                      ))));
                }),
            Visibility(
              visible: isAnySelectedChecker(),
              child: Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      shadowColor: MaterialStatePropertyAll(Colors.black),
                      elevation: MaterialStatePropertyAll(
                          4.0), // Adjust the elevation as needed
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _pilihShift();
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.repeat,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Ganti Shift",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ],
    );
  }
//   @override
// void dispose() {
//   LongPressGestureRecognizer.dispose();
//   super.dispose();
// }

  void showWarningDialog(BuildContext context, String warningReason) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Absensi Belum Bisa Dilakukan Karena",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    warningReason,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isAnySelectedChecker() {
    bool result = false;
    for (bool person in selectedPerson) {
      if (person == true) {
        result = true;
        break;
      }
    }
    print("IS ANY SELECTED = " + result.toString());
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _pilihShift() {
    String? selectedShiftId = listShift.first.id;
    return Dialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        Text("Pilih Shift"),
        Container(
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: selectedShiftId,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedShiftId = newValue;
                });
              }
            },
            items: listShift.map((ShiftRig shift) {
              return DropdownMenuItem<String>(
                value: shift.id,
                child: Text(shift.id ?? "-"),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            List<String> selectedShiftData =
                getCheckInCheckOut(selectedShiftId!);

            GlobalRepo repo = GlobalRepo();

            showDialog(
              context: context,
              barrierDismissible:
                  false, // prevent user from dismissing the dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Updating Shift..."),
                    ],
                  ),
                );
              },
            );

            bool isFault = false;

            for (int index = 0; index < selectedPerson.length; index++) {
              if (selectedPerson[index] == true) {
                print(
                    "RESULT " + (widget.personList[index].employee_name ?? ""));

                if (widget.personList[index].shift_id != null) {
                  await _dataBaseHelper.updateShift(
                    widget.personList[index].employee_id,
                    selectedShiftData[0],
                    selectedShiftData[1],
                    selectedShiftData[2],
                  );

                  bool success = await repo.hitUpdateMasterShift(
                    widget.personList[index].employee_id!,
                    selectedShiftId!,
                  );
                } else {
                  showToast("Shift untuk " +
                      (widget.personList[index].employee_name ?? "-") +
                      " belum bisa diganti, mohon Hubungi admin");
                  isFault = true;
                }

                // if (success) {
                //   await _dataBaseHelper.updateShift(
                //     widget.personList[index].employee_id,
                //     selectedShiftData[0],
                //     selectedShiftData[1],
                //     selectedShiftData[2],
                //   );

                //   selectedPerson[index] = false;
                // } else {
                //   showToast(
                //     "Shift " +
                //         (widget.personList[index].employee_name ?? "-") +
                //         " Belum ditambahkan, mohon hubungi admin",
                //   );
                //   isFault = true;
                // }
              }
            }

            Navigator.pop(context); // Close the dialog

            if (isFault == true) {
              showToastShort(
                  "Beberapa Shift karyawan belum bisa di Update, Mohon coba kembali");
            } else {
              showToastShort("Semua Shift berhasil dirubah");
              selectedPerson = [];
              Navigator.pop(context);
            }

            setState(() {
              selectedPerson;
            });
            widget.onShiftUpdated();
          },
          child: Text("Update Shift"),
        ),
        SizedBox(
          height: 10,
        )
      ],
    ));
  }

  List<String> getCheckInCheckOut(String selectedShiftId) {
    List<String> shiftData = [];
    ShiftRig? selectedShift = listShift.firstWhere(
      (shift) => shift.id == selectedShiftId,
    );

    setState(() {
      shiftData.add(selectedShift.id ?? "-");
      shiftData.add(selectedShift.checkin ?? "-");
      shiftData.add(selectedShift.checkout ?? "-");
    });

    return shiftData;
  }
}
