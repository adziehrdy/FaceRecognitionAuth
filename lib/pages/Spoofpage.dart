import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Spoofpage extends StatefulWidget {
  const Spoofpage({Key? key}) : super(key: key);

  @override
  _SpoofpageState createState() => _SpoofpageState();
}

class _SpoofpageState extends State<Spoofpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              height: 300,
              width: 300,
              child: LottieBuilder.asset(
                "assets/lottie/spoof.json",
                height: 300,
                fit: BoxFit.fill,
                width: 300,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "SPOOF DETECTED!",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ],
        )));
  }
}
