// profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String bio;

  ProfileScreen({required this.username, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Bio:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(bio),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add Friend logic
              },
              child: Text('Add Friend'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Send Message logic
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
