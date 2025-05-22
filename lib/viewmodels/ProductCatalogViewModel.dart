import 'package:flutter/material.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/repositories/ProductRepository.dart';


class ProductCatalogViewModel extends ChangeNotifier {
  final ProductRepository _repo;
  List<DetailedProduct> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductCatalogViewModel(this._repo) {
    load();
  }

  bool get isLoading => _isLoading;
  bool get isLoaded => !_isLoading && _products.isNotEmpty;
  String? get error => _error;
  List<DetailedProduct> get products => _products;

  List<String> get categories =>
      _products.map((p) => p.category.toUpperCase()).toSet().toList()..sort();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repo.getProducts();
    } catch (e) {
      _error = 'Błąd ładowania: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
