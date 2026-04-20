import 'package:flutter/material.dart';

class InsuranceScreen extends StatefulWidget {
  @override
  _InsuranceScreenState createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _provider = '';
  String _policyNumber = '';

  void _saveInsurance() {
    if (_formKey.currentState!.validate()) {
      // Save insurance details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insurance details saved')),
      );
      // Here you can add code to save details to backend or local storage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Insurance Details')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Provider Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the provider name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _provider = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Policy Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the policy number';
                  }
                  return null;
                },
                onChanged: (value) {
                  _policyNumber = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInsurance,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
