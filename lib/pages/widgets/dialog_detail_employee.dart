import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/pages/models/model_master_shift.dart';
import 'package:face_net_authentication/pages/models/user.dart';
import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pinput/pinput.dart';

class widget_detail_employee extends StatefulWidget {
  final User user_detail;

  widget_detail_employee({required this.user_detail});

  @override
  _widget_detail_employeeState createState() => _widget_detail_employeeState();
}

class _widget_detail_employeeState extends State<widget_detail_employee> {
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  String selectedShiftId = "-";
  List<ShiftData> listShift = [];
  String checkin = "-";
  String checkOut = "-";
  String shift_id = "-";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedShiftId = widget.user_detail.shift_id ?? "-";

    getMasterShift().then((value) {
      setState(() {
        listShift = value;
      });
    });

    setState(() {
      shift_id = widget.user_detail.shift_id ?? "Shift Belum Dipilih";
      checkin = widget.user_detail.check_in ?? "-";
      checkOut = widget.user_detail.check_out ?? "-";
    });
  }

  final defaultPinTheme = PinTheme(
    width: 35,
    height: 35,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(100),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
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
                child: checkFrPhoto(widget.user_detail.employee_fr_image),
              ),
            ),

            SizedBox(height: 10),

            Text(
              (widget.user_detail.employee_name ?? "-").toUpperCase(),
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
            Text(
              (widget.user_detail.employee_id ?? "-" )+ " - " + (widget.user_detail.branch_id ?? "-"),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            Divider(),
            Text(
              shift_id,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),

            SizedBox(height: 10),
            // Text(

            //   latLong,
            //   maxLines: 2,
            //   style: TextStyle(

            //       fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
            // ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Text(
                      "Jam Masuk",
                    ),
                    Text(checkin,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      "Jam Keluar",
                    ),
                    Text(checkOut,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _pilihShift();
                    },
                  );
                },
                child: Text("Ganti Shift")),

            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pilihShift() {
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
            items: listShift.map((ShiftData shift) {
              return DropdownMenuItem<String>(
                value: shift.shiftId,
                child: Text(shift.shiftId),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
            onPressed: () async {
              getCheckInCheckOut(selectedShiftId);

              GlobalRepo repo = GlobalRepo();

              EasyLoading.show(status: "Uploading Shift..");

              bool success = await repo.hitUpdateMasterShift(
                  widget.user_detail.employee_id!, shift_id);

              if (success) {
                await _dataBaseHelper.updateShift(
                    widget.user_detail.employee_id,
                    shift_id,
                    checkin,
                    checkOut);
                Navigator.pop(context);
                EasyLoading.dismiss();
                showToastShort("Shift Berhasil dirubah");

              }else{
                EasyLoading.dismiss();
                showToastShort("Perubahan Shift Gagal, mohon coba kembali");
              }
            },
            child: Text("Update Shift")),
        SizedBox(
          height: 10,
        )
      ],
    ));
  }

  void getCheckInCheckOut(String selectedShiftId) {
    ShiftData? selectedShift = listShift.firstWhere(
      (shift) => shift.shiftId == selectedShiftId,
    );

    setState(() {
      shift_id = selectedShift.shiftId;
      checkin = selectedShift.checkIn ?? "-";
      checkOut = selectedShift.checkOut ?? "-";
    });
  }
}
