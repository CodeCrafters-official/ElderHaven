import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Make sure to import your home screen

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _loadingProgress = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        if (_loadingProgress < 100) {
          _loadingProgress++;
        } else {
          _timer.cancel();
          // After loading is complete, navigate to the home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3E5FC), // Lighter blue color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo in the center
            Container(
              width: 600, // Adjust size as needed
              height: 600,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'), // Ensure your logo is correctly placed in the assets folder
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 1), // Adjust space between the logo and text
            Text(
              'Your Life, Our Priority!', // New text below the logo
              style: TextStyle(
                fontSize: 50,
                color: Colors.black, // Text color
                fontWeight: FontWeight.bold, // Optional: bold text
              ),
            ),
            SizedBox(height: 30), // Space before the progress indicator
            CircularProgressIndicator(
              value: _loadingProgress / 100, // Progress based on loading percentage
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Loading animation color
            ),
            SizedBox(height: 20),
            Text(
              'Loading: $_loadingProgress%', // Display the loading percentage
              style: TextStyle(
                color: Colors.black, // Text color for better contrast
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
