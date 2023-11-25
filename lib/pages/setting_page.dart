import 'package:face_net_authentication/globals.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late double _threshold;
  late TextEditingController _thresholdController;
  late int _delayTimeout;
  late TextEditingController _delayController;
  late bool landscapeMode;

  @override
  void initState() {
    super.initState();
    _loadThreshold();
    _thresholdController = TextEditingController();
    _loadDelayTimeout();
    _loadLandscapeMode();
    _delayController = TextEditingController();
  }

  _loadThreshold() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _threshold = await prefs.getDouble('threshold') ?? 0.8;
    setState(() {
      _thresholdController.text = _threshold.toStringAsFixed(1);
    });
  }

  _loadDelayTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _delayTimeout = await prefs.getInt('DELAY_TIMEOUT') ?? 3;
    setState(() {
      _delayController.text = _delayTimeout.toString();
    });
  }

    _loadLandscapeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() async {
     landscapeMode = await prefs.getBool('LANDSCAPE_MODE') ?? false;
    });
  }


  _saveDelayTimeout() async {
    int newDelayTimeout = int.parse(_delayController.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('DELAY_TIMEOUT', newDelayTimeout);
  }

  _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Restart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Anda yakin ingin menyimpan perubahan dan merestart aplikasi?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () async {
                Navigator.of(context).pop();
                saveThreshold(_thresholdController.text);
                _saveDelayTimeout();
                await _restartApp();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _restartApp() async {
     Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Threshold'),
            Slider(
              value: _threshold,
              onChanged: (newValue) {
                setState(() {
                  _threshold = newValue;
                  _thresholdController.text = _threshold.toStringAsFixed(1);
                });
              },
              min: 0.5,
              max: 0.9,
              divisions: 4,
              label: _threshold.toStringAsFixed(1),
            ),
            SizedBox(height: 20),
            Text('Timeout Delay (detik)'),
            Slider(
              value: _delayTimeout.toDouble(),
              onChanged: (newValue) {
                setState(() {
                  _delayTimeout = newValue.toInt();
                  _delayController.text = _delayTimeout.toString();
                });
              },
              min: 3,
              max: 10,
              divisions: 15,
              label: _delayTimeout.toString(),
            ),
            SizedBox(height: 20),
            Row(children: [
              Text("Mode Landscape"),
              Switch(value: landscapeMode, onChanged: (value) async {
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("LANDSCAPE_MODE", value);
                setState(() {
                  landscapeMode = value;
                });
              },)
            ],),
                        SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _showConfirmationDialog(context);
              },
              child: Text('Simpan dan Restart Aplikasi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _delayController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingPage(),
  ));
}
