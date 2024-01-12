import 'package:face_net_authentication/pages/history_absensi.dart';
import 'package:face_net_authentication/pages/history_absensi_uploaded.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History Absensi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HistoryAbsensiMainPage(),
    );
  }
}

class HistoryAbsensiMainPage extends StatefulWidget {
  @override
  _HistoryAbsensiMainPageState createState() => _HistoryAbsensiMainPageState();
}

class _HistoryAbsensiMainPageState extends State<HistoryAbsensiMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HistoryAbsensi(),
    HistoryAbsensiUploaded(),
  ];

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
            icon: Icon(Icons.history),
            label: 'History Absensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'History Absensi Terupload',
          ),
        ],
      ),
    );
  }
}