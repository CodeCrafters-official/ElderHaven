import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentsScreen> {
  // Dummy list of appointments. Replace with data from your backend or database.
  List<Map<String, String>> appointments = [
    {
      'patient_name': 'John Doe',
      'appointment_date': '2025-01-25',
      'appointment_time': '10:00 AM',
    },
    {
      'patient_name': 'Jane Smith',
      'appointment_date': '2025-01-25',
      'appointment_time': '11:00 AM',
    },
    {
      'patient_name': 'Mark Lee',
      'appointment_date': '2025-01-26',
      'appointment_time': '09:30 AM',
    },
  ];

  // Function to cancel an appointment
  void cancelAppointment(int index) {
    setState(() {
      appointments.removeAt(index);
    });
    // Call your API or backend to delete the appointment
  }

  // Function to reschedule an appointment
  void rescheduleAppointment(int index) {
    // You can add logic to open a new screen to reschedule the appointment.
    // Here we show a simple dialog to simulate rescheduling.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController dateController = TextEditingController();
        TextEditingController timeController = TextEditingController();
        return AlertDialog(
          title: Text('Reschedule Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'New Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'New Time (HH:MM AM/PM)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Reschedule'),
              onPressed: () {
                setState(() {
                  appointments[index]['appointment_date'] = dateController.text;
                  appointments[index]['appointment_time'] = timeController.text;
                });
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
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                'Patient: ${appointments[index]['patient_name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Date: ${appointments[index]['appointment_date']}\n'
                    'Time: ${appointments[index]['appointment_time']}',
                style: TextStyle(fontSize: 16),
              ),
              trailing: Wrap(
                spacing: 12,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () => rescheduleAppointment(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => cancelAppointment(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
