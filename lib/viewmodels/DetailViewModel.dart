import 'package:flutter/foundation.dart';
import 'package:first_app/models/DetailedProduct.dart';

class DetailViewModel extends ChangeNotifier {
final DetailedProduct product;
int currentImageIndex = 0;

DetailViewModel(this.product);

void setImageIndex(int index) {
  currentImageIndex = index;
  notifyListeners();
}

}