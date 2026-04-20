import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HealthTrackingScreen extends StatefulWidget {
  @override
  _HealthTrackingScreenState createState() => _HealthTrackingScreenState();
}

class ManualEntry {
  final String type;
  final String value;
  final DateTime date;

  ManualEntry({required this.type, required this.value, required this.date});
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  HealthFactory health = HealthFactory();
  List<HealthDataPoint> healthData = [];
  List<ManualEntry> manualEntries = [];
  bool isLoading = false;

  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    checkBluetoothStatus();
    fetchHealthData();
  }

  // Fetch health data from the system
  Future<void> fetchHealthData() async {
    setState(() {
      isLoading = true;
    });

    final permissions = [
      HealthDataType.HEART_RATE,
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    ];

    bool requested = await health.requestAuthorization(permissions);
    if (requested) {
      List<HealthDataPoint> fetchedData = await health.getHealthDataFromTypes(
        DateTime.now().subtract(Duration(days: 7)),
        DateTime.now(),
        permissions,
      );
      setState(() {
        healthData = HealthFactory.removeDuplicates(fetchedData);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Permissions not granted.');
    }
  }

  // Start scanning for Bluetooth devices
  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      if (!isScanning && scanResults.isEmpty) {
        _showErrorDialog('No Bluetooth devices found.');
      }
    });
  }

  // Check Bluetooth availability
  void checkBluetoothStatus() async {
    var available = await FlutterBluePlus.isAvailable;
    var on = await FlutterBluePlus.isOn;
    if (!available || !on) {
      _showErrorDialog('Bluetooth is not available or not turned on.');
    } else {
      startScan();
    }
  }

  // Connect to a Bluetooth device
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      _showErrorDialog("Connected to ${device.platformName}");
    } catch (e) {
      _showErrorDialog("Failed to connect: $e");
    }
  }

  // Show dialog for error or info messages
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Info'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Add manual health data entry
  void _addManualEntryDialog() {
    TextEditingController typeController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manual Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Data Type (e.g., Heart Rate)'),
            ),
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (typeController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                setState(() {
                  manualEntries.add(ManualEntry(
                    type: typeController.text,
                    value: valueController.text,
                    date: DateTime.now(),
                  ));
                });
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: healthData.length + manualEntries.length,
              itemBuilder: (context, index) {
                if (index < healthData.length) {
                  final data = healthData[index];
                  return ListTile(
                    title: Text('${data.typeString}: ${data.value}'),
                    subtitle:
                    Text(DateFormat.yMMMd().format(data.dateFrom)),
                  );
                } else {
                  final manual = manualEntries[index - healthData.length];
                  return ListTile(
                    title: Text('${manual.type}: ${manual.value} (Manual)'),
                    subtitle: Text(DateFormat.yMMMd().format(manual.date)),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: fetchHealthData,
                child: Text('Refresh Data', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              ElevatedButton(
                onPressed: _addManualEntryDialog,
                child: Text('Add Manual Entry', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Available Bluetooth Devices:', style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                final result = scanResults[index];
                return ListTile(
                  title: Text(result.device.platformName.isNotEmpty
                      ? result.device.platformName
                      : "Unknown Device"),
                  subtitle: Text(result.device.remoteId.str),
                  trailing: IconButton(
                    icon: Icon(Icons.bluetooth),
                    onPressed: () => connectToDevice(result.device),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
