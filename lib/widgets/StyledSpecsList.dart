import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class StyledSpecsList extends StatelessWidget {
  final Map<String, dynamic> specs;

  const StyledSpecsList({Key? key, required this.specs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Brak specyfikacji',
          style: TextStyle(color: kWhite),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: specs.entries.map((entry) {
          final paramName = entry.key;
          final paramValue = entry.value.toString();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    paramName,
                    style: const TextStyle(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Text(
                    paramValue,
                    style: const TextStyle(color: kLightPurple),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}