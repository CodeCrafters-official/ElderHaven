import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Medication> medications = [];
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize timezone data
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  void _addMedication() {
    if (_medicationController.text.isNotEmpty && _dosageController.text.isNotEmpty) {
      final medication = Medication(
        id: medications.length + 1, // Generate a unique ID
        name: _medicationController.text,
        dosage: _dosageController.text,
      );

      setState(() {
        medications.add(medication);
        _scheduleNotification(medication); // Schedule notification for the new medication
        _medicationController.clear();
        _dosageController.clear();
      });
    }
  }

  void _scheduleNotification(Medication medication) async {
    final now = DateTime.now();
    final scheduledDateTime = DateTime(now.year, now.month, now.day, 9, 0); // Example fixed time at 9 AM

    // Convert DateTime to TZDateTime
    final tz.TZDateTime tzScheduledDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      medication.id,
      'Medication Reminder',
      'Time to take your medication: ${medication.name} - ${medication.dosage}',
      tzScheduledDateTime, // Use the TZDateTime here
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Notifications',
          channelDescription: 'Channel for medication reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily if needed
    );
  }

  void _editMedication(int index) {
    _medicationController.text = medications[index].name;
    _dosageController.text = medications[index].dosage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Medication'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _medicationController),
              TextField(controller: _dosageController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  medications[index] = Medication(
                    id: medications[index].id, // Maintain the same ID
                    name: _medicationController.text,
                    dosage: _dosageController.text,
                  );
                  _medicationController.clear();
                  _dosageController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _medicationController,
              decoration: InputDecoration(
                labelText: 'Add Medication',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _addMedication();
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: 'Add Dosage',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _addMedication();
              },
            ),
            TextButton(
              onPressed: _addMedication,
              child: Text('Add Reminder', style: TextStyle(color: Colors.black)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${medications[index].name} - ${medications[index].dosage}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Use icon for removal
                      onPressed: () => _deleteMedication(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Medication {
  final int id; // Unique identifier for the notification
  final String name;
  final String dosage;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
  });
}
