import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Dodaj build z nazwą Test, następnie go usuń', (WidgetTester tester) async {
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

    final cancelButton = find.byKey(const Key('cancel_button'));
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    await tester.enterText(nameField, 'Test');
    await tester.pumpAndSettle();

    final okButton = find.byKey(const Key('ok_button'));
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
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