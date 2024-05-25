import 'package:flutter/material.dart';

import 'catering_exception.dart';
import 'catering_history.dart';

class CateringPage extends StatefulWidget {
  const CateringPage({Key? key}) : super(key: key);

  @override
  _CateringPageState createState() => _CateringPageState();
}

class _CateringPageState extends State<CateringPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CateringHistory(),
    CateringException(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History Catering',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.not_interested),
            label: 'Tidak Mengambil Catering',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
