import 'package:flutter/material.dart';

class OrderMedicinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar background transparent
        elevation: 0, // Remove the shadow under the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Only the back icon in black
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Medicines:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change text color to black
              ),
            ),
            SizedBox(height: 20),
            // Add medicine selection widgets here
            _buildMedicineItem('Paracetamol', context),
            _buildMedicineItem('Ibuprofen', context),
            _buildMedicineItem('Cough Syrup', context),
            _buildMedicineItem('Amoxicillin', context),
            _buildMedicineItem('Metformin', context),
            _buildMedicineItem('Aspirin', context),
            _buildMedicineItem('Lisinopril', context),
            _buildMedicineItem('Simvastatin', context),
            _buildMedicineItem('Omeprazole', context),
            _buildMedicineItem('Cetirizine', context),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle order submission
                  _showOrderConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set the button background color
                ),
                child: Text(
                  'Order Now',
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(String medicineName, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(medicineName),
        trailing: Icon(Icons.add_shopping_cart),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$medicineName added to cart')),
          );
        },
      ),
    );
  }

  void _showOrderConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Confirmed'),
          content: Text('Your medicines have been ordered successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
