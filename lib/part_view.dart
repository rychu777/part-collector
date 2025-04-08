import 'package:flutter/material.dart';
import 'detail_view.dart';

const Color kPrimaryDark = Color(0xFF1D1B20);
const Color kSurfaceLight = Color(0xFFE8DEF8);
const Color kSurfaceLighter = Color(0xFFFEF7FF);
const Color kWhite = Color(0xFFFFFFFF);
const Color kDarkGrey = Color(0xFF1D1B20);
const Color kPurple = Color(0xFF4F378A);
const Color kPurple2 = Color(0xFF65558F);
const Color kRedError = Color(0xFF9C3732);
const Color kLightPurple = Color(0xFFD1C4E9);
const Color kMainBackground = Color(0xFF333333);

class PartView extends StatefulWidget {
  final List<Map<String, dynamic>> allProducts;

  const PartView({Key? key, required this.allProducts}) : super(key: key);

  @override
  State<PartView> createState() => _PartViewState();
}

class _PartViewState extends State<PartView> {
  late List<String> _categories;

  String _selectedCategory = '';

  Map<String, Set<String>> _filterOptions = {};

  Map<String, Set<String>> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _categories = _extractCategories(widget.allProducts);
    if (_categories.isNotEmpty) {
      _selectedCategory = _categories.first;
    }
    _initFiltersForCategory(_selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        title: Text('Wybór podzespołu: $_selectedCategory'),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      // Drawer (menu boczne) – wybór kategorii
      drawer: Drawer(
        child: Container(
          color: kPrimaryDark,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Menu',
                  style: TextStyle(color: kWhite, fontSize: 20),
                ),
                const Divider(color: kWhite, thickness: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return ListTile(
                        title: Text(
                          category,
                          style: const TextStyle(color: kWhite),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Zamykamy Drawer
                          setState(() {
                            _selectedCategory = category;
                            _initFiltersForCategory(category);
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
      ),
      // endDrawer – panel filtrów
      endDrawer: Drawer(
        width: 300,
        child: Container(
          color: kSurfaceLighter,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Filtry',
                  style: TextStyle(color: kDarkGrey, fontSize: 20),
                ),
                const Divider(color: kDarkGrey, thickness: 1),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildFilterOptions(),
                  ),
                ),
                const Divider(color: kDarkGrey, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: kRedError),
                    onPressed: () {
                      // Zatwierdzamy filtry i zamykamy
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text(
                      'Zastosuj',
                      style: TextStyle(color: kWhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildProductList(),
    );
  }

  // Buduje listę kart z produktami (po filtrach)
  Widget _buildProductList() {
    // Filtrowanie listy
    final filtered = _filterProductsByCategoryAndParams(
      widget.allProducts,
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
      itemBuilder: (context, index) {
        final product = filtered[index];
        return _buildProductCard(product);
      },
    );
  }

  // Karta produktu
  Widget _buildProductCard(Map<String, dynamic> product) {
    final images = product['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images.first as String : '';
    final name = product['name'] as String? ?? 'Brak nazwy';
    final price = product['price'] as String? ?? 'Brak ceny';
    final specs = product['specs'] as Map<String, dynamic>? ?? {};

    // Wyciągamy kilka parametrów, żeby pokazać je na karcie
    final shortSpecs = specs.entries.take(3).toList();

    return Card(
      color: kDarkGrey,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 150,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 150,
                color: kSurfaceLight,
                child: const Center(
                  child: Text('Brak obrazka'),
                ),
              ),
            const SizedBox(height: 8),
            // Nazwa
            Text(
              name,
              style: const TextStyle(
                color: kWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Cena
            Text(
              'Od $price',
              style: const TextStyle(color: kLightPurple),
            ),
            const SizedBox(height: 8),
            // Krótka lista parametrów
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: shortSpecs.map((entry) {
                final key = entry.key;
                final value = entry.value.toString();
                return Text(
                  '$key: $value',
                  style: const TextStyle(color: kWhite),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Przyciski "Szczegóły" i "Dodaj"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSurfaceLight,
                  ),
                  onPressed: () {
                    // Przejście do DetailView
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailView(productData: product),
                      ),
                    );
                  },
                  child: const Text(
                    'Szczegóły',
                    style: TextStyle(color: kDarkGrey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRedError,
                  ),
                  onPressed: () {
                    debugPrint('Dodano do koszyka');
                  },
                  child: const Text(
                    'Dodaj',
                    style: TextStyle(color: kWhite),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    if (_filterOptions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Brak filtrów dla tej kategorii'),
      );
    }

    return Column(
      children: _filterOptions.entries.map((entry) {
        final paramName = entry.key;
        final possibleValues = entry.value.toList()..sort();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wybierz $paramName',
                style: const TextStyle(
                  color: kDarkGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: possibleValues.map((val) {
                  final isSelected = _selectedFilters[paramName]?.contains(val) ?? false;
                  return CheckboxListTile(
                    title: Text(val),
                    activeColor: kRedError,
                    checkColor: kWhite,
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedFilters[paramName]?.add(val);
                        } else {
                          _selectedFilters[paramName]?.remove(val);
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
    final setOfCategories = <String>{};
    for (var product in products) {
      final cat = product['category'] as String? ?? 'Inne';
      setOfCategories.add(cat);
    }
    return setOfCategories.toList()..sort();
  }

  void _initFiltersForCategory(String category) {
    _filterOptions.clear();
    _selectedFilters.clear();

    final filtered = widget.allProducts
        .where((p) => (p['category'] as String? ?? '') == category)
        .toList();

    for (var product in filtered) {
      final specs = product['specs'] as Map<String, dynamic>? ?? {};
      specs.forEach((key, value) {
        final valStr = value.toString();
        _filterOptions.putIfAbsent(key, () => <String>{});
        _filterOptions[key]!.add(valStr);
      });
    }

    for (var key in _filterOptions.keys) {
      _selectedFilters[key] = <String>{};
    }
  }

  List<Map<String, dynamic>> _filterProductsByCategoryAndParams(
      List<Map<String, dynamic>> products,
      String category,
      Map<String, Set<String>> selectedFilters) {
    final filteredByCategory = products
        .where((p) => (p['category'] as String? ?? '') == category)
        .toList();

    final hasAnyFilterSelected =
    selectedFilters.values.any((set) => set.isNotEmpty);
    if (!hasAnyFilterSelected) {
      return filteredByCategory;
    }

    return filteredByCategory.where((product) {
      final specs = product['specs'] as Map<String, dynamic>? ?? {};
      for (var paramKey in selectedFilters.keys) {
        final selectedValues = selectedFilters[paramKey]!;
        if (selectedValues.isEmpty) continue;
        final productValue = specs[paramKey]?.toString() ?? '';
        if (!selectedValues.contains(productValue)) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}
