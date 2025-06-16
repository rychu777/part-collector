import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/views/SummaryViewMVVM.dart';

// flutter test test/summary_widget_test.dart
void main() {
  testWidgets('SummaryViewMVVM renders and responds to button taps', (WidgetTester tester) async {
    // Przykładowa lista komponentów
    final components = [
      Component(
        id: '1',
        name: 'CPU Test',
        category: 'CPU',
        price: 500.0,
        description: 'Test CPU',
        imageUrls: [],
        specs: {'cores': '4', 'threads': '8'},
        manufacturer: 'Intel',
        compatibilityTag: '',
      ),
    ];

    // Budujemy widget pod test
    await tester.pumpWidget(
      MaterialApp(
        home: SummaryViewMVVM(
          buildName: 'TestBuild',
          components: components,
          onSaveConfiguration: (_) async {}, // pusta funkcja async
          isSlotIncompatible: {}, // brak niekompatybilności
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Sprawdź, czy ekran zawiera konkretny tekst
    expect(find.text('Twój zestaw jest gotowy!'), findsOneWidget);

    // Sprawdź czy są przyciski Powrót i Zapisz
    expect(find.widgetWithText(ElevatedButton, 'Powrót'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Zapisz'), findsOneWidget);

    // Kliknij przycisk Powrót i sprawdź czy ekran się zamknął (Navigator.pop)
    // Tutaj by wymusić Navigator.pop, otwieramy ten ekran w Navigatorze
    bool didPop = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            child: const Text('Open Summary'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SummaryViewMVVM(
                    buildName: 'TestBuild',
                    components: components,
                    onSaveConfiguration: (_) async {},
                    isSlotIncompatible: {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    // Otwórz ekran SummaryViewMVVM
    await tester.tap(find.text('Open Summary'));
    await tester.pumpAndSettle();

    // Teraz kliknij Powrót
    await tester.tap(find.widgetWithText(ElevatedButton, 'Powrót'));
    await tester.pumpAndSettle();

    // Po pop ekran SummaryViewMVVM nie powinien być już widoczny
    expect(find.text('Twój zestaw jest gotowy!'), findsNothing);
  });
}
