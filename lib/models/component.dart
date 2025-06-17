import 'package:flutter/material.dart';

class Component {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final List<String> imageUrls;
  final Map<String, String> specs;
  final String manufacturer;
  final String compatibilityTag;

  Component({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.specs,
    required this.manufacturer,
    required this.compatibilityTag,
  });

  Component copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? description,
    List<String>? imageUrls,
    Map<String, String>? specs,
    String? manufacturer,
    String? compatibilityTag,
  }) {
    return Component(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      specs: specs ?? this.specs,
      manufacturer: manufacturer ?? this.manufacturer,
      compatibilityTag: compatibilityTag ?? this.compatibilityTag,
    );
  }

  factory Component.fromJson(Map<String, dynamic> json) {
    String getString(String key) => json[key]?.toString() ?? '';

    List<String> getListOfStrings(String key) {
      final List<dynamic>? dynamicList = json[key];
      return dynamicList?.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList() ?? [];
    }

    Map<String, String> getMapOfStrings(String key) {
      if (json[key] is Map) {
        final Map<String, dynamic> dynamicMap = Map<String, dynamic>.from(json[key]);
        return dynamicMap.map((key, value) => MapEntry(key, value?.toString() ?? ''));
      }
      return {};
    }

    double parsedPrice;
    try {
      String priceString = json['price']?.toString() ?? '';

      priceString = priceString.replaceAll(RegExp(r'[^\d,.]'), '');

      final lastComma = priceString.lastIndexOf(',');
      final lastDot = priceString.lastIndexOf('.');

      if (lastComma > lastDot) {
        priceString = priceString.replaceAll('.', '').replaceAll(',', '.');
      }
      else {
        priceString = priceString.replaceAll(',', '');
      }

      parsedPrice = double.tryParse(priceString) ?? 0.0;
    } catch (e) {
      parsedPrice = 0.0;
    }

    return Component(
      id: getString('id'),
      name: getString('name'),
      category: getString('category'),
      price: parsedPrice,
      description: getString('description'),
      imageUrls: getListOfStrings('images'),
      specs: getMapOfStrings('specs'),
      manufacturer: getString('manufacturer'),
      compatibilityTag: getString('compatibilityTag'),
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
  };
}
