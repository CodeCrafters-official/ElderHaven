
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _errorMessage = '';

  // Function to handle password change
  void _changePassword() {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Basic validation
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New passwords do not match.';
      });
      return;
    }

    // TODO: Implement password change logic here

    // On successful change
    setState(() {
      _errorMessage = ''; // Clear error message
    });

    // Optionally show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password changed successfully!')),
    );

    Navigator.pop(context); // Go back after changing password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Back icon at the top of the page
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous screen
                  },
                ),
                Spacer(),
              ],
            ),
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty) // Display error message if any
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changePassword, // Change password on button press
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.black), // Text color in button
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Button background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
