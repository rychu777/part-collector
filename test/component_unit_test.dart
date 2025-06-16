import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/component.dart';

// flutter test test/component_unit_test.dart
void main() {
  group('Component model', () {
    final component = Component(
      id: '123',
      name: 'Test Component',
      category: 'CPU',
      price: 999.99,
      description: 'High performance CPU',
      imageUrls: ['url1', 'url2'],
      specs: {'cores': '8', 'threads': '16'},
      manufacturer: 'AMD',
      compatibilityTag: 'AM4',
    );

    test('should create a valid instance', () {
      expect(component.id, '123');
      expect(component.name, 'Test Component');
      expect(component.category, 'CPU');
      expect(component.price, 999.99);
      expect(component.specs['cores'], '8');
    });

    test('should create a modified copy with copyWith()', () {
      final modified = component.copyWith(price: 799.99, name: 'Updated');

      expect(modified.price, 799.99);
      expect(modified.name, 'Updated');
      expect(modified.id, component.id); // unchanged
    });

    test('should convert to JSON and back correctly', () {
      final json = component.toJson();
      final fromJson = Component.fromJson(json);

      expect(fromJson.id, component.id);
      expect(fromJson.name, component.name);
      expect(fromJson.price, component.price);
      expect(fromJson.imageUrls, component.imageUrls);
    });

    test('should parse from valid JSON with strings', () {
      final rawJson = {
        'id': 789,
        'name': 'Another Component',
        'category': 'GPU',
        'price': '1349,50 zł',
        'description': 'Powerful GPU',
        'images': ['img1', 'img2'],
        'specs': {'memory': '8GB'},
        'manufacturer': 'NVIDIA',
        'compatibilityTag': 'PCIe 4.0'
      };

      final parsed = Component.fromJson(rawJson);
      expect(parsed.price, 1349.50);
      expect(parsed.name, 'Another Component');
      expect(parsed.manufacturer, 'NVIDIA');
    });

    test('should handle invalid price gracefully', () {
      final rawJson = <String, dynamic> {
        'id': 'x',
        'name': 'Broken',
        'category': 'RAM',
        'price': '??',
        'description': '',
        'images': [],
        'specs': <String, dynamic>{},
        'manufacturer': '',
        'compatibilityTag': ''
      };
      final parsed = Component.fromJson(rawJson);
      expect(parsed.price, 0.0);
    });
  });
}
