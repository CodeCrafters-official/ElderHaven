// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/font_size_provider.dart'; // Import your FontSizeProvider


void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ElderHavenApp());
}

class ElderHavenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FontSizeProvider(), // Provide the FontSizeProvider
      child: Consumer<FontSizeProvider>(
        builder: (context, fontSizeProvider, child) {
          return MaterialApp(
            title: 'Elder Haven',
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF81D4FA), // Light Blue
                secondary: Color(0xFFFFAB91), // Light Coral
              ),
              scaffoldBackgroundColor: Color(0xFFE0F2F1), // Soft Gray Background
              cardColor: Color(0xFFB2DFDB), // Light Gray for cards
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: fontSizeProvider.fontSize, color: Colors.black87), // General text color with dynamic font size
                bodyMedium: TextStyle(color: Colors.black54), // Secondary text color
                titleMedium: TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.bold, fontSize: fontSizeProvider.fontSize), // Headline color
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4FC3F7), // Light Blue for buttons
                  textStyle: TextStyle(color: Colors.black), // Button text color
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
