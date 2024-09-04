// import 'package:face_net_authentication/models/user.dart';
// import 'package:face_net_authentication/pages/sign-up.dart';
// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class item_verif_register extends StatefulWidget {
//   final List<User> personList;

//   const item_verif_register({
//     super.key,
//     required this.personList, required this.onFinish,
//   });


//   final VoidCallback onFinish;


//   @override
//   _item_verif_registerState createState() => _item_verif_registerState();
// }


// class _item_verif_registerState extends State<item_verif_register> {
//   @override
//   Widget build(BuildContext context) {
    
//     return ListView.builder(
//         itemCount: widget.personList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return SizedBox(
//               height: 75,
//               child: Card(
//                   child: Row(
//                 children: [
//                   const SizedBox(
//                     width: 16,
//                   ),
                  
//                   const SizedBox(
//                     width: 16,
//                   ),
//                   Text(widget.personList[index].employee_name ?? "Unknown"),
//                   const Spacer(),
//                   IconButton(
//                     icon: Icon(
//                       widget.personList[index].face_template == null
//                           ? Icons.face_retouching_off
//                           : Icons.face_rounded,
//                       color: widget.personList[index].face_template == null
//                           ? Colors.red
//                           : null, // Use null to keep the default color
//                     ),
//                     onPressed: () async {
//                       await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (BuildContext context) =>
//                               SignUp(user: widget.personList[index]),
//                         ),
//                       );
//                       widget.onFinish();
//                       ;
//                     },
//                   ),

//                   const SizedBox(
//                     width: 8,
//                   )
//                 ],
//               )));
//         });
//   }
// }
