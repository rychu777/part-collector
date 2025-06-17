import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/models/component.dart';

void main() {
  group('BuildFile Model', () {
    final sampleJson = {
      'name': 'My Dream PC',
      'components': [
        {
          'id': 'cpu-001', 'name': 'Super CPU', 'category': 'CPU', 'price': '1299.99',
          'description': '', 'images': [], 'specs': {}, 'manufacturer': '', 'compatibilityTag': ''
        },
        {
          'id': 'gpu-001', 'name': 'Super GPU', 'category': 'GPU', 'price': '3499.00',
          'description': '', 'images': [], 'specs': {}, 'manufacturer': '', 'compatibilityTag': ''
        }
      ]
    };

    test('fromJsonMap powinien poprawnie stworzyć obiekt z listy komponentów', () {
      final buildFile = BuildFile.fromJsonMap(sampleJson);

      expect(buildFile.name, 'My Dream PC');
      expect(buildFile.components, isA<List<Component>>());
      expect(buildFile.components.length, 2);
      expect(buildFile.components[0].name, 'Super CPU');
      expect(buildFile.components[1].id, 'gpu-001');
    });

    test('toJsonMap powinien poprawnie zserializować obiekt do mapy', () {
      final buildFile = BuildFile(
          name: 'My Dream PC',
          components: [
            Component(id: 'c1', name: 'CPU 1', category: 'CPU', price: 100, description: '', imageUrls: [], specs: {}, manufacturer: '', compatibilityTag: ''),
            Component(id: 'g1', name: 'GPU 1', category: 'GPU', price: 200, description: '', imageUrls: [], specs: {}, manufacturer: '', compatibilityTag: ''),
          ]
      );

      final json = buildFile.toJsonMap();

      expect(json['name'], 'My Dream PC');
      final componentsList = json['components'] as List<dynamic>;
      expect(componentsList.length, 2);
      expect(componentsList[0]['id'], 'c1');
      expect(componentsList[1]['name'], 'GPU 1');
    });
  });
}