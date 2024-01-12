
import 'package:face_net_authentication/pages/Approval/approval_FR.dart';
import 'package:flutter/material.dart';


class approval_main_page extends StatefulWidget {
  const approval_main_page({Key? key}) : super(key: key);

  @override
  State<approval_main_page> createState() => _approval_main_pageState();
}

class _approval_main_pageState extends State<approval_main_page>
with SingleTickerProviderStateMixin {
  late TabController controller;

  // List<String> TAB = ["Terlambat","Face Recognition"];
    List<String> TAB = ["Face Recognition"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() { });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold (
      appBar: AppBar(
        title: Text(TAB[controller.index]),
        centerTitle: true,
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: TAB[0]),
            // Tab(text: TAB[1]),
            // Tab(text: TAB[2]),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          // ApprovalTerlambat(),
          ApprovalFR(),
          // ApprovalRegister(),
          // SecondPage(),
          // ThirdPage(),
        ],
      ),
  );
}