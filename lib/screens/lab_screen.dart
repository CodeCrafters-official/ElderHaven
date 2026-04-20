import 'package:flutter/material.dart';
import 'lab_tests_screen.dart';
import 'lab_reports_screen.dart';

class LabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Custom Back Button at the top-left
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 16), // Add some space after the back button

            // Lab Options
            _buildLabOption(
              context: context,
              title: 'Lab Tests',
              icon: Icons.assignment,
              color: Colors.deepOrange,
              onTap: () => _navigateTo(context, LabTestsScreen()),
            ),
            _buildLabOption(
              context: context,
              title: 'Lab Reports',
              icon: Icons.report,
              color: Colors.indigo,
              onTap: () => _navigateTo(context, LabReportsScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
