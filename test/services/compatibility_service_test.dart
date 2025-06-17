import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/services/CompatibilityService.dart';

Component _createComponent(String category, Map<String, String> specs) {
  return Component(
      id: '', name: '', category: category, price: 0,
      description: '', imageUrls: [], specs: specs,
      manufacturer: '', compatibilityTag: ''
  );
}

void main() {
  group('CompatibilityService', () {
    late CompatibilityService compatibilityService;

    setUp(() {
      compatibilityService = CompatibilityService();
    });

    test('powinien zwrócić brak niekompatybilności dla zgodnych CPU i płyty głównej', () {
      final cpu = _createComponent('CPU', {'Podstawka': 'AM5'});
      final motherboard = _createComponent('MOTHERBOARD', {'Socket': 'AM5'});
      final selected = {'CPU': cpu, 'MOTHERBOARD': motherboard};

      final result = compatibilityService.checkAllCompatibility(selected);

      expect(result['CPU'], isFalse);
      expect(result['MOTHERBOARD'], isFalse);
    });

    test('powinien oznaczyć CPU i płytę główną jako niekompatybilne przy różnych socketach', () {
      final cpu = _createComponent('CPU', {'Podstawka': 'AM5'});
      final motherboard = _createComponent('MOTHERBOARD', {'Socket': 'LGA1700'});
      final selected = {'CPU': cpu, 'MOTHERBOARD': motherboard};

      final result = compatibilityService.checkAllCompatibility(selected);

      expect(result['CPU'], isTrue);
      expect(result['MOTHERBOARD'], isTrue);
    });

    test('powinien oznaczyć RAM i płytę główną jako niekompatybilne przy różnym standardzie', () {
      final ram = _createComponent('RAM', {'Standard': 'DDR5'});
      final motherboard = _createComponent('MOTHERBOARD', {'Obsługa RAM': 'DDR4'});
      final selected = {'CPU': null, 'MOTHERBOARD': motherboard, 'RAM': ram};

      final result = compatibilityService.checkAllCompatibility(selected);

      expect(result['RAM'], isTrue);
      expect(result['MOTHERBOARD'], isTrue);
    });

    test('powinien oznaczyć zasilacz (PSU) i GPU jako niekompatybilne, gdy moc jest za niska', () {
      final psu = _createComponent('PSU', {'Moc': '600 W'});
      final gpu = _createComponent('GPU', {});
      final gpuRequiring750W = gpu.copyWith(name: 'Super Karta 3080');
      final selected = {'PSU': psu, 'GPU': gpuRequiring750W};

      final result = compatibilityService.checkAllCompatibility(selected);

      expect(result['PSU'], isTrue);
      expect(result['GPU'], isTrue);
    });
  });
}