import 'package:flutter/material.dart';
import 'order_medicines_screen.dart'; // Import the new screen
import 'medical_emergency_screen.dart'; // Import the medical emergency screen

class ContactMedicalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove the shadow under the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Keep only the back icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40), // Add space from the top of the screen
          _buildMedicalContactItem(
            Icons.local_hospital,
            'Medical Emergency',
            context,
            onTap: () {
              _navigateToMedicalEmergency(context); // Navigate to Medical Emergency screen
            },
          ),
          _buildMedicalContactItem(
            Icons.medication,
            'Order Medicines',
            context,
            onTap: () {
              _navigateToOrderMedicines(context);
            },
          ),
          Spacer(), // This will push the image to the bottom
          Container(
            width: MediaQuery.of(context).size.width, // Get the full width of the screen
            child: Image.asset(
              'assets/medical_image.png', // Add your image path here
              height: 450, // Adjust the height as needed
              fit: BoxFit.cover, // Ensure the image stretches to fill the container
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalContactItem(IconData icon, String title, BuildContext context, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue), // Icon color
            SizedBox(width: 10), // Space between icon and text
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Text color set to black
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOrderMedicines(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderMedicinesScreen()),
    );
  }

  void _navigateToMedicalEmergency(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicalEmergencyScreen()), // Navigate to Medical Emergency screen
    );
  }
}
