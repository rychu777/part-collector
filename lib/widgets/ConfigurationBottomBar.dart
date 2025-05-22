import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class ConfigurationBottomBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSummaryPressed;

  const ConfigurationBottomBar({
    Key? key,
    required this.onBackPressed,
    required this.onSummaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGrey,
                side: const BorderSide(color: kRedError, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onBackPressed,
              child: const Text('Powrót', style: TextStyle(color: kRedError, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRedError,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onSummaryPressed,
              child: const Text('Podsumowanie', style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}