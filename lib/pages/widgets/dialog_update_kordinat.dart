import 'package:face_net_authentication/repo/global_repos.dart';
import 'package:face_net_authentication/services/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class uploadKordinat extends StatefulWidget {
  final Function(String) onPinEntered;

  uploadKordinat({required this.onPinEntered});

  @override
  _uploadKordinatState createState() => _uploadKordinatState();
}

class _uploadKordinatState extends State<uploadKordinat> {
  String? CorrectPin;
  String latLong = "-";
  String alamat = "-";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   SpGetLastAlamat().then((value) {
   setState(() {
       alamat = value;
   });
   
   
   });

   SpGetLastLatlong().then((value){
    setState(() {
      latLong = value;
    });
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
    return 
    SingleChildScrollView(child: Container(
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
          Lottie.asset(
            'assets/lottie/maps.json',
            width: 250,
            height: 200,
            
          ),
          SizedBox(height: 0),
         
          Text(
            "Update Lokasi Ke :".toUpperCase(),
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w600),
          ),
           Text(
            
            alamat,
            maxLines: 2,
            style: TextStyle(
              
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          Text(
            
            latLong,
            maxLines: 2,
            style: TextStyle(
              
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
          ),
           SizedBox(height: 15),
           ElevatedButton(onPressed: () async {

            GlobalRepo repo = await GlobalRepo();
           
           repo.hitUpdateLokasi(latLong, alamat).then((value) {

            if(value){
               Navigator.of(context).pop();
            }

           });
            
             
           }, child: Text("Kirim dan Update Lokasi")),
          
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ),
        ],
      ),
    ),);
  }
}

class dialog_update_kordinat {
  static void show(BuildContext context, Function(String) onPinEntered) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return uploadKordinat(onPinEntered: onPinEntered);
      },
    );
  }
}
