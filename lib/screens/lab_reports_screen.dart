import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Assuming a User class to represent user profile
class User {
  final String name;

  User(this.name);
}

// Sample user profile
final User currentUser = User("Nithin"); // Replace with dynamic user data

class LabReportsScreen extends StatefulWidget {
  @override
  _LabReportsScreenState createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends State<LabReportsScreen> {
  final List<Map<String, String>> labReports = [
    {
      'name': 'Complete Blood Count (CBC) Report',
      'doctorName': 'Dr. Smith',
      'labName': 'City Lab',
      'testType': 'Blood Test',
      'result': 'Normal',
      'date': '2024-10-23',
      'comments': 'All parameters within normal range.',
    },
    {
      'name': 'Blood Pressure Report',
      'doctorName': 'Dr. Johnson',
      'labName': 'Health Center',
      'testType': 'Blood Test',
      'result': '120/80 mmHg',
      'date': '2024-10-20',
      'comments': 'Blood pressure is normal.',
    },
    {
      'name': 'Cholesterol Report',
      'doctorName': 'Dr. Lee',
      'labName': 'Wellness Lab',
      'testType': 'Blood Test',
      'result': '180 mg/dL',
      'date': '2024-10-18',
      'comments': 'Cholesterol level is healthy.',
    },
    {
      'name': 'Thyroid Function Test (TFT)',
      'doctorName': 'Dr. Carter',
      'labName': 'Endocrine Lab',
      'testType': 'Hormonal Test',
      'result': 'Normal',
      'date': '2024-10-15',
      'comments': 'Thyroid hormones within normal range.',
    },
    {
      'name': 'Liver Function Test (LFT)',
      'doctorName': 'Dr. Brown',
      'labName': 'Liver Lab',
      'testType': 'Biochemical Test',
      'result': 'Normal',
      'date': '2024-10-10',
      'comments': 'Liver enzymes and functions normal.',
    },
    {
      'name': 'Kidney Function Test (KFT)',
      'doctorName': 'Dr. Wilson',
      'labName': 'Renal Lab',
      'testType': 'Biochemical Test',
      'result': 'Normal',
      'date': '2024-10-05',
      'comments': 'Kidney parameters within normal range.',
    },
    {
      'name': 'Blood Sugar Level Test',
      'doctorName': 'Dr. Davis',
      'labName': 'Diabetes Center',
      'testType': 'Blood Test',
      'result': '90 mg/dL',
      'date': '2024-10-01',
      'comments': 'Blood sugar level is normal.',
    },
    {
      'name': 'Vitamin D Test',
      'doctorName': 'Dr. Miller',
      'labName': 'Nutrition Lab',
      'testType': 'Nutritional Test',
      'result': 'Sufficient',
      'date': '2024-09-28',
      'comments': 'Vitamin D level is adequate.',
    },
    {
      'name': 'Electrolytes Panel',
      'doctorName': 'Dr. Garcia',
      'labName': 'Electrolyte Lab',
      'testType': 'Blood Test',
      'result': 'Normal',
      'date': '2024-09-25',
      'comments': 'Electrolyte levels are normal.',
    },
    {
      'name': 'Infectious Disease Test',
      'doctorName': 'Dr. Martinez',
      'labName': 'Infectious Disease Lab',
      'testType': 'Serological Test',
      'result': 'Negative',
      'date': '2024-09-20',
      'comments': 'No infectious disease detected.',
    },
  ];

  List<Map<String, String>> filteredReports = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredReports = labReports; // Initialize filtered reports
  }

  void filterReports(String query) {
    setState(() {
      searchQuery = query;
      filteredReports = labReports.where((report) {
        return report['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> downloadReportAsPDF(Map<String, String> report) async {
    // Create a PDF document
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Lab Report: ${report['name']}',
                    style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Text('Patient Name: ${currentUser.name}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Doctor Name: ${report['doctorName']}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Lab Name: ${report['labName']}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Test Type: ${report['testType']}', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Result: ${report['result']}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Date: ${report['date']}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Comments: ${report['comments']}', style: pw.TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${report['name']}.pdf';
    final file = File(filePath);

    // Save the PDF file
    await file.writeAsBytes(await pdf.save());

    // Notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded ${report['name']} as PDF')),
    );
  }

  void openReportDetails(Map<String, String> report) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report['name']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Patient Name: ${currentUser.name}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Doctor Name: ${report['doctorName']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lab Name: ${report['labName']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Test Type: ${report['testType']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Result: ${report['result']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date: ${report['date']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Comments: ${report['comments']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.download, size: 30),
                        onPressed: () {
                          downloadReportAsPDF(report); // Call the download function
                          Navigator.pop(context); // Close the dialog after initiating download
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: filterReports,
              decoration: InputDecoration(
                labelText: 'Search Lab Reports',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final report = filteredReports[index];
          return ListTile(
            leading: Icon(Icons.medical_services, color: Colors.blue), // Add an icon here
            title: Text(
              report['name']!,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Doctor: ${report['doctorName']} - Date: ${report['date']}',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () => openReportDetails(report),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LabReportsScreen(),
  ));
}
