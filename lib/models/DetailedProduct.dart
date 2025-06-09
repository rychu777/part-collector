import 'package:first_app/models/Product.dart';
import 'package:first_app/models/Offer.dart';

class DetailedProduct extends Product {
  DetailedProduct({
    required String id,
    required String name,
    required String category,
    required double price,
    required List<String> imageUrls,
    required Map<String, String> specs,
    required String description,
    required String manufacturer,
    required String compatibilityTag,
    required List<Offer> offers,
  }) : super(
    id: id,
    name: name,
    category: category,
    price: price,
    description: description,
    imageUrls: imageUrls,
    specs: specs,
    manufacturer: manufacturer,
    compatibilityTag: compatibilityTag,
    offers: offers,
  );

  factory DetailedProduct.fromJson(Map<String, dynamic> json) {
    final p = Product.fromJson(json);
    return DetailedProduct(
      id: p.id,
      name: p.name,
      category: p.category,
      price: p.price,
      description: p.description,
      imageUrls: p.imageUrls,
      specs: p.specs,
      manufacturer: p.manufacturer,
      compatibilityTag: p.compatibilityTag,
      offers: p.offers,
    );
  }
}
