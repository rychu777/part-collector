import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/widgets/FilterDrawerWidget.dart';

const Color kSurfaceLighter = Colors.white;
const Color kDarkGrey = Colors.black87;
const Color kPurple = Colors.purple;
const Color kWhite = Colors.white;

void main() {
  final Map<String, Set<String>> filterOptions = {
    'Producent': {'AMD', 'Intel'},
    'Socket': {'AM4', 'AM5'},
  };

  final Map<String, Set<String>> selectedFilters = {
    'Producent': {'AMD'},
    'Socket': {},
  };

  group('FilterDrawerWidget', () {
    testWidgets('powinien poprawnie renderować opcje filtrów i zaznaczone wartości', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDrawerWidget(
              filterOptions: filterOptions,
              selectedFilters: selectedFilters,
              onToggleFilter: (key, value, isSelected) {},
              onApplyFilters: () {},
            ),
          ),
        ),
      );

      expect(find.text('Filtry'), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt_outlined), findsOneWidget);

      expect(find.text('Producent'), findsOneWidget);
      expect(find.text('Socket'), findsOneWidget);

      expect(find.text('AMD'), findsOneWidget);
      expect(find.text('Intel'), findsOneWidget);
      expect(find.text('AM4'), findsOneWidget);

      final amdCheckbox = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'AMD'),
      );
      expect(amdCheckbox.value, isTrue);

      final intelCheckbox = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'Intel'),
      );
      expect(intelCheckbox.value, isFalse);
    });

    testWidgets('powinien wyświetlić komunikat, gdy nie ma opcji filtrów', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDrawerWidget(
              filterOptions: const {},
              selectedFilters: const {},
              onToggleFilter: (key, value, isSelected) {},
              onApplyFilters: () {},
            ),
          ),
        ),
      );

      expect(find.text('Brak filtrów dla tej kategorii'), findsOneWidget);
    });

    testWidgets('powinien wywołać onToggleFilter po kliknięciu na checkbox', (WidgetTester tester) async {
      String? toggledKey;
      String? toggledValue;
      bool? toggledIsSelected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDrawerWidget(
              filterOptions: filterOptions,
              selectedFilters: selectedFilters,
              onToggleFilter: (key, value, isSelected) {
                toggledKey = key;
                toggledValue = value;
                toggledIsSelected = isSelected;
              },
              onApplyFilters: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Intel'));
      await tester.pump(); // Przebuduj widżet po interakcji

      expect(toggledKey, 'Producent');
      expect(toggledValue, 'Intel');
      expect(toggledIsSelected, true);
    });

    testWidgets('powinien wywołać onApplyFilters po kliknięciu przycisku "Zastosuj"', (WidgetTester tester) async {
      bool wasApplyPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilterDrawerWidget(
              filterOptions: filterOptions,
              selectedFilters: selectedFilters,
              onToggleFilter: (key, value, isSelected) {},
              onApplyFilters: () {
                wasApplyPressed = true;
              },
            ),
          ),
        ),
      );

      final applyButton = find.byKey(const Key('apply_filter_button'));
      expect(applyButton, findsOneWidget);
      await tester.tap(applyButton);

      expect(wasApplyPressed, isTrue);
    });
  });
}

