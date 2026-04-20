import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here...',
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                _submitFeedback(context);
              },
              child: Text(
                'Submit Feedback',
                style: TextStyle(color: Colors.black), // Text color in button
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Button background color
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle feedback submission
  void _submitFeedback(BuildContext context) async {
    String feedback = _feedbackController.text.trim();

    if (feedback.isNotEmpty) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'official.codecrafters.team@gmail.com',
        query: 'subject=Feedback&body=$feedback',
      );

      // Launch the email client
      if (await canLaunch(emailLaunchUri.toString())) {
        await launch(emailLaunchUri.toString());
        _feedbackController.clear(); // Clear the input field
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch email client.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter feedback before submitting.')),
      );
    }
  }
}
