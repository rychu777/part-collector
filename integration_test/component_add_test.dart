import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Dodaj build z nazwą Test oraz komponenty', (WidgetTester tester) async {
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

    final components = [
      'Procesor',
      'Karta graficzna',
      'Pamięć RAM',
      'Płyta główna',
      'Chłodzenie',
      'Zasilacz',
      'Obudowa',
      'Dysk',
    ];

    for (final component in components) {
      final componentTile = find.text(component);
      expect(componentTile, findsOneWidget);

      await tester.tap(componentTile);
      await tester.pumpAndSettle();

      // Zakładamy, że pierwszy przycisk "Dodaj" jest wystarczający
      final addFirstOption = find.widgetWithText(ElevatedButton, 'Dodaj').first;
      expect(addFirstOption, findsOneWidget);

      await tester.tap(addFirstOption);
      await tester.pumpAndSettle();
    }

    final summaryButton = find.text('Podsumowanie');
    expect(summaryButton, findsOneWidget);
    await tester.tap(summaryButton);
    await tester.pumpAndSettle();

    expect(find.text('Podsumowanie'), findsOneWidget);
    expect(find.text('Twój zestaw jest gotowy!'), findsOneWidget);

    final saveButton = find.text('Zapisz');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final confirmSaveButton = find.text('Zapisz mimo to');
    expect(confirmSaveButton, findsOneWidget);
    await tester.tap(confirmSaveButton);
    await tester.pumpAndSettle();

    final card = find.byKey(const Key('build_card_Test'));
    expect(card, findsOneWidget);

    final gesture1 = await tester.startGesture(tester.getCenter(card));
    await tester.pumpAndSettle(const Duration(milliseconds: 900));
    await gesture1.up();
    await tester.pumpAndSettle(const Duration(microseconds: 100));

    final cancelDeleteButton = find.byKey(const Key('delete_cancel'));
    expect(cancelDeleteButton, findsOneWidget);

    final confirmDeleteButton = find.byKey(const Key('delete_ok'));
    expect(confirmDeleteButton, findsOneWidget);
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle();
  });
}