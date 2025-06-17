import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/viewmodels/DetailViewModel.dart';

DetailedProduct _createMockProduct() {
  return DetailedProduct(
      id: 'p1', name: 'Test Product', category: '', price: 0,
      description: '', imageUrls: ['img1.jpg', 'img2.jpg', 'img3.jpg'],
      specs: {}, manufacturer: '', compatibilityTag: '', offers: []
  );
}

void main() {
  group('DetailViewModel', () {
    late DetailViewModel viewModel;
    final mockProduct = _createMockProduct();

    setUp(() {
      viewModel = DetailViewModel(mockProduct);
    });

    test('powinien mieć poprawny stan początkowy', () {
      expect(viewModel.product, mockProduct);
      expect(viewModel.currentImageIndex, 0);
    });

    test('setImageIndex powinien poprawnie zaktualizować indeks obrazu', () {
      int listenerCallCount = 0;
      viewModel.addListener(() {
        listenerCallCount++;
      });

      viewModel.setImageIndex(2);

      expect(viewModel.currentImageIndex, 2);
      expect(listenerCallCount, 1, reason: 'notifyListeners() powinien zostać wywołany raz.');
    });

    test('setImageIndex nie powinien powiadamiać, jeśli indeks się nie zmienia', () {
      viewModel.setImageIndex(1);

      int listenerCallCount = 0;
      viewModel.addListener(() {
        listenerCallCount++;
      });

      viewModel.setImageIndex(1);


      expect(listenerCallCount, 1);
    });
  });
}
