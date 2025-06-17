import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/Product.dart';
import 'package:first_app/models/Offer.dart';

void main() {
  group('Product Model', () {
    final Map<String, dynamic> sampleJson = {
      'id': 'gpu-001',
      'name': 'Super GPU',
      'category': 'GPU',
      'price': '3,499.00 zł',
      'description': 'A very fast graphics card.',
      'images': ['gpu1.jpg', 'gpu2.jpg'],
      'specs': {'Pamięć': '12 GB', 'Typ pamięci': 'GDDR6X'},
      'manufacturer': 'NVIDIA',
      'compatibilityTag': 'PCIE_X16',
      'offers': [
        {'store': 'x-kom', 'price': '3499.00 zł', 'url': 'https://x-kom.pl/gpu'},
        {'store': 'Morele', 'price': '3510.00 zł', 'url': 'https://morele.net/gpu'}
      ]
    };

    test('fromJson powinien poprawnie stworzyć obiekt z zagnieżdżoną listą ofert', () {
      final product = Product.fromJson(sampleJson);

      expect(product.id, 'gpu-001');
      expect(product.name, 'Super GPU');
      expect(product.price, 3499.00);
      expect(product.offers, isA<List<Offer>>());
      expect(product.offers.length, 2);
      expect(product.offers[0].store, 'x-kom');
      expect(product.offers[1].price, '3510.00 zł');
    });

    test('fromJson powinien obsłużyć brak listy ofert', () {
      final jsonWithoutOffers = Map<String, dynamic>.from(sampleJson);
      jsonWithoutOffers.remove('offers');

      final product = Product.fromJson(jsonWithoutOffers);

      expect(product.offers, isA<List<Offer>>());
      expect(product.offers.isEmpty, isTrue);
    });

    test('toJson powinien poprawnie zserializować obiekt z zagnieżdżoną listą ofert', () {
      final product = Product.fromJson(sampleJson);

      final json = product.toJson();

      expect(json['id'], 'gpu-001');
      final offersList = json['offers'] as List<dynamic>;
      expect(offersList.length, 2);
      expect(offersList[0]['store'], 'x-kom');
    });
  });
}