import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/widgets/StyledSpecsList.dart';

const Color kWhite = Colors.white;

const Color kLightPurple = Color(0xFFE0D7F5);

void main() {
  group('StyledSpecsList', () {
    testWidgets('powinien wyświetlić listę specyfikacji, gdy dane są dostępne', (WidgetTester tester) async {
      final Map<String, dynamic> specs = {
        'Procesor': 'AMD Ryzen 7',
        'Pamięć RAM': '16 GB',
        'Taktowanie': 3600,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledSpecsList(specs: specs),
          ),
        ),
      );

      expect(find.text('Procesor'), findsOneWidget);
      expect(find.text('AMD Ryzen 7'), findsOneWidget);

      expect(find.text('Pamięć RAM'), findsOneWidget);
      expect(find.text('16 GB'), findsOneWidget);

      expect(find.text('Taktowanie'), findsOneWidget);
      expect(find.text('3600'), findsOneWidget); // Sprawdza, czy .toString() zadziałało
    });

    testWidgets('powinien wyświetlić "Brak specyfikacji", gdy mapa jest pusta', (WidgetTester tester) async {
      final Map<String, dynamic> emptySpecs = {};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledSpecsList(specs: emptySpecs),
          ),
        ),
      );


      expect(find.text('Brak specyfikacji'), findsOneWidget);
    });

    testWidgets('powinien zastosować odpowiednie style do tekstu', (WidgetTester tester) async {
      final Map<String, dynamic> specs = {'Klucz': 'Wartość'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledSpecsList(specs: specs),
          ),
        ),
      );

      final keyText = tester.widget<Text>(find.text('Klucz'));
      expect(keyText.style?.fontWeight, FontWeight.bold);
      expect(keyText.style?.color, kWhite);

      final valueText = tester.widget<Text>(find.text('Wartość'));
      expect(valueText.style?.color, kLightPurple);
      expect(valueText.style?.fontWeight, isNot(FontWeight.bold));
    });
  });
}
