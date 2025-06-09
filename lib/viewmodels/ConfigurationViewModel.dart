import 'package:flutter/material.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/services/CompatibilityService.dart';

class ConfigurationViewModel extends ChangeNotifier {
  static const Map<String, String> slots = {
    'CPU': 'Procesor',
    'GPU': 'Karta graficzna',
    'RAM': 'Pamięć RAM',
    'MOTHERBOARD': 'Płyta główna',
    'COOLING': 'Chłodzenie',
    'PSU': 'Zasilacz',
    'CASE': 'Obudowa',
    'DISKS': 'Dysk',
  };

  static const Map<String, String> slotImages = {
    'CPU': 'cpu.jpg',
    'GPU': 'gpu.jpg',
    'RAM': 'ram.jpg',
    'MOTHERBOARD': 'motherboard.jpg',
    'COOLING': 'cooling.jpg',
    'PSU': 'psu.png',
    'CASE': 'case.jpg',
    'DISKS': 'disc.jpg',
  };

  final String buildName;
  final Future<void> Function(List<Component>)? onSaveConfiguration;
  final Map<String, Component?> selected = {};
  final Map<String, bool> isSlotIncompatible = {};

  final CompatibilityService _compatibilityService = CompatibilityService();

  ConfigurationViewModel({
    required this.buildName,
    this.onSaveConfiguration,
    List<Component>? initialComponents,
  }) {
    for (var key in slots.keys) {
      selected[key] = null;
      isSlotIncompatible[key] = false;
    }

    if (initialComponents != null) {
      for (var component in initialComponents) {
        if (component.category.isNotEmpty && slots.containsKey(component.category)) {
          selected[component.category] = component;
        }
      }
    }

    _checkCompatibility();
  }

  void selectSlot(String key, Component component) {
    final newComponentWithCategory = component.copyWith(category: key);
    selected[key] = newComponentWithCategory;

    _checkCompatibility();
    notifyListeners();
  }

  void _checkCompatibility() {
    final compatibilityResults = _compatibilityService.checkAllCompatibility(selected);
    isSlotIncompatible.clear();
    isSlotIncompatible.addAll(compatibilityResults);
  }

  Future<void> saveConfiguration(BuildContext context) async {
    if (onSaveConfiguration != null) {
      await onSaveConfiguration!(selected.values.whereType<Component>().toList());
    }
    Navigator.pop(context);
  }
}