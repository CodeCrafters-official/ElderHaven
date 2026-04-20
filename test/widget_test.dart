import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elderhaven/main.dart'; // Ensure you have the correct import

void main() {
  testWidgets('ElderHavenApp has a title and buttons', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(ElderHavenApp());

    // Verify that the app title is displayed.
    expect(find.text('Elder Haven'), findsOneWidget);

    // Verify the presence of buttons.
    expect(find.text('Health Tracking'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
