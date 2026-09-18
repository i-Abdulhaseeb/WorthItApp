import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worthitapp/main.dart';

void main() {
  testWidgets('Splash screen smoke and navigation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    // Expect splash screen elements to be present initially
    expect(find.text('SMARTER DECISIONS  •  BETTER YOU'), findsOneWidget);

    // Advance timer past 3 seconds to navigate to Home
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Verify Home tab loaded
    expect(find.text('Good morning'), findsOneWidget);

    // Tap Decisions tab
    await tester.tap(find.byIcon(Icons.gavel_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Decisions View'), findsOneWidget);

    // Tap Insights tab
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Insights View'), findsOneWidget);

    // Tap Settings tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2)); // Header + BottomNav label
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Alex Mercer'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    // 1. Test Name Popup
    await tester.tap(find.text('Name'));
    await tester.pumpAndSettle();
    expect(find.text('YOUR NAME'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Haseeb');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Haseeb'), findsOneWidget);

    // 2. Test Currency Popup
    await tester.tap(find.text('Currency'));
    await tester.pumpAndSettle();
    expect(find.text('What currency do you\nthink in?'), findsOneWidget);
    await tester.tap(find.text('PKR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('PKR (Rs)'), findsOneWidget);

    // 3. Test Income Popup
    await tester.tap(find.text('Income'));
    await tester.pumpAndSettle();
    expect(find.text('Monthly income'), findsOneWidget);
    await tester.tap(find.text('85,000'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('PKR 85,000 / mo'), findsOneWidget);

    // 4. Test Working Hours Popup
    await tester.tap(find.text('Working hours'));
    await tester.pumpAndSettle();
    expect(find.text('Weekly work allocation'), findsOneWidget);
    await tester.tap(find.text('50h'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('50h / week'), findsOneWidget);
  });
}

