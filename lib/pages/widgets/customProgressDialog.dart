import 'package:flutter/material.dart';

class CustomProgressDialog extends StatefulWidget {
  final String message;
  final int total;
  final int current;

  CustomProgressDialog({
    required this.message,
    required this.total,
    required this.current,
  });

  @override
  _CustomProgressDialogState createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog> {
  double _progress = 0.0;

  void update({required double progress}) {
    setState(() {
      _progress = progress;
    });
  }

  void hide() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Progress'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _progress,
          ),
          SizedBox(height: 8),
          Text('${widget.current}/${widget.total}'),
          SizedBox(height: 8),
          Text(widget.message),
        ],
      ),
    );
  }
}
