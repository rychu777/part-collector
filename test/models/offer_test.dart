import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/Offer.dart';

void main() {
  group('Offer Model', () {
    final Map<String, dynamic> sampleJson = {
      'store': 'x-kom',
      'price': '199.99 zł',
      'url': 'https://www.x-kom.pl/p/12345',
    };

    test('fromJson powinien poprawnie stworzyć obiekt z pełnych danych JSON', () {
      final offer = Offer.fromJson(sampleJson);

      expect(offer.store, 'x-kom');
      expect(offer.price, '199.99 zł');
      expect(offer.url, 'https://www.x-kom.pl/p/12345');
    });

    test('fromJson powinien użyć wartości domyślnych, gdy dane w JSON są puste (null)', () {
      final incompleteJson = {'store': null, 'price': null, 'url': null};

      final offer = Offer.fromJson(incompleteJson);

      expect(offer.store, 'Sklep');
      expect(offer.price, '0.00 zł');
      expect(offer.url, '#');
    });

    test('toJson powinien zwrócić poprawną mapę', () {
      final offer = Offer(
        store: 'Morele.net',
        price: '250.00 zł',
        url: 'https://morele.net',
      );

      final json = offer.toJson();

      expect(json['store'], 'Morele.net');
      expect(json['price'], '250.00 zł');
      expect(json['url'], 'https://morele.net');
    });
  });
}