import 'package:face_net_authentication/pages/models/user.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PersonView extends StatefulWidget {
  final List<User> personList;
  // final MyHomePageState homePageState;

  const PersonView({
    super.key,
    required this.personList,
    required this.onFinish,
  });

  final VoidCallback onFinish;

  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
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
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    
    
    
    Column(children: [

      TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari Berdasarkan Nama',
            prefixIcon: Icon(Icons.search),
          ),
        ),

        SizedBox(height: 15,),


      Expanded(child: 


      ListView.builder(
            itemCount: widget.personList.length,
            itemBuilder: (BuildContext context, int index) {
              // Lakukan filtering disini berdasarkan _searchText
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
                "Registrasi Kaaryawan Belum Di Approve Oleh Superintendent \n\n";
          }
          if (widget.personList[index].face_template == "" ||
              widget.personList[index].face_template == null) {
            warningButton = true;
            WarningReson =
                WarningReson + "Face Recognition Belum di Daftarkan \n\n";
          }

          if (widget.personList[index].is_verif_fr == "0") {
            warningButton = true;
            WarningReson = WarningReson +
                "Face Recognition Belum Di Approve Oleh Superintendent\n\n";
          }

          if (widget.personList[index].check_in == null ||
              widget.personList[index].check_out == null) {
            warningButton = true;
            WarningReson = WarningReson + "Shift Karyawan Belum di pilih";
          }

          print(widget.personList[index].check_in);
          print(widget.personList[index].check_out);
          print(widget.personList[index].check_out);

          return SizedBox(
              child: Card(
                  child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                                  showWarningDialog(context, WarningReson);
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
                          child: Text(
                            widget.personList[index].employee_name!
                                    .toUpperCase() ??
                                "Unknown",
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.personList[index].employee_position ?? "",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
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
                        widget.personList[index].face_template == null
                            ? Icons.face_retouching_off
                            : Icons.face_rounded,
                        color: widget.personList[index].face_template == null
                            ? Colors.red
                            : null, // Use null to keep the default color
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SignUp(user: widget.personList[index]),
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
          )));
        })
      
      ),

    ],);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
