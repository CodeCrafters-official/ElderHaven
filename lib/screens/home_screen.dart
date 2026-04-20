//homescreen
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'health_tracking_screen.dart';
import 'medication_screen.dart';
import 'user_profile_screen.dart';
import 'social_connection_screen.dart';
import 'doctor_appointment_screen.dart';
import 'contact_medicals_screen.dart';
import 'health_tips_screen.dart';
import 'lab_screen.dart';
import 'chatbot_screen.dart';
import 'games_screen.dart';
import 'settings_screen.dart';
import 'bmi_calculator_screen.dart';
import 'news.dart';
import 'geofencing_service.dart'; //
import 'calculator.dart';

class HomeScreen extends StatelessWidget {
  final String sosMessage = "Emergency! I need help. My location: ";
  final String recipientPhone = '8124703220'; // Replace with the actual recipient's phone number

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                      title: 'Health Tracking',
                      icon: Icons.health_and_safety,
                      color: Colors.blueAccent,
                      onTap: () => _navigateTo(context, HealthTrackingScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Medication',
                      icon: Icons.medication,
                      color: Colors.green,
                      onTap: () => _navigateTo(context, MedicationScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Social Connection',
                      icon: Icons.group,
                      color: Colors.purple,
                      onTap: () => _navigateTo(context, SocialConnectionScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Doctor Appointment',
                      icon: Icons.calendar_today,
                      color: Colors.orange,
                      onTap: () => _navigateTo(context, DoctorAppointmentScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Contact Medicals',
                      icon: Icons.local_hospital,
                      color: Colors.red,
                      onTap: () => _navigateTo(context, ContactMedicalsScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Health Tips',
                      icon: Icons.info_outline,
                      color: Colors.teal,
                      onTap: () => _navigateTo(context, HealthTipsScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Lab',
                      icon: Icons.assignment,
                      color: Colors.deepOrange,
                      onTap: () => _navigateTo(context, LabScreen()),
                    ),
                    _buildFlatFeatureButton(
                      context: context,
                      title: 'Games',
                      icon: Icons.games,
                      color: Colors.brown,
                      onTap: () => _navigateTo(context, GamesScreen()),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Image.asset(
                    'assets/feature_image.png',
                    width: 1000,
                    height: 1000,
                    fit: BoxFit.contain,
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
              color: Colors.blue,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 130,
                    height: 130,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('User Profile'),
            onTap: () => _navigateTo(context, UserProfileScreen()),
          ),
          ListTile(
            leading: Icon(Icons.chat, color: Colors.green),
            title: Text('Chatbot'),
            onTap: () => _navigateTo(context, ChatScreen()),
          ),
          ListTile(
            leading: Icon(Icons.newspaper, color: Colors.blue),
            title: Text('News'),
            onTap: () => _navigateTo(context, NewsPage()),
          ),
          ListTile(
            leading: Icon(Icons.calculate, color: Colors.grey),
            title: Text('Calculator'),
            onTap: () => _navigateTo(context, CalculatorScreen()),
          ),

          ListTile(
            leading: Icon(Icons.monitor_weight, color: Colors.teal),
            title: Text('BMI Calculator'),
            onTap: () => _navigateTo(context, BMICalculatorScreen()),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.orange),
            title: Text('Settings'),
            onTap: () => _navigateTo(context, SettingsScreen()),
          ),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text('Health SOS'),
            onTap: () => _sendHealthSOS(context),
          ),
          ListTile(
            leading: Icon(Icons.map, color: Colors.purple),
            title: Text('Geofencing SOS'),
            onTap: () => _sendGeofencingSOS(context),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.5),
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

  Future<void> _sendHealthSOS(BuildContext context) async {
    String message = Uri.encodeComponent('$sosMessage [Health Emergency]');
    final Uri smsUri = Uri.parse('sms:$recipientPhone?body=$message');

    if (await launchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send Health SOS message')),
      );
    }
  }

  Future<void> _sendGeofencingSOS(BuildContext context) async {
    String location = await GeofencingService.getCurrentLocation();
    String message = Uri.encodeComponent('$sosMessage $location');
    final Uri smsUri = Uri.parse('sms:$recipientPhone?body=$message');

    if (await launchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send Geofencing SOS message')),
      );
    }
  }
}
