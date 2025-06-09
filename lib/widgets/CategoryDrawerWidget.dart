import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';

class CategoryDrawerWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  static const Map<String, String> customCategoryTranslations = {
    'CPU': 'Procesor',
    'GPU': 'Karta graficzna',
    'RAM': 'Pamięć RAM',
    'COOLING': 'Chłodzenie',
    'PSU': 'Zasilacz',
    'CASE': 'Obudowa',
    'DISKS': 'Dysk',
    'MOTHERBOARD': 'Płyta główna',
  };

  const CategoryDrawerWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kPrimaryDark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Text(
                  'Kategorie',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: kLightPurple,
                  ),
                ),
              ),
              Divider(color: kLightPurple.withOpacity(0.2), thickness: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final displayName = customCategoryTranslations[cat.toUpperCase()] ?? _capitalize(cat);
                    final isSelected = selectedCategory == cat;

                    return InkWell(
                      onTap: () => onCategorySelected(cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? kLightPurple.withOpacity(0.15) : Colors.transparent,
                          border: isSelected
                              ? Border(
                            left: BorderSide(width: 3, color: kPurple),
                          )
                              : null,
                        ),
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: isSelected ? kPurple2 : kWhite,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
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

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
}
