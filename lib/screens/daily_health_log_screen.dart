import 'package:flutter/material.dart';

class DailyHealthLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Health Log'),
      ),
      body: Center(
        child: Text(
          'Daily Health Logs will be displayed here.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
