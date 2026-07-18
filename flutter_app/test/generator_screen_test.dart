import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hitster_bingo/data/challenges.dart';
import 'package:hitster_bingo/screens/generator_screen.dart';

void main() {
  testWidgets('Spinning the wheel varies the result and reveals a matching card',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GeneratorScreen()));
    await tester.pump(const Duration(milliseconds: 100));

    final seenTitles = <String>{};

    for (var i = 0; i < 15; i++) {
      await tester.tap(find.text('Slumpa Utmaning!'));
      await tester.pump();
      // Let the ~2.6s wheel spin and the reveal animation finish.
      await tester.pump(const Duration(milliseconds: 2700));
      await tester.pump(const Duration(milliseconds: 600));

      final matches = challenges.where((c) => find.text(c.titel).evaluate().isNotEmpty);
      expect(matches.length, 1, reason: 'Exactly one revealed challenge title should be visible');
      seenTitles.add(matches.first.titel);
    }

    expect(seenTitles.length, greaterThan(1),
        reason: 'Across 15 spins the wheel should land on more than one challenge');
  });
}
