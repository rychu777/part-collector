import 'package:first_app/models/Offer.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final List<String> imageUrls;
  final Map<String, String> specs;
  final String manufacturer;
  final String compatibilityTag;
  final List<Offer> offers;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.specs,
    required this.manufacturer,
    required this.compatibilityTag,
    required this.offers,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String getString(String key) => json[key]?.toString() ?? '';

    List<String> getListOfStrings(String key) {
      final List<dynamic>? dynamicList = json[key];
      return dynamicList?.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList() ?? [];
    }

    Map<String, String> getMapOfStrings(String key) {
      final Map<String, dynamic>? dynamicMap = json[key];
      return dynamicMap?.map((k, v) => MapEntry(k, v?.toString() ?? '')) ?? {};
    }

    double parsedPrice;
    try {
      String priceString = json['price']?.toString() ?? '';
      priceString = priceString.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.');
      parsedPrice = double.tryParse(priceString) ?? 0.0;
    } catch (e) {
      print('Error parsing price for product ${json['id']}: $e. Original price string: ${json['price']}');
      parsedPrice = 0.0;
    }

    List<Offer> parsedOffers = [];
    final List<dynamic>? offersList = json['offers'];
    if (offersList != null) {
      parsedOffers = offersList
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Product(
      id: getString('id'),
      name: getString('name'),
      category: getString('category'),
      price: parsedPrice,
      description: getString('description'),
      imageUrls: getListOfStrings('images'),
      specs: getMapOfStrings('specs'),
      manufacturer: getString('manufacturer'),
      compatibilityTag: getString('compatibilityTag'),
      offers: parsedOffers,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price.toStringAsFixed(2),
    'description': description,
    'images': imageUrls,
    'specs': specs,
    'manufacturer': manufacturer,
    'compatibilityTag': compatibilityTag,
    'offers': offers.map((o) => o.toJson()).toList(),
  };
}