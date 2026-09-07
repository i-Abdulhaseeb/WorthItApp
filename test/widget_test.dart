import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worthitapp/main.dart';

void main() {
  testWidgets('Splash screen smoke and navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Expect splash screen elements to be present initially
    expect(find.text('SMARTER DECISIONS  •  BETTER YOU'), findsOneWidget);

    // Advance timer past 3 seconds to navigate to Home
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify Home tab loaded
    expect(find.text('Good Morning'), findsOneWidget);

    // Tap Decisions tab
    await tester.tap(find.byIcon(Icons.gavel));
    await tester.pumpAndSettle();
    expect(find.text('Decisions View'), findsOneWidget);

    // Tap Insights tab
    await tester.tap(find.byIcon(Icons.insights));
    await tester.pumpAndSettle();
    expect(find.text('Insights View'), findsOneWidget);

    // Tap Settings tab
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings View'), findsOneWidget);
  });
}
