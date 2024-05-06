import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/db/databse_helper_employee.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ApprovalRegister extends StatefulWidget {
  const ApprovalRegister({Key? key}) : super(key: key);

  @override
  _ApprovalRegisterState createState() => _ApprovalRegisterState();
}

class _ApprovalRegisterState extends State<ApprovalRegister> {
  DatabaseHelperEmployee _dataBaseHelper = DatabaseHelperEmployee.instance;
  List<User> user_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return user_list.isNotEmpty
        ? Container(
            child: ListView.builder(
                itemCount: user_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 75,
                      child: Card(
                          child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text("Adzie Hadi" ?? "Unknown"),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () {}, child: Text("Approve")),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      )));
                }),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    "Approval Karyawa Baru",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                Lottie.asset(
                  'assets/lottie/no_data.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                Text(
                    textAlign: TextAlign.center,
                    "Tidak Ada Approval Untuk\nRegistrasi Karyawa Baru",
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          );
  }

  Future<void> _loadUserData() async {
    user_list = await _dataBaseHelper.queryAllUsersNotVerifRegister();
    // print(user_list);
    setState(() {});
  }
}
