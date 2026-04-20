import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class MedicalEmergencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when tapped
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Contacts:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildEmergencyContactItem('Ambulance', '102'),
            _buildEmergencyContactItem('Police', '100'),
            _buildEmergencyContactItem('Fire Brigade', '101'),
            _buildEmergencyContactItem('Poison Control', '1800 11 90 99'),
            _buildEmergencyContactItem('Local Hospital', 'XX-XXXX-XXXX'), // Replace with actual number
            // Add more contacts as needed
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactItem(String title, String contactNumber) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Make the background transparent
        borderRadius: BorderRadius.circular(10), // Rounded corners for each item
        border: Border.all(color: Colors.grey, width: 1), // Add border if you need
      ),
      margin: EdgeInsets.symmetric(vertical: 8), // Add vertical margin between items
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Call: $contactNumber'),
        onTap: () {
          _makePhoneCall(contactNumber); // Call the function when tapped
        },
      ),
    );
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber); // Create the phone URI
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString()); // Launch the dialer with the contact number
    } else {
      throw 'Could not make the call to $phoneNumber'; // Handle the error if the call can't be made
    }
  }
}
