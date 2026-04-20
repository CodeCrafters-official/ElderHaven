import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:convert'; // For JSON handling
import 'package:pdf/pdf.dart'; // For PDF generation
import 'package:pdf/widgets.dart' as pw; // PDF widgets
import 'package:path_provider/path_provider.dart'; // To get the path to save the PDF
import 'dart:io'; // For file handling
import 'package:fluttertoast/fluttertoast.dart'; // For displaying toast messages

class DoctorAppointmentScreen extends StatefulWidget {
  @override
  _DoctorAppointmentScreenState createState() => _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  String? _selectedDoctor;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double? _selectedRating; // For rating doctors

  // List of doctors
  final List<String> _doctors = [
    'Dr. Pavithra',
    'Dr. Priyadharshini',
    'Dr. Kausika',
    'Dr. Lakshmi Pradeepa',
    'Dr. Mohamed Arsath'
  ];

  // List to maintain the queue of appointments
  final List<Map<String, dynamic>> _appointmentsQueue = [];
  final List<Map<String, dynamic>> _appointmentHistory = []; // Appointment history for PDF export

  // Function to handle date picking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle time picking
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function to submit the appointment and add it to the queue
  void _submitAppointment() {
    if (_selectedDoctor != null && _selectedDate != null && _selectedTime != null) {
      // Add appointment to the queue
      _appointmentsQueue.add({
        'doctor': _selectedDoctor,
        'date': _selectedDate,
        'time': _selectedTime,
        'rating': _selectedRating,
      });

      // Add appointment to history for PDF export
      _appointmentHistory.add({
        'doctor': _selectedDoctor,
        'date': _selectedDate,
        'time': _selectedTime,
        'rating': _selectedRating,
      });

      // Get the current queue position
      int queuePosition = _appointmentsQueue.length;

      // Show confirmation dialog with queue position
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Appointment Confirmation'),
          content: Text(
              'Doctor: $_selectedDoctor\nDate: ${DateFormat.yMMMd().format(_selectedDate!)}\nTime: ${_selectedTime!.format(context)}\nYour position in the queue: $queuePosition\nRating: ${_selectedRating?.toString() ?? "Not Rated"}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show error if fields are not filled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select doctor, date, time, and rating.')),
      );
    }
  }

  // Function to export appointment history as PDF
  Future<void> _exportAppointmentHistoryAsPDF() async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Appointment History', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.ListView.builder(
                itemCount: _appointmentHistory.length,
                itemBuilder: (context, index) {
                  final appointment = _appointmentHistory[index];
                  return pw.Text(
                    'Doctor: ${appointment['doctor']}\n'
                        'Date: ${DateFormat.yMMMd().format(appointment['date'])}\n'
                        'Time: ${appointment['time']!.format(context)}\n'
                        'Rating: ${appointment['rating']?.toString() ?? "Not Rated"}\n\n',
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Get the directory to save the PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/appointment_history.pdf');

    try {
      await file.writeAsBytes(await pdf.save());
      // Show success message
      Fluttertoast.showToast(
        msg: "Appointment history exported as PDF!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      // Handle error
      Fluttertoast.showToast(
        msg: "Error exporting PDF: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Doctor Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Doctor'),
              value: _selectedDoctor,
              items: _doctors.map((String doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDoctor = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Select Appointment Date'
                    : 'Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'Select Appointment Time'
                    : 'Time: ${_selectedTime!.format(context)}',
              ),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            SizedBox(height: 20),
            Text('Rate the Doctor:', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < (_selectedRating ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1.0; // 1 to 5 stars
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _submitAppointment,
                  child: Text(
                    'Submit Appointment',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: _exportAppointmentHistoryAsPDF,
                  tooltip: 'Download Appointment History',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
