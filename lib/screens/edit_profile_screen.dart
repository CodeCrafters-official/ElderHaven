import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load existing profile data
  }

  // Function to load existing profile data from SharedPreferences
  void _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
  }

  // Function to save the updated profile data to SharedPreferences
  void _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    Navigator.pop(context); // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData, // Save changes on button press
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
