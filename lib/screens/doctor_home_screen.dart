import 'package:flutter/material.dart';
import 'doctor_profile_screen.dart';
import 'appointments_screen.dart';
import 'patient_profiles_screen.dart';
import 'medical_records_screen.dart';
import 'prescriptions_screen.dart';
import 'settings_screen.dart';

class DoctorHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Allow the user to go back to the previous screen if needed
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove default back button or title
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          backgroundColor: Colors.transparent, // Transparent AppBar background
          elevation: 0, // Remove shadow under the AppBar
        ),
        drawer: _buildDrawer(context),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Appointments',
                      icon: Icons.calendar_today,
                      color: Colors.green,
                      onTap: () => _navigateTo(context, AppointmentsScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Patient Profiles',
                      icon: Icons.person,
                      color: Colors.purple,
                      onTap: () => _navigateTo(context, PatientProfilesScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Medical Records',
                      icon: Icons.library_books,
                      color: Colors.orange,
                      onTap: () => _navigateTo(context, MedicalRecordsScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Prescriptions',
                      icon: Icons.medication,
                      color: Colors.teal,
                      onTap: () => _navigateTo(context, PrescriptionsScreen()),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Image.asset(
                    'assets/doctor_image.png', // Replace with your image path
                    width: 1000, // Set appropriate width for the image
                    height: 1000, // Set appropriate height for the image
                    fit: BoxFit.contain, // Ensure the image fits well
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Background color for the header
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with the actual path to your app logo
                    width: 130, // Set the logo width
                    height: 130, // Set the logo height
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Doctor Profile'),
            onTap: () => _navigateTo(context, DoctorProfileScreen()),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.green),
            title: Text('Appointments'),
            onTap: () => _navigateTo(context, AppointmentsScreen()),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Settings'),
            onTap: () => _navigateTo(context, SettingsScreen()),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFlatFeatureButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Space between buttons
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.5), // Light background color for the icon
              child: Icon(icon, size: 30, color: color), // Icon with solid color
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

  void _logout(BuildContext context) {
    // Add your logout logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
  }
}
