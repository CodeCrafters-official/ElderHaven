// preferences_screen.dart
// preferences_screen.dart
import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _notificationsEnabled = true; // Example preference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value; // Toggle notifications
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save preferences here
                Navigator.pop(context); // Go back
              },
              child: Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
