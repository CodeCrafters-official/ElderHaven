import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'font_size_provider.dart'; // Import the font size provider

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController fontSizeController = TextEditingController();
  bool notificationsEnabled = true; // Default state for notifications

  // Replace with your UPI ID
  final String upiId = "nithinsathish05@okhdfcbank"; // Update with your UPI ID
  final String upiName = "ElderHaven"; // Update with your name
  final double premiumAmount = 200.0;

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context); // Access the provider

    // Set the initial text in the controller to the current font size
    fontSizeController.text = fontSizeProvider.fontSize.toString();

    // Define your app's background color
    Color appBackgroundColor = Colors.grey[200] ?? Colors.white; // Replace with your app background color

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
            SizedBox(height: 20),

            // Logo at the top
            Center(
              child: Image.asset(
                'assets/logo.png', // Path to your logo
                width: 200, // Adjust width as needed
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20), // Space below the logo

            // Font Size Adjustment Section
            Text(
              'Adjust Font Size',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20),

            // Row for Font Size Adjustment
            Row(
              children: [
                Text('Font Size: '),
                SizedBox(width: 10),
                // Compact input field for manual font size entry
                Container(
                  width: 80, // Smaller width for the text field
                  child: TextField(
                    controller: fontSizeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true, // Compact appearance
                      contentPadding: EdgeInsets.all(8), // Less padding inside the field
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (input) {
                      double? newSize = double.tryParse(input);
                      if (newSize != null && newSize >= 10.0 && newSize <= 30.0) {
                        fontSizeProvider.setFontSize(newSize); // Update the font size
                      } else {
                        // Show error message if input is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a value between 10 and 30')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Notifications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18.0),
                ),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Premium Features Section
            GestureDetector(
              onTap: () => _launchUPILink(context),
              child: Text(
                'Premium Features - ₹99',
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),

            // Help & Support Section
            GestureDetector(
              onTap: () {
                // Handle support action
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Support'),
                      content: Text('For support, please contact us at official.codecrafters.team@gmail.com'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                      backgroundColor: appBackgroundColor, // Set dialog background to app color
                    );
                  },
                );
              },
              child: Text(
                'Help & Support',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),

            // Terms & Conditions Section
            GestureDetector(
              onTap: () {
                // Handle action to display terms and conditions
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Terms & Conditions'),
                      content: Text(
                        '1. Introduction\n'
                            '   These terms and conditions govern your use of our application.\n\n'
                            '2. User Obligations\n'
                            '   Users must comply with all applicable laws and regulations.\n\n'
                            '3. Limitation of Liability\n'
                            '   We are not liable for any indirect or consequential losses.\n\n'
                            '4. Changes to Terms\n'
                            '   We reserve the right to modify these terms at any time.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                      backgroundColor: appBackgroundColor, // Set dialog background to app color
                    );
                  },
                );
              },
              child: Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),

            // About the App Section
            GestureDetector(
              onTap: () {
                // Handle action to display app info
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About the App'),
                      content: Text(
                        'This app is designed to assist the elderly in various tasks, '
                            'providing features like easy navigation, reminders, and '
                            'support for daily activities to enhance their quality of life.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                      backgroundColor: appBackgroundColor, // Set dialog background to app color
                    );
                  },
                );
              },
              child: Text(
                'About the App',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUPILink(BuildContext context) async {
    String url = "upi://pay?pa=$upiId&pn=$upiName&mc=&tid=1234567890&am=$premiumAmount&tn=Premium%20Features%20Payment&cu=INR";

    try {
      // Check if the URL can be launched
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        // If URL can't be launched, notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch payment page. Please check your UPI app.')),
        );
      }
    } catch (e) {
      // Catch any exceptions and show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
