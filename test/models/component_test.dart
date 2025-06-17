import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/component.dart';

void main() {
  group('Component Model', () {
    final Map<String, dynamic> sampleJson = {
      'id': 'cpu-001',
      'name': 'Super CPU',
      'category': 'CPU',
      'price': '1,299.99 zł',
      'description': 'A very fast processor.',
      'images': ['url1.jpg', 'url2.jpg'],
      'specs': {'Podstawka': 'AM5', 'Rdzenie': '8'},
      'manufacturer': 'AMD',
      'compatibilityTag': 'AM5_CHIPSET',
    };

    test('fromJson tworzy poprawny obiekt z JSON', () {
      final component = Component.fromJson(sampleJson);

      expect(component.id, 'cpu-001');
      expect(component.name, 'Super CPU');
      expect(component.category, 'CPU');
      expect(component.price, 1299.99);
      expect(component.imageUrls, ['url1.jpg', 'url2.jpg']);
      expect(component.specs['Podstawka'], 'AM5');
      expect(component.manufacturer, 'AMD');
    });

    test('fromJson radzi sobie z różnymi formatami ceny', () {
      final jsonWithDotPrice = Map<String, dynamic>.from(sampleJson)..['price'] = '1299.99';
      final jsonWithNoDecimal = Map<String, dynamic>.from(sampleJson)..['price'] = '1300';

      final component1 = Component.fromJson(jsonWithDotPrice);
      final component2 = Component.fromJson(jsonWithNoDecimal);

      expect(component1.price, 1299.99);
      expect(component2.price, 1300.00);
    });

    test('toJson zwraca poprawną mapę', () {
      final component = Component.fromJson(sampleJson);

      final json = component.toJson();

      expect(json['id'], 'cpu-001');
      expect(json['name'], 'Super CPU');
      expect(json['price'], '1299.99');
    });
  });
}