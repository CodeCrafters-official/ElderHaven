// lib/font_size_provider.dart
import 'package:flutter/material.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 16.0; // Default font size

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); // Notify listeners to update UI
  }
}
