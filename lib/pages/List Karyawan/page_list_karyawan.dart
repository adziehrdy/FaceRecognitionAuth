import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/List%20Karyawan/list_karyawan.dart';
import 'package:face_net_authentication/pages/List%20Karyawan/list_karyawan_relief.dart';
import 'package:face_net_authentication/pages/List%20Karyawan/list_karyawan_tambahan_fls.dart';
import 'package:flutter/material.dart';

class PageListKaryawan extends StatefulWidget {
  const PageListKaryawan({Key? key}) : super(key: key);

  @override
  _PageListKaryawanState createState() => _PageListKaryawanState();
}

int _currentIndex = 0;
List<Widget> _pages = [];
String deviceRole = "";

class _PageListKaryawanState extends State<PageListKaryawan> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final role = await getDeviceRole();

    setState(() {
      deviceRole = role;
      _currentIndex = 0;

      if (deviceRole == "FLS") {
        _pages = [ListKaryawan(), ListKaryawanTambahanFLS()];
      } else {
        _pages = [ListKaryawan(), ListKaryawanRelief()];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Crew Rig',
          ),
          deviceRole == "FLS"
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: 'Crew Rig Tambahan',
                )
              : const BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: 'Crew Rig Relief',
                ),
        ],
      ),
    );
  }
}
