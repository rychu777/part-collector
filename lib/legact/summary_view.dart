import 'package:flutter/material.dart';
import 'dart:ui';
import 'constants.dart';
import 'package:intl/intl.dart';

class SummaryView extends StatefulWidget {
  final String buildName;
  final List<Map<String, dynamic>> buildComponents;
  final Future<void> Function(List<Map<String, dynamic>> updatedBuild)? onSaveConfiguration;
  final Map<String, bool>? isSlotIncompatible;

  const SummaryView({
    Key? key,
    required this.buildName,
    required this.buildComponents,
    this.onSaveConfiguration,
    this.isSlotIncompatible,
  }) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryMetric {
  final IconData iconData;
  final Color iconColor;
  final Color progressBarColor;
  final int percentage;
  final String label;
  final String statusText;

  _SummaryMetric({
    required this.iconData,
    required this.iconColor,
    required this.progressBarColor,
    required this.percentage,
    required this.label,
    required this.statusText,
  });
}

class _SummaryViewState extends State<SummaryView> {
  double _totalPrice = 0.0;
  late List<_SummaryMetric> _metrics;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
    _initializeMetrics();
  }

  void _calculateTotalPrice() {
    double sum = 0.0;
    for (var component in widget.buildComponents) {
      final priceString = component['price'] as String?;
      if (priceString != null) {
        try {
          String cleanedPrice = priceString
              .replaceAll('zł', '')
              .trim()
              .replaceAll(',', '.');
          sum += double.parse(cleanedPrice);
        } catch (e) {
          debugPrint("Błąd parsowania ceny: '$priceString' - $e");
        }
      }
    }
    setState(() {
      _totalPrice = sum;
    });
  }

  void _initializeMetrics() {
    _metrics = [
      _SummaryMetric(
        iconData: Icons.check_circle,
        iconColor: kMetricGreen,
        progressBarColor: kMetricGreen,
        percentage: 100,
        label: 'Parts Compatibility',
        statusText: 'PERFECT',
      ),
      _SummaryMetric(
        iconData: Icons.check_circle,
        iconColor: kMetricGreen,
        progressBarColor: kMetricGreen,
        percentage: 92,
        label: 'Expected benchmark',
        statusText: 'VERY HIGH',
      ),
      _SummaryMetric(
        iconData: Icons.cancel,
        iconColor: kMetricRed,
        progressBarColor: kMetricRed,
        percentage: 9,
        label: 'Money/efficiency ratio',
        statusText: 'VERY BAD',
      ),
      _SummaryMetric(
        iconData: Icons.warning_amber_rounded,
        iconColor: kMetricYellow,
        progressBarColor: kMetricYellow,
        percentage: 50,
        label: 'Parts availability',
        statusText: 'MODERATE',
      ),
    ];
  }

  String _formatPrice(double price) {
    final format = NumberFormat.currency(locale: 'pl_PL', symbol: 'zł', decimalDigits: 2);
    return format.format(price);
  }

  void _performSave() async {
    if (widget.onSaveConfiguration != null) {
      await widget.onSaveConfiguration!(widget.buildComponents);
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.buildName} zapisano!')),
        );
      }
    } else {
      if (mounted) {
        Navigator.pop(context, widget.buildComponents);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brak funkcji zapisu. Konfiguracja została przekazana.')),
        );
      }
    }
  }


  Future<void> _directSave() async {
    bool hasIncompatibleParts = false;
    if (widget.isSlotIncompatible != null) {
      hasIncompatibleParts = widget.isSlotIncompatible!.values.any((isIncompatible) => isIncompatible);
    }

    if (hasIncompatibleParts) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Niekompatybilne części'),
          content: const Text('W konfiguracji znajdują się niekompatybilne części. Czy na pewno chcesz zapisać?'),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: const Text('Zapisz mimo to'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _performSave();
              },
            ),
          ],
        ),
      );
    } else {
      _performSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurfaceLighter,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        iconTheme: const IconThemeData(color: kWhite),
        title: const Text('Podsumowanie', style: TextStyle(color: kWhite)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Twój zestaw jest gotowy!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPurple.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ..._metrics.map((metric) => _buildMetricCard(metric)).toList(),
            const SizedBox(height: 32),
            Text(
              'Całkowita cena za zestaw:',
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryDark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatPrice(_totalPrice),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: kPurple,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Powrót', style: TextStyle(color: kWhite, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRedError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _directSave,
                child: const Text('Zapisz', style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(_SummaryMetric metric) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(metric.iconData, color: metric.iconColor, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${metric.percentage}%  ${metric.label} - ${metric.statusText.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryDark.withOpacity(0.9),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: metric.percentage / 100.0,
                    backgroundColor: kMetricProgressBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(metric.progressBarColor),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}