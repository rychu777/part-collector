import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> waitForText(
      WidgetTester tester,
      String text, {
        Duration timeout = const Duration(seconds: 5),
        Duration step = const Duration(milliseconds: 100),
      }) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(step);
      if (find.text(text).evaluate().isNotEmpty) return;
    }
    throw Exception('Nie znaleziono tekstu: $text');
  }

  testWidgets('Dodaj build z nazwą Test, utworzony przez asystenta', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final assistantButton = find.byKey(const Key('assistant_button'));
    expect(assistantButton, findsOneWidget);
    await tester.tap(assistantButton);
    await tester.pumpAndSettle();

    // Step 1
    final options1 = [
      'Gaming',
      'Biurowe',
      'Rendering',
      'Obliczenia',
      'Rendering',
    ];
    for (final option in options1) {
      final componentTile = find.text(option);
      expect(componentTile, findsOneWidget);

      await tester.tap(componentTile);
      await tester.pumpAndSettle();
    }

    final nextButton = find.text('Dalej');

    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Step 2
    final options2 = [
      'Możliwość\nrozbudowy',
      'Niezawodność',
      'Kultura\npracy',
      'Wydajność',
    ];
    for (final option in options2) {
      final componentTile = find.text(option);
      expect(componentTile, findsOneWidget);

      await tester.tap(componentTile);
      await tester.pumpAndSettle();
    }
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Step 3
    final budgetList = find.text('Wybierz budżet');
    expect(budgetList, findsOneWidget);
    await tester.tap(budgetList, warnIfMissed: false);
    await tester.pumpAndSettle();

    final testBudget = find.text('6000 zł');
    expect(testBudget, findsOneWidget);
    await tester.tap(testBudget);
    await tester.pumpAndSettle();

    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Step 4
    final options4 = [
      'AMD',
      'Intel',
      'NVIDIA',
      'Wodne',
      'Klasyczne',
    ];
    for (final option in options4) {
      final componentTile = find.text(option).first;
      expect(componentTile, findsOneWidget);

      await tester.tap(componentTile);
      await tester.pumpAndSettle();
    }

    final finishButton = find.text('Zakończ');
    expect(finishButton, findsOneWidget);
    await tester.tap(finishButton);
    await tester.pump();

    await waitForText(tester, 'Nazwa zestawu');

    final nameField = find.byKey(const Key('build_name_textfield'));
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, 'AssistantTest');
    await tester.pumpAndSettle();

    final okButton = find.text('OK');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final card = find.text('AssistantTest').first;
    expect(card, findsOneWidget);
    await tester.tap(card);
    await tester.pumpAndSettle();

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