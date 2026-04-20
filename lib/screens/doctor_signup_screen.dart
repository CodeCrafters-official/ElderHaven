import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'doctor_home_screen.dart';

class DoctorSignupScreen extends StatefulWidget {
  @override
  _DoctorSignupScreenState createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specializationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final specialization = _specializationController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    final Map<String, String> data = {
      'name': name,
      'email': email,
      'password': password,
      'specialization': specialization,
      'contact_number': phone,
      'location': location,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/doctor_signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
          );
        }
      } else {
        final responseData = json.decode(response.body);
        _showErrorDialog(responseData['message']);
      }
    } catch (error) {
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Doctor Signup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _specializationController,
                      decoration: InputDecoration(
                        labelText: 'Specialization',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _signup,
                    child: Text('Signup'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/doctor_login');
                    },
                    child: Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
