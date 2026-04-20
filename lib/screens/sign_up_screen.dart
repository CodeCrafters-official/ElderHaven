import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ensure this path is correct
import 'login_screen.dart'; // Ensure this path is correct

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Toggle for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Sign-up logic
  void _handleSignUp(BuildContext context) {
    String username = _usernameController.text; // Get username
    String password = _passwordController.text; // Get password
    String confirmPassword = _confirmPasswordController.text; // Get confirm password

    // Check if passwords match
    if (password == confirmPassword) {
      // If passwords match, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // If passwords don't match, show dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign-Up Failed'),
          content: Text('Passwords do not match.'), // Inform user about password mismatch
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the form
        child: Column(
          children: [
            // Back button with icon at the top
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue), // Back arrow icon
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the login screen
                },
              ),
            ),
            SizedBox(height: 20), // Space between button and fields

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sign up fields aligned to the left
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username input field
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username', // Label for username field
                            border: OutlineInputBorder(), // Input border style
                          ),
                          style: TextStyle(color: Colors.black), // Set text color to black
                          onSubmitted: (value) {
                            FocusScope.of(context).nextFocus(); // Move to the next field
                          },
                        ),
                        SizedBox(height: 20), // Space between fields

                        // Password input field
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password', // Label for password field
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword; // Toggle password visibility
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword, // Hide password input
                          style: TextStyle(color: Colors.black), // Set text color to black
                          onSubmitted: (value) {
                            FocusScope.of(context).nextFocus(); // Move to the next field
                          },
                        ),
                        SizedBox(height: 20),

                        // Confirm Password input field
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password', // Label for confirm password field
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword; // Toggle password visibility
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword, // Hide confirm password input
                          style: TextStyle(color: Colors.black), // Set text color to black
                          onSubmitted: (value) {
                            _handleSignUp(context); // Call the sign-up function when pressing Enter
                          },
                        ),
                        SizedBox(height: 20),

                        // Sign-up button
                        ElevatedButton(
                          onPressed: () {
                            _handleSignUp(context); // Call the sign-up function
                          },
                          child: Text('Sign Up', style: TextStyle(color: Colors.black)), // Button label
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue, // Button background color
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Logo aligned to the right
                  Container(
                    width: 800, // Logo width
                    height: 800, // Logo height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'), // Replace with your logo path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
