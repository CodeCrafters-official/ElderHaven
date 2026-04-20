import 'package:flutter/material.dart';

class LabTestsScreen extends StatefulWidget {
  @override
  _LabTestsScreenState createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen> {
  final List<String> labTests = [
    'Complete Blood Count (CBC)',
    'Blood Pressure Test',
    'Cholesterol Test',
    'Glucose Test',
    'Liver Function Test',
    'Kidney Function Test',
    'Thyroid Test',
    'Urinalysis',
    'Vitamin D Test',
    'Electrolyte Panel',
    'Hemoglobin A1c',
    'Prostate-Specific Antigen (PSA)',
  ];

  final Set<String> favoriteTests = Set<String>(); // Track favorite tests
  List<String> filteredTests = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTests = labTests; // Initially show all tests
  }

  void _filterTests() {
    setState(() {
      filteredTests = labTests
          .where((test) => test.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _toggleFavorite(String test) {
    setState(() {
      if (favoriteTests.contains(test)) {
        favoriteTests.remove(test);
      } else {
        favoriteTests.add(test);
      }
      _reorderTests();
    });
  }

  void _reorderTests() {
    filteredTests.sort((a, b) {
      final isAFavorite = favoriteTests.contains(a);
      final isBFavorite = favoriteTests.contains(b);

      if (isAFavorite && !isBFavorite) {
        return -1; // a is favorite, so it should come first
      } else if (!isAFavorite && isBFavorite) {
        return 1; // b is favorite, so it should come first
      }
      return 0;
    });
  }

  void _navigateToBooking(String testName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LabTestBookingScreen(testName: testName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search lab tests',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterTests();
                });
              },
            ),
            SizedBox(height: 16),
            if (filteredTests.isEmpty)
              Center(
                child: Text(
                  'No tests found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            if (filteredTests.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTests.length,
                  itemBuilder: (context, index) {
                    final test = filteredTests[index];
                    final isFavorite = favoriteTests.contains(test);

                    return ListTile(
                      title: Text(
                        test,
                        style: TextStyle(
                          color: Colors.black, // Set text color to black
                          decoration: TextDecoration.none, // No underline
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(Icons.medical_services, color: Colors.blueAccent),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFavorite(test); // Toggle favorite
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              _navigateToBooking(test); // Navigate to booking
                            },
                            child: Text(
                              'Book',
                              style: TextStyle(
                                color: Colors.black, // Set "Book" text to black
                                decoration: TextDecoration.none, // No underline
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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

class LabTestBookingScreen extends StatelessWidget {
  final String testName;

  LabTestBookingScreen({required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$testName Booking',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Overview:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This $testName will provide detailed insights into your health metrics. '
                          'You can book the test at a nearby lab, or opt for a home sample collection.',
                      style: TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1),
                    SizedBox(height: 10),
                    Text(
                      'Booking Instructions:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Ensure you have fasted for at least 8 hours (if required for the test).\n'
                          '2. Bring a valid ID and previous medical records if necessary.\n'
                          '3. You can choose between visiting the lab or home collection during booking.',
                      style: TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                    ),
                    SizedBox(height: 20),
                    Divider(thickness: 1),
                    SizedBox(height: 20),
                    Text(
                      'Booking Contact:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'To complete the booking process, contact your nearest lab or schedule a home sample collection via our app.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle logic for booking confirmation
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
