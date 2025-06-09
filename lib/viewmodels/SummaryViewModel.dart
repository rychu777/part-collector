import 'package:flutter/material.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/legacy/constants.dart';
import 'dart:math';

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
    final random = Random();

    final availabilityPercentage = random.nextInt(61) + 30; // 30–90

    final benchmarkPercentage = (totalPrice / 10000 * 100).clamp(0, 100).round();

    final inCompatibleCount =
        isSlotIncompatible.values.where((flag) => flag).length;
    final totalCount = components.length;
    final compatibilityPercentage = totalCount > 0
        ? (((totalCount - inCompatibleCount) / totalCount) * 100).round()
        : 100;
    final isFullyCompatible = compatibilityPercentage == 100;

    final completenessPercentage = ((components.length / 8) * 100).round();

    metrics = [
      SummaryMetric(
        iconData: isFullyCompatible ? Icons.check_circle : Icons.cancel,
        iconColor: isFullyCompatible ? kMetricGreen : kMetricRed,
        progressBarColor: isFullyCompatible ? kMetricGreen : kMetricRed,
        percentage: compatibilityPercentage,
        label: 'Kompatybilność',
        statusText: isFullyCompatible ? 'PEŁNY/A' : 'NIEPEŁNY/A',
      ),
      SummaryMetric(
        iconData: _getGenericIcon(benchmarkPercentage).icon,
        iconColor: _getGenericIcon(benchmarkPercentage).color,
        progressBarColor: _getGenericIcon(benchmarkPercentage).color,
        percentage: benchmarkPercentage,
        label: 'Benchmark',
        statusText: _getStatusText(benchmarkPercentage),
      ),
      SummaryMetric(
        iconData: _getGenericIcon(completenessPercentage).icon,
        iconColor: _getGenericIcon(completenessPercentage).color,
        progressBarColor: _getGenericIcon(completenessPercentage).color,
        percentage: completenessPercentage,
        label: 'Kompletność',
        statusText: _getStatusText(completenessPercentage),
      ),
      SummaryMetric(
        iconData: _getGenericIcon(availabilityPercentage).icon,
        iconColor: _getGenericIcon(availabilityPercentage).color,
        progressBarColor: _getGenericIcon(availabilityPercentage).color,
        percentage: availabilityPercentage,
        label: 'Dostępność',
        statusText: _getStatusText(availabilityPercentage),
      ),
    ];
  }

  String _getStatusText(int percentage) {
    if (percentage >= 65) return 'DOBRY/A';
    if (percentage >= 35) return 'UMIARKOWANY/A';
    return 'SŁABY/A';
  }

  ({IconData icon, Color color}) _getGenericIcon(int percentage) {
    if (percentage >= 65) {
      return (icon: Icons.check_circle, color: kMetricGreen);
    } else if (percentage >= 35) {
      return (icon: Icons.warning_amber_rounded, color: kMetricYellow);
    } else {
      return (icon: Icons.cancel, color: kMetricRed);
    }
  }

  Future<void> saveConfiguration(
      Future<void> Function(List<Component>)? onSave) async {
    if (onSave != null) {
      await onSave(components);
    }
  }
}
