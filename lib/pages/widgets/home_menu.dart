import 'package:flutter/material.dart';

class HomeMenu extends StatelessWidget {
  final Function(String) callback;
  final String text;
  final String icon;
  final int count;

  HomeMenu(this.text, this.icon, this.count, {required this.callback});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(13), // Adjust the border radius as needed
        ),
        child: InkWell(
            onTap: _handleButtonPress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                )
              ],
            )));
  }

  void _handleButtonPress() {
    print("Component Click");
    callback(text);
  }
}
