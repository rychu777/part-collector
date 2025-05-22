import 'package:flutter/foundation.dart';
import 'package:first_app/models/component.dart';

class SummaryViewModel extends ChangeNotifier {
  final String buildName;
  List<Component> components;
  Map<String, bool> isSlotIncompatible;

  SummaryViewModel({
    required this.buildName,
    required this.components,
    Map<String, bool>? incompatibilities,
  }) : isSlotIncompatible = incompatibilities ?? {};

  double get totalPrice => components.fold(0.0, (sum, c) => sum + c.price);

  void saveConfiguration(Future<void> Function(List<Component>)? onSave) async {
    if (onSave != null) {
      await onSave(components);
    }
  }
}