import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studia/main.dart';

void main() {
  testWidgets('BrainStack builds and renders the onboarding screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const Studia());
    await tester.pumpAndSettle();
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}