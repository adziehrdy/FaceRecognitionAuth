import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/models/login_model.dart';
import 'package:face_net_authentication/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SwitchSupperAttendance extends StatefulWidget {
  const SwitchSupperAttendance({Key? key}) : super(key: key);

  @override
  _SwitchSupperAttendanceState createState() => _SwitchSupperAttendanceState();
}

class _SwitchSupperAttendanceState extends State<SwitchSupperAttendance> {
  List<SuperIntendent> superIntendentList = [];

  @override
  void initState() {
    super.initState();
    getUserLoginData().then((value) {
      setState(() {
        superIntendentList = value.superAttendence;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Pilih Superintendent",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
            ),
            OrientationBuilder(
              builder: (context, orientation) {
                return Container(
                  height: 230,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: orientation == Orientation.landscape
                        ? Axis.vertical
                        : Axis.horizontal,
                    itemCount: superIntendentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 200, // Lebar item set menjadi 100
                          height: 230, // Tinggi item tetap 230
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/user.json',
                                  repeat: true,
                                  width: 300,
                                  height: 100,
                                ),
                                Text(
                                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                                  superIntendentList[index].name,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          await setActiveSuperIntendent(index);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
