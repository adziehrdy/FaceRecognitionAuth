import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/user.dart';
import 'package:face_net_authentication/pages/db/databse_helper_employee.dart';
import 'package:face_net_authentication/repo/user_repos.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ApprovalFR extends StatefulWidget {
  const ApprovalFR({Key? key}) : super(key: key);

  @override
  _ApprovalFRState createState() => _ApprovalFRState();
}

class _ApprovalFRState extends State<ApprovalFR> {
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
    return Container(
        child: user_list.isNotEmpty
            ? ListView.builder(
                itemCount: user_list.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      child: Card(
                          child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey,
                        // child: Image.asset(
                        //   "assets/images/profile0.png",
                        //   height: 100,
                        //   width: 100,
                        // ),
                        child : checkFrPhoto(user_list[index].employee_fr_image)
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(user_list[index].employee_name ?? "Unknown"),
                      const Spacer(),
                      ElevatedButton(onPressed: () async {
                        await hitApproveFR(user_list[index]);
                      }, child: Text("Approve")),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  )));
                })
            : Center(
              
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(textAlign: TextAlign.center,"Approval Face Recognition",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold)),
                    Lottie.asset(
                      'assets/lottie/no_data.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                    Text(textAlign: TextAlign.center,"Tidak Ada Approval Untuk\nFace Recognition",style: TextStyle(fontSize: 15)),
                  ],
                ),
              ));
  }

  Future<void> _loadUserData() async {
    user_list = await _dataBaseHelper.queryAllUsersNotVerifFR();
    // print(user_list);
    setState(() {});
  }
}
