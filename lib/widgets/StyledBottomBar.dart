// lib/views/widgets/styled_bottom_bar.dart
import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class StyledBottomBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onAddPressed;

  const StyledBottomBar({
    Key? key,
    required this.onBackPressed,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGrey,
              side: const BorderSide(color: kRedError, width: 3),
              textStyle: const TextStyle(color: kRedError), // Styl dla tekstu
            ),
            onPressed: onBackPressed,
            child: const Text(
              'Powrót',
              style: TextStyle(color: kRedError), // Styl dla tekstu
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedError,
              textStyle: const TextStyle(color: kWhite), // Styl dla tekstu
            ),
            onPressed: onAddPressed,
            child: const Text(
              'Dodaj',
              style: TextStyle(color: kWhite), // Styl dla tekstu
            ),
          ),
        ],
      ),
    );
  }
}