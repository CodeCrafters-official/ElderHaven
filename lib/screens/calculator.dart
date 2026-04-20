import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  List<String> _history = [];

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toString();
          _history.insert(0, '$_expression = $_result'); // Save history
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
      }
    });
  }

  Widget _buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18),
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _onPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Keeps your usual background
      body: Column(
        children: [
          // Expression Display
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: Text(
              _expression.isEmpty ? '0' : _expression,
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          // Result Display
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: Text(
              _result,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Divider(),
          // Calculator Buttons
          Container(
            height: 350, // Fixed height to prevent overflow
            child: Column(
              children: [
                Row(children: ['7', '8', '9', '/'].map((e) => _buildButton(e, Colors.blue)).toList()),
                Row(children: ['4', '5', '6', '*'].map((e) => _buildButton(e, Colors.blue)).toList()),
                Row(children: ['1', '2', '3', '-'].map((e) => _buildButton(e, Colors.blue)).toList()),
                Row(children: ['C', '0', '=', '+'].map((e) => _buildButton(e, Colors.red)).toList()),
              ],
            ),
          ),
          Divider(),
          // History Display
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _history[index],
                    style: TextStyle(fontSize: 16),
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
