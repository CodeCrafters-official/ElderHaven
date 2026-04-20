import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart'; // Ensure this path is correct
import 'sign_up_screen.dart';
import 'loading_screen.dart'; // Import the loading screen
import 'doctor_login_screen.dart'; // Import the DoctorLoginScreen
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Default usernames and passwords
  final List<Map<String, String>> _defaultCredentials = [
    {'username': 'nithinrogers', 'password': 'priyadharshini'},
    {'username': 'pavithra', 'password': 'pavi'},
    {'username': 'kausika', 'password': 'kausika@1812'},
    {'username': 'arsathmuha', 'password': 'arsath@46'},
    {'username': 'priyadharshini', 'password': 'priya@19'},
    {'username': 'pradeepa', 'password': 'pradeepa@0219'},
  ];
  
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  void _handleLogin(BuildContext context) {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    final credential = _defaultCredentials.firstWhere(
          (cred) => cred['username'] == username && cred['password'] == password,
      orElse: () => {'username': '', 'password': ''},
    );

    if (credential['username'] != '') {
      _saveCredentials(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
      );
    } else {
      _showLoginFailedDialog(context);
    }
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleLogin(context),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorLoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Login as Doctor',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
