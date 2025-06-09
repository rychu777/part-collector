import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';

class FilterDrawerWidget extends StatelessWidget {
  final Map<String, Set<String>> filterOptions;
  final Map<String, Set<String>> selectedFilters;
  final Function(String, String, bool) onToggleFilter;
  final VoidCallback onApplyFilters;

  const FilterDrawerWidget({
    Key? key,
    required this.filterOptions,
    required this.selectedFilters,
    required this.onToggleFilter,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        color: kSurfaceLighter,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filtry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkGrey,
                  ),
                ),
              ),
              const Divider(color: kDarkGrey, thickness: 1),
              Expanded(
                child: filterOptions.isEmpty
                    ? const Center(
                  child: Text(
                    'Brak filtrów dla tej kategorii',
                    style: TextStyle(color: kDarkGrey),
                  ),
                )
                    : ListView(
                  children: filterOptions.entries.map((e) {
                    final key = e.key;
                    final vals = e.value.toList()..sort();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkGrey)),
                          const SizedBox(height: 8),
                          Column(
                            children: vals.map((v) {
                              return CheckboxListTile(
                                title: Text(v, style: const TextStyle(color: kDarkGrey)),
                                value: selectedFilters[key]?.contains(v) ?? false,
                                onChanged: (checked) => onToggleFilter(key, v, checked!),
                                activeColor: kRedError,
                                checkColor: kWhite,
                              );
                            }).toList(),
                          ),
                          const Divider(color: kDarkGrey, thickness: 1),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRedError,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  onPressed: onApplyFilters,
                  child: const Text('Zastosuj', style: TextStyle(color: kWhite, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}