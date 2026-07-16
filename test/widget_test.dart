import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kismet/main.dart';

void main() {
  testWidgets('Kismet app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: If your main.dart requires dotenv or database initialization,
    // you might need to mock them here, but for a simple UI check, this works.
    await tester.pumpWidget(const KismetApp());

    // Verify that the Kismet header is present
    expect(find.text('KISMET'), findsOneWidget);

    // Verify the greeting is present
    expect(find.text('Hi, User'), findsOneWidget);

    // Verify the Serenity search bar hint is present
    expect(find.text('Ask Serenity'), findsOneWidget);
  });
}
