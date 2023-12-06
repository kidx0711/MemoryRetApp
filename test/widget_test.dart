import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simon/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SimonGame());

    // Verify that our counter starts at level 0.
    expect(find.text('Level 0'), findsOneWidget);
    expect(find.text('Level 1'), findsNothing);

    // You can perform interactions and test various scenarios here
    // For example:
    // Tap the 'Start Game' button and verify the level changes

    await tester.tap(find.text('Start Game'));
    await tester.pump();

    expect(find.text('Level 0'), findsNothing);
    expect(find.text('Level 1'), findsOneWidget);
  });
}
