import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_translate/app/app.dart';
import 'package:tdd_translate/features/translate/view/pages/search_page.dart';

void main() {
  group("App", () {
    testWidgets("Renders Search Page", (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(SearchPage), findsOneWidget);
    });
  });
}
