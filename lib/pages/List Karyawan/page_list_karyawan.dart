import 'package:face_net_authentication/pages/List%20Karyawan/list_karyawan.dart';
import 'package:face_net_authentication/pages/List%20Karyawan/list_karyawan_relief.dart';
import 'package:flutter/material.dart';

class PageListKaryawan extends StatefulWidget {
  const PageListKaryawan({Key? key}) : super(key: key);

  @override
  _PageListKaryawanState createState() => _PageListKaryawanState();
}

int _currentIndex = 0;
List<Widget> _pages = [];

class _PageListKaryawanState extends State<PageListKaryawan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentIndex = 0;
    });
    _pages = [ListKaryawan(), ListKaryawanRelief()];
  }

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
            label: 'Crew Rig',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Crew Rig Relief',
          ),
        ],
      ),
    );
  }
}
