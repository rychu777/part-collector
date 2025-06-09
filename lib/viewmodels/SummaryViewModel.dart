// File: lib/viewmodels/summary_view_model.dart

import 'package:flutter/material.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/legacy/constants.dart';

class SummaryMetric {
  final IconData iconData;
  final Color iconColor;
  final Color progressBarColor;
  final int percentage;
  final String label;
  final String statusText;

  SummaryMetric({
    required this.iconData,
    required this.iconColor,
    required this.progressBarColor,
    required this.percentage,
    required this.label,
    required this.statusText,
  });
}


class SummaryViewModel extends ChangeNotifier {
  final String buildName;
  final List<Component> components;
  final Map<String, bool> isSlotIncompatible;

  late final List<SummaryMetric> metrics;

  SummaryViewModel({
    required this.buildName,
    required this.components,
    Map<String, bool>? incompatibilities,
  }) : isSlotIncompatible = incompatibilities ?? {} {
    _initializeMetrics();
  }

  double get totalPrice => components.fold(0.0, (sum, c) => sum + c.price);

  bool get hasIncompatibleParts =>
      isSlotIncompatible.values.any((flag) => flag);

  void _initializeMetrics() {
    metrics = [
      SummaryMetric(
        iconData: Icons.check_circle,
        iconColor: kMetricGreen,
        progressBarColor: kMetricGreen,
        percentage: 100,
        label: 'Parts Compatibility',
        statusText: 'PERFECT',
      ),
      SummaryMetric(
        iconData: Icons.check_circle,
        iconColor: kMetricGreen,
        progressBarColor: kMetricGreen,
        percentage: 92,
        label: 'Expected benchmark',
        statusText: 'VERY HIGH',
      ),
      SummaryMetric(
        iconData: Icons.cancel,
        iconColor: kMetricRed,
        progressBarColor: kMetricRed,
        percentage: 9,
        label: 'Money/efficiency ratio',
        statusText: 'VERY BAD',
      ),
      SummaryMetric(
        iconData: Icons.warning_amber_rounded,
        iconColor: kMetricYellow,
        progressBarColor: kMetricYellow,
        percentage: 50,
        label: 'Parts availability',
        statusText: 'MODERATE',
      ),
    ];
  }

  Future<void> saveConfiguration(
      Future<void> Function(List<Component>)? onSave) async {
    if (onSave != null) {
      await onSave(components);
    }
  }
}
