import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader(this.title, {this.onBackPressed});
  final String title;
  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50,),
      Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // InkWell(
          //   onTap: onBackPressed,
          //   child: Container(
          //     margin: EdgeInsets.all(20),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     height: 50,
          //     width: 50,
          //     child: Center(child: Icon(Icons.arrow_back)),
          //   ),
          // ),

          
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      height: 50,
      decoration: BoxDecoration(
      
      ),
    )
    ],);
  }
}
