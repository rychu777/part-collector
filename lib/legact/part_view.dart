import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_view.dart';
import 'constants.dart';

class PartView extends StatefulWidget {
  final String? initialCategory;

  const PartView({
    Key? key,
    this.initialCategory,
  }) : super(key: key);

  @override
  State<PartView> createState() => _PartViewState();
}

class _PartViewState extends State<PartView> {
  late Future<List<Map<String, dynamic>>> _productsFuture;
  late List<String> _categories;
  late String _selectedCategory;

  Map<String, Set<String>> _filterOptions = {};
  Map<String, Set<String>> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final snap = await FirebaseFirestore.instance
        .collection('components.json')
        .get();
    final products = snap.docs.map((d) => d.data()).toList();
    _categories = _extractCategories(products);
    _selectedCategory = (widget.initialCategory != null &&
        _categories.contains(widget.initialCategory))
        ? widget.initialCategory!
        : (_categories.isNotEmpty ? _categories.first : '');
    _initFiltersForCategory(products, _selectedCategory);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _productsFuture,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            body: Center(child: Text('Błąd: ${snap.error}')),
          );
        }
        final products = snap.data!;
        return Scaffold(
          backgroundColor: kMainBackground,
          appBar: AppBar(
            backgroundColor: kPrimaryDark,
            title: Text('Wybór podzespołu: $_selectedCategory'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ],
          ),
          drawer: _buildCategoryDrawer(products),
          endDrawer: _buildFilterDrawer(),
          body: _buildProductList(products),
        );
      },
    );
  }

  Widget _buildCategoryDrawer(List<Map<String, dynamic>> products) {
    return Drawer(
      child: Container(
        color: kPrimaryDark,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Menu', style: TextStyle(color: kWhite, fontSize: 20)),
              const Divider(color: kWhite, thickness: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    return ListTile(
                      title: Text(cat, style: const TextStyle(color: kWhite)),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedCategory = cat;
                          _initFiltersForCategory(products, cat);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDrawer() {
    return Drawer(
      width: 300,
      child: Container(
        color: kSurfaceLighter,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text('Filtry', style: TextStyle(color: kDarkGrey, fontSize: 20)),
              const Divider(color: kDarkGrey, thickness: 1),
              Expanded(child: SingleChildScrollView(child: _buildFilterOptions())),
              const Divider(color: kDarkGrey, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kRedError),
                  child: const Text('Zastosuj', style: TextStyle(color: kWhite)),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products) {
    final filtered = _filterProductsByCategoryAndParams(
      products,
      _selectedCategory,
      _selectedFilters,
    );

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          'Brak produktów spełniających kryteria',
          style: TextStyle(color: kWhite),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, i) => _buildProductCard(filtered[i]),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final images = product['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first as String : '';
    final name = product['name'] as String? ?? 'Brak nazwy';
    final price = product['price'] as String? ?? 'Brak ceny';
    final specs = product['specs'] as Map<String, dynamic>? ?? {};
    final shortSpecs = specs.entries.take(3).toList();

    return InkWell(
      child: Card(
        color: kDarkGrey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (imageUrl.isNotEmpty)
                Image.network(imageUrl, height: 150, fit: BoxFit.cover)
              else
                Container(
                  height: 150,
                  color: kSurfaceLight,
                  child: const Center(child: Text('Brak obrazka')),
                ),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Od $price', style: const TextStyle(color: kLightPurple)),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: shortSpecs.map((e) => Text('${e.key}: ${e.value}', style: const TextStyle(color: kWhite))).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kSurfaceLight),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailView(productData: product)),
                    ),
                    child: const Text('Szczegóły', style: TextStyle(color: kDarkGrey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kRedError),
                    onPressed: () => Navigator.pop(context, product),
                    child: const Text('Dodaj', style: TextStyle(color: kWhite)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    if (_filterOptions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Brak filtrów dla tej kategorii'),
      );
    }
    return Column(
      children: _filterOptions.entries.map((entry) {
        final key = entry.key;
        final vals = entry.value.toList()..sort();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wybierz $key', style: const TextStyle(color: kDarkGrey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Column(
                children: vals.map((v) {
                  final sel = _selectedFilters[key]?.contains(v) ?? false;
                  return CheckboxListTile(
                    title: Text(v),
                    value: sel,
                    activeColor: kRedError,
                    checkColor: kWhite,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedFilters[key]!.add(v);
                        } else {
                          _selectedFilters[key]!.remove(v);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(color: kDarkGrey, thickness: 1),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _extractCategories(List<Map<String, dynamic>> products) {
    final set = <String>{};
    for (var p in products) {
      set.add(p['category'] as String? ?? 'Inne');
    }
    return set.toList()..sort();
  }

  void _initFiltersForCategory(List<Map<String, dynamic>> products, String category) {
    _filterOptions.clear();
    _selectedFilters.clear();
    final filtered = products.where((p) => (p['category'] as String? ?? '') == category);
    for (var p in filtered) {
      final specs = p['specs'] as Map<String, dynamic>? ?? {};
      specs.forEach((k, v) {
        _filterOptions.putIfAbsent(k, () => <String>{});
        _filterOptions[k]!.add(v.toString());
      });
    }
    for (var k in _filterOptions.keys) {
      _selectedFilters[k] = <String>{};
    }
  }

  List<Map<String, dynamic>> _filterProductsByCategoryAndParams(
      List<Map<String, dynamic>> products,
      String category,
      Map<String, Set<String>> selectedFilters,
      ) {
    final byCat = products.where((p) => (p['category'] as String? ?? '') == category);
    final anyFilter = selectedFilters.values.any((s) => s.isNotEmpty);
    if (!anyFilter) return byCat.toList();
    return byCat.where((p) {
      final specs = p['specs'] as Map<String, dynamic>? ?? {};
      for (var key in selectedFilters.keys) {
        final sel = selectedFilters[key]!;
        if (sel.isNotEmpty && !sel.contains(specs[key]?.toString() ?? '')) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}