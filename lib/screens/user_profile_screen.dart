import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'feedback_screen.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadProfileData();
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _saveProfileImagePath(pickedFile.path);
      });
    }
  }

  // Save profile image path to SharedPreferences
  void _saveProfileImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImagePath', path);
  }

  // Load profile image from SharedPreferences
  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('profileImagePath');
    setState(() {
      if (path != null) {
        _profileImage = File(path);
      }
    });
  }

  // Load profile data (name, username, age, dob, height, weight)
  void _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('userName') ?? '';
    _usernameController.text = prefs.getString('username') ?? '';
    _ageController.text = prefs.getString('age') ?? '';
    _dobController.text = prefs.getString('dob') ?? '';
    _heightController.text = prefs.getString('height') ?? '';
    _weightController.text = prefs.getString('weight') ?? '';
  }

  // Save profile data
  void _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _nameController.text);
    prefs.setString('username', _usernameController.text);
    prefs.setString('age', _ageController.text);
    prefs.setString('dob', _dobController.text);
    prefs.setString('height', _heightController.text);
    prefs.setString('weight', _weightController.text);
  }

  // Handle logout
  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // Profile Picture Container
              Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Email/Username'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                            labelText: 'Date of Birth (YYYY-MM-DD)'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _heightController,
                        decoration: InputDecoration(labelText: 'Height (cm)'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _weightController,
                        decoration: InputDecoration(labelText: 'Weight (kg)'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _saveProfileData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile saved successfully!')),
                  );
                },
                child: Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
                child: Text(
                  'Feedback',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _handleLogout(context),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
