import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/services/CompatibilityService.dart';
import 'package:first_app/viewmodels/ConfigurationViewModel.dart';

import 'configuration_view_model_test.mocks.dart';

@GenerateMocks([CompatibilityService])
void main() {
  late ConfigurationViewModel viewModel;
  late MockCompatibilityService mockCompatibilityService;

  final testComponent = Component(id: 'c1', name: 'Test CPU', category: 'CPU', price: 100, description: '', imageUrls: [], specs: {}, manufacturer: '', compatibilityTag: '');

  setUp(() {
    mockCompatibilityService = MockCompatibilityService();


    when(mockCompatibilityService.checkAllCompatibility(any))
        .thenReturn({});

    viewModel = ConfigurationViewModel(
      buildName: 'Test Build',
      compatibilityService: mockCompatibilityService,
    );
  });

  group('ConfigurationViewModel', () {
    test('powinien mieć poprawny stan początkowy', () {
      expect(viewModel.buildName, 'Test Build');
      expect(viewModel.selected.values.every((v) => v == null), isTrue, reason: 'Wszystkie sloty na komponenty powinny być początkowo puste.');
      expect(viewModel.isSlotIncompatible.values.every((v) => v == false), isTrue, reason: 'Żaden slot nie powinien być oznaczony jako niekompatybilny na starcie.');
    });

    test('powinien poprawnie zainicjalizować stan z początkowej listy komponentów', () {
      final initialComponents = [
        testComponent.copyWith(category: 'CPU', name: 'Initial CPU'),
        testComponent.copyWith(category: 'GPU', name: 'Initial GPU'),
      ];

      clearInteractions(mockCompatibilityService);

      final vmWithInitialData = ConfigurationViewModel(
        buildName: "Initial Build",
        initialComponents: initialComponents,
        compatibilityService: mockCompatibilityService,
      );

      expect(vmWithInitialData.selected['CPU']?.name, 'Initial CPU');
      expect(vmWithInitialData.selected['GPU']?.name, 'Initial GPU');
      expect(vmWithInitialData.selected['RAM'], isNull);

      verify(mockCompatibilityService.checkAllCompatibility(any)).called(1);
    });

    test('selectSlot powinien dodać komponent i zaktualizować stan kompatybilności', () {
      when(mockCompatibilityService.checkAllCompatibility(any))
          .thenReturn({'CPU': true, 'MOTHERBOARD': true});

      int listenerCallCount = 0;
      viewModel.addListener(() => listenerCallCount++);

      clearInteractions(mockCompatibilityService);

      viewModel.selectSlot('CPU', testComponent);


      expect(viewModel.selected['CPU'], isA<Component>());
      expect(viewModel.selected['CPU']?.id, testComponent.id);

      verify(mockCompatibilityService.checkAllCompatibility(any)).called(1);

      expect(viewModel.isSlotIncompatible['CPU'], isTrue);
      expect(viewModel.isSlotIncompatible['MOTHERBOARD'], isTrue);

      expect(listenerCallCount, 1);
    });
  });
}
