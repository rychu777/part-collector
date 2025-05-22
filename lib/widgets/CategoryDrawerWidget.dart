import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class CategoryDrawerWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

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
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Kategorie',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kWhite,
                  ),
                ),
              ),
              const Divider(color: kWhite, thickness: 1),
              Expanded(
                child: ListView(
                  children: categories.map((cat) {
                    return ListTile(
                      title: Text(
                        cat,
                        style: TextStyle(
                          color: selectedCategory == cat ? kLightPurple : kWhite,
                        ),
                      ),
                      onTap: () => onCategorySelected(cat),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}