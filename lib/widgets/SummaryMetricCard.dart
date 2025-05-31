// File: lib/widgets/summary_metric_card.dart

import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/SummaryViewModel.dart';
import 'package:first_app/legact/constants.dart';

class SummaryMetricCard extends StatelessWidget {
  final SummaryMetric metric;
  const SummaryMetricCard({Key? key, required this.metric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    valueColor:
                    AlwaysStoppedAnimation<Color>(metric.progressBarColor),
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
