import 'package:flutter_test/flutter_test.dart';

import 'package:hitster_bingo/main.dart';

void main() {
  testWidgets('Home screen shows title and menu', (WidgetTester tester) async {
    // The vinyl logo spins continuously, so pumpAndSettle would never
    // settle — pump a few frames instead.
    await tester.pumpWidget(const HitsterBingoApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Hitsterbingo'), findsOneWidget);
    expect(find.text('Slumpgenerator'), findsOneWidget);
    expect(find.text('Bingobricka'), findsOneWidget);
    expect(find.text('Spelinstruktioner'), findsOneWidget);
  });
}
