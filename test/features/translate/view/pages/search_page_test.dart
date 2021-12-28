import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_translate/app/app.dart';
import 'package:tdd_translate/core/locator.dart' as locator;
import 'package:tdd_translate/features/translate/view/pages/search_page.dart';

void main() {
  group("App", () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await locator.init();
    });

    testWidgets("Renders Search Page", (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);
    });

    testWidgets("Should have appbar", (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      final appbar = find.byType(AppBar);
      expect(appbar, findsOneWidget);
    });

    testWidgets("Appbar should have title TDD Translate", (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      final textWidget = find.text("TDD Translate");
      expect(textWidget, findsOneWidget);
    });
  });
}
