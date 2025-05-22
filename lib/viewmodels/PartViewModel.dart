import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/ProductCatalogViewModel.dart';
import 'package:first_app/models/DetailedProduct.dart';

class PartViewModel extends ChangeNotifier {
  final ProductCatalogViewModel _catalog;
  final String? initialCategory;

  List<DetailedProduct> _products = [];
  String _selectedCategory = '';
  Map<String, Set<String>> _filterOptions = {};
  Map<String, Set<String>> _selectedFilters = {};

  List<DetailedProduct> get products => _products;
  List<String> get categories => _catalog.categories;
  String get selectedCategory => _selectedCategory;
  Map<String, Set<String>> get filterOptions => _filterOptions;
  Map<String, Set<String>> get selectedFilters => _selectedFilters;

  bool get isLoading => _catalog.isLoading;
  String? get error => _catalog.error;

  PartViewModel(this._catalog, {this.initialCategory}) {
    if (_catalog.isLoaded) {
      _init();
    } else {
      _catalog.addListener(_catalogListener);
    }
  }

  void _catalogListener() {
    if (_catalog.isLoaded) {
      _catalog.removeListener(_catalogListener);
      _init();
    }
  }

  void _init() {
    if (initialCategory != null && categories.contains(initialCategory!.toUpperCase())) {
      _selectedCategory = initialCategory!.toUpperCase();
    } else if (categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }
    _initFiltersForCategory(_selectedCategory);
    _applyFilters();
    notifyListeners();
  }

  void selectCategory(String category) {
    final normalized = category.toUpperCase();
    if (_selectedCategory == normalized) return;

    _selectedCategory = normalized;
    _initFiltersForCategory(_selectedCategory);
    _applyFilters();
    notifyListeners();
  }

  void _initFiltersForCategory(String category) {
    _filterOptions.clear();
    _selectedFilters.clear();

    final productsInCat = _catalog.products
        .where((p) => p.category.toUpperCase() == category)
        .toList();

    for (var product in productsInCat) {
      product.specs.forEach((key, value) {
        _filterOptions.putIfAbsent(key, () => <String>{}).add(value.toString());
      });
    }

    for (var key in _filterOptions.keys) {
      _selectedFilters[key] = <String>{};
    }
  }

  void toggleFilter(String filterKey, String filterValue, bool isSelected) {
    if (!_selectedFilters.containsKey(filterKey)) return;

    if (isSelected) {
      _selectedFilters[filterKey]!.add(filterValue);
    } else {
      _selectedFilters[filterKey]!.remove(filterValue);
    }
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    final cat = _selectedCategory.toUpperCase();
    var filtered = _catalog.products.where((p) => p.category.toUpperCase() == cat).toList();

    final anyActive = _selectedFilters.values.any((set) => set.isNotEmpty);
    if (!anyActive) {
      _products = filtered;
      return;
    }

    _products = filtered.where((p) {
      for (var entry in _selectedFilters.entries) {
        final key = entry.key;
        final selectedVals = entry.value;
        if (selectedVals.isNotEmpty) {
          final val = p.specs[key]?.toString();
          if (val == null || !selectedVals.contains(val)) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }
}
