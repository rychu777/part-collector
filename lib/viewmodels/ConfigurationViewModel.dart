// viewmodels/ConfigurationViewModel.dart

import 'package:flutter/material.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/services/CompatibilityService.dart';

class ConfigurationViewModel extends ChangeNotifier {
  static const Map<String, String> slots = {
    'CPU': 'Procesor',
    'GPU': 'Karta graficzna',
    'RAM': 'Pamięć RAM',
    'Motherboard': 'Płyta główna',
    'Cooling': 'Chłodzenie',
    'PSU': 'Zasilacz',
    'Case': 'Obudowa',
    'Disks': 'Dysk',
  };

  static const Map<String, String> slotImages = {
    'CPU': 'cpu.jpg',
    'GPU': 'gpu.jpg',
    'RAM': 'ram.jpg',
    'Cooling': 'cooling.jpg',
    'PSU': 'psu.png',
    'Case': 'case.jpg',
    'Disks': 'disc.jpg',
    'Motherboard': 'motherboard.jpg',
  };

  final String buildName;
  final Future<void> Function(List<Component>)? onSaveConfiguration;
  final Map<String, Component?> selected = {};
  final Map<String, bool> isSlotIncompatible = {};

  final CompatibilityService _compatibilityService = CompatibilityService();

  ConfigurationViewModel({required this.buildName, this.onSaveConfiguration}) {
    for (var key in slots.keys) {
      selected[key] = null;
      isSlotIncompatible[key] = false;
    }
  }

  void selectSlot(String key, Component component) {
    selected[key] = component;
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