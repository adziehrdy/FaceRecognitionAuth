import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/Catering/catering_history.dart';
import 'package:face_net_authentication/pages/MealSheet/database_helper_mealsheet.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_List.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_list_visitor.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_model.dart';
import 'package:face_net_authentication/pages/db/databse_helper_absensi.dart';
import 'package:flutter/material.dart';

class MealHistoryPage extends StatefulWidget {
  const MealHistoryPage({Key? key}) : super(key: key);

  @override
  _MealHistoryPageState createState() => _MealHistoryPageState();
}

int _currentIndex = 0;
final List<Widget> _pages = [
  MealHistoryList(),
  MealHistoryListVisitor(),
];

class _MealHistoryPageState extends State<MealHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Reguler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face_retouching_natural),
            label: 'Visitor',
          ),
        ],
      ),
    );
  }
}
