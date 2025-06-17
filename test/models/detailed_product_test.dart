import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/DetailedProduct.dart';

void main() {
  group('DetailedProduct Model', () {
    final Map<String, dynamic> sampleJson = {
      'id': 'dp-001',
      'name': 'Detailed GPU',
      'category': 'GPU',
      'price': '3,499.00 zł',
      'description': 'A very fast graphics card.',
      'images': [],
      'specs': {},
      'manufacturer': 'NVIDIA',
      'compatibilityTag': '',
      'offers': []
    };

    test('fromJson powinien stworzyć obiekt typu DetailedProduct używając logiki Product.fromJson', () {
      final detailedProduct = DetailedProduct.fromJson(sampleJson);

      expect(detailedProduct, isA<DetailedProduct>());
      expect(detailedProduct.id, 'dp-001');
      expect(detailedProduct.name, 'Detailed GPU');
      expect(detailedProduct.price, 3499.00);
    });
  });
}