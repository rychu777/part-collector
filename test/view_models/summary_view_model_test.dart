import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/viewmodels/SummaryViewModel.dart';

Component _createMockComponent({double price = 100}) {
  return Component(
      id: '', name: '', category: '', price: price, description: '',
      imageUrls: [], specs: {}, manufacturer: '', compatibilityTag: ''
  );
}

void main() {
  group('SummaryViewModel', () {
    test('totalPrice powinien poprawnie sumować ceny komponentów', () {
      final components = [
        _createMockComponent(price: 150.50),
        _createMockComponent(price: 300.00),
        _createMockComponent(price: 49.50),
      ];
      final viewModel = SummaryViewModel(buildName: 'Test', components: components);

      expect(viewModel.totalPrice, 500.00);
    });

    test('hasIncompatibleParts powinien zwrócić true, gdy jest chociaż jedna niezgodność', () {
      final incompatibilities = {'CPU': true, 'RAM': false};
      final viewModel = SummaryViewModel(
        buildName: 'Test',
        components: [],
        incompatibilities: incompatibilities,
      );

      expect(viewModel.hasIncompatibleParts, isTrue);
    });

    test('hasIncompatibleParts powinien zwrócić false, gdy wszystkie części są zgodne', () {
      final incompatibilities = {'CPU': false, 'RAM': false};
      final viewModel = SummaryViewModel(
        buildName: 'Test',
        components: [],
        incompatibilities: incompatibilities,
      );

      expect(viewModel.hasIncompatibleParts, isFalse);
    });

    test('metryka Kompatybilność powinna mieć 100%, gdy nie ma niezgodności', () {
      final components = [_createMockComponent(), _createMockComponent()];
      final viewModel = SummaryViewModel(
        buildName: 'Test',
        components: components,
        incompatibilities: {'CPU': false},
      );

      final compatibilityMetric = viewModel.metrics.firstWhere((m) => m.label == 'Kompatybilność');

      expect(compatibilityMetric.percentage, 100);
      expect(compatibilityMetric.statusText, 'PEŁNY/A');
    });

    test('metryka Kompatybilność powinna mieć 50%, gdy połowa części jest niezgodna', () {
      final components = [_createMockComponent(), _createMockComponent()];
      final viewModel = SummaryViewModel(
        buildName: 'Test',
        components: components,
        incompatibilities: {'CPU': true, 'RAM': false},
      );

      final compatibilityMetric = viewModel.metrics.firstWhere((m) => m.label == 'Kompatybilność');

      expect(compatibilityMetric.percentage, 50);
      expect(compatibilityMetric.statusText, 'NIEPEŁNY/A');
    });

    test('metryka Kompletność powinna mieć 25%, gdy wybrano 2 z 8 części', () {
      final components = [_createMockComponent(), _createMockComponent()];
      final viewModel = SummaryViewModel(buildName: 'Test', components: components);

      final completenessMetric = viewModel.metrics.firstWhere((m) => m.label == 'Kompletność');

      expect(completenessMetric.percentage, 25);
    });
  });
}
