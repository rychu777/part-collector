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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  children: const [
                    Icon(Icons.filter_alt_outlined, color: kDarkGrey),
                    SizedBox(width: 8),
                    Text(
                      'Filtry',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: kDarkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: kDarkGrey, height: 1),
              Expanded(
                child: filterOptions.isEmpty
                    ? const Center(
                  child: Text(
                    'Brak filtrów dla tej kategorii',
                    style: TextStyle(color: kDarkGrey, fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: filterOptions.length,
                  itemBuilder: (context, index) {
                    final entry = filterOptions.entries.elementAt(index);
                    final key = entry.key;
                    final vals = entry.value.toList()..sort();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: kDarkGrey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Column(
                            children: vals.map((v) {
                              final isSelected = selectedFilters[key]?.contains(v) ?? false;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    v,
                                    style: TextStyle(
                                      color: isSelected ? kPurple : kDarkGrey,
                                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                    ),
                                  ),
                                  value: isSelected,
                                  activeColor: kPurple,
                                  checkColor: kWhite,
                                  onChanged: (checked) => onToggleFilter(key, v, checked ?? false),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 6),
                          Divider(color: kDarkGrey.withOpacity(0.2)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onApplyFilters,
                    icon: const Icon(Icons.check, size: 20, color: kWhite),
                    label: const Text(
                      'Zastosuj',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kWhite),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
