import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studia/Core/Constants/app_color.dart';
import 'package:studia/Core/Constants/task_category.dart';
import 'package:studia/Core/Theme/theme_provider.dart';
import 'package:studia/Core/Widgets/primary_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TaskCategory', () {
    test('maps priorities to labels', () {
      expect(TaskCategory.label('high'), 'Development');
      expect(TaskCategory.label('medium'), 'Design');
      expect(TaskCategory.label('low'), 'Study');
      expect(TaskCategory.label('unknown'), 'Study');
    });

    test('maps priorities to consistent background colors', () {
      expect(TaskCategory.background('high'), AppColors.primaryCardColor);
      expect(TaskCategory.background('medium'), AppColors.primaryCard10Color);
      expect(TaskCategory.background('low'), AppColors.backgroundColor);
    });

    test('low priority cards get a border', () {
      expect(TaskCategory.showBorder('low'), isTrue);
      expect(TaskCategory.showBorder('high'), isFalse);
      expect(TaskCategory.showBorder('medium'), isFalse);
    });
  });

  group('ThemeProvider', () {
    test('defaults to system mode when nothing is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.themeMode, ThemeMode.system);
    });

    test('restores stored theme mode and persists changes', () async {
      SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
      final provider = ThemeProvider();
      await Future<void>.delayed(Duration.zero);

      expect(provider.themeMode, ThemeMode.dark);

      await provider.setThemeMode(ThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
      expect(provider.themeMode, ThemeMode.light);
    });
  });

  group('PrimaryButton', () {
    testWidgets('shows its label and triggers the callback',
        (WidgetTester tester) async {
      var pressed = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Start',
              onPressed: () => pressed++,
              width: 140,
            ),
          ),
        ),
      );

      expect(find.text('Start'), findsOneWidget);

      await tester.tap(find.text('Start'));
      expect(pressed, 1);
    });
  });
}