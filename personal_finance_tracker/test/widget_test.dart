import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Test a simple MaterialApp widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          body: const Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );

    // Verify the widget loads
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
  });
}
