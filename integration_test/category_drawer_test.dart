import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Zobacz drawer dostępnych kategorii części', (WidgetTester tester) async {
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

    final caseTile = find.text('Obudowa');
    expect(caseTile, findsOneWidget);
    await tester.tap(caseTile);
    await tester.pumpAndSettle();

    final menuButton = find.byTooltip('Open navigation menu');

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

    final informations = [
      'Wybierz procesor',
      'Wybierz kartę graficzną',
      'Wybierz pamięć RAM',
      'Wybierz płytę główną',
      'Wybierz chłodzenie',
      'Wybierz zasilacz',
      'Wybierz obudowę',
      'Wybierz dysk',
    ];

    for (int i = 0; i < components.length; i++) {
      final component = components[i];
      final information = informations[i];

      expect(menuButton, findsOneWidget);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      final componentTile = find.text(component);

      expect(componentTile, findsOneWidget);
      await tester.tap(componentTile);
      await tester.pumpAndSettle();

      expect(find.text(information),findsOneWidget);
    }

    final addPartButton = find.text('Dodaj').first;
    expect(addPartButton, findsOneWidget);
    await tester.tap(addPartButton);
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const Key('save_button'));
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Test'), findsOneWidget);

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

    expect(find.text('Test'), findsNothing);
  });
}