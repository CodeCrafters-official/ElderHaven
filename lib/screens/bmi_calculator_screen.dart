import 'package:flutter/material.dart';
import 'dart:math';

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode(); // Focus node for weight input

  double _bmi = 0.0;
  String _bmiResult = "";
  String _imagePath = 'assets/default.png'; // Default image path before calculation

  void _calculateBMI() {
    double? heightInCm = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (heightInCm != null && weight != null && heightInCm > 0) {
      double height = heightInCm / 100;
      setState(() {
        _bmi = weight / pow(height, 2);

        // Determine BMI result and image
        if (_bmi < 18.5) {
          _bmiResult = "Underweight";
          _imagePath = 'assets/underweight.png'; // Path to underweight image
        } else if (_bmi >= 18.5 && _bmi < 24.9) {
          _bmiResult = "Normal";
          _imagePath = 'assets/normal.png'; // Path to normal image
        } else if (_bmi >= 25 && _bmi < 29.9) {
          _bmiResult = "Overweight";
          _imagePath = 'assets/overweight.png'; // Path to overweight image
        } else {
          _bmiResult = "Obese";
          _imagePath = 'assets/obese.png'; // Path to obese image
        }
      });
    } else {
      _showErrorDialog("Please enter valid height and weight.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input Error'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Space between back icon and input fields

            // Container for Height Input
            Container(
              width: 150, // Set desired width for height input
              child: TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14), // Smaller font size
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_weightFocusNode),
              ),
            ),
            SizedBox(height: 10),

            // Container for Weight Input
            Container(
              width: 150, // Set desired width for weight input
              child: TextField(
                controller: _weightController,
                focusNode: _weightFocusNode, // Assign focus node
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14), // Smaller font size
                onSubmitted: (_) {
                  _calculateBMI(); // Calculate BMI on Enter key
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: _calculateBMI,
              child: Text(
                'Calculate BMI',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  decoration: TextDecoration.none, // No underline
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BMI Result and text on the left
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI: ${_bmi.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        'Result: $_bmiResult',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  // Image on the right
                  Image.asset(
                    _imagePath,
                    width: 500, // Set desired width
                    height: 500, // Set desired height
                    fit: BoxFit.contain, // Maintain aspect ratio without cutting off
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
