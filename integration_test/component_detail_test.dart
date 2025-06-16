import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Zobacz szczegóły części - procesor', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final addButton = find.byKey(const Key('add_build_button'));
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('build_name_textfield'));
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'Test');
    await tester.pumpAndSettle();

    final okButton = find.byKey(const Key('ok_button'));
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final cpuTile = find.text('Procesor');
    expect(cpuTile, findsOneWidget);
    await tester.tap(cpuTile);
    await tester.pumpAndSettle();

    // Znajdź wszystkie przyciski "Szczegóły"
    final allDetailsButtons = find.text('Szczegóły');
    final totalDetails = allDetailsButtons.evaluate().length;
    expect(totalDetails, greaterThan(0), reason: 'Nie znaleziono żadnych przycisków Szczegóły');

    for (int i = 0; i < totalDetails; i++) {
      final detailsButton = allDetailsButtons.at(i);
      expect(detailsButton, findsOneWidget);

      await tester.tap(detailsButton);
      await tester.pumpAndSettle();

      final backButton = find.text('Powrót');
      expect(backButton, findsOneWidget);

      final addButton = find.text('Dodaj');
      expect(addButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  });
}