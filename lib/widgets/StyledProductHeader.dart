import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';

class StyledProductHeader extends StatelessWidget {
  final String name;
  final double price; // Zmieniłem na double, bo tak jest w DetailProduct

  const StyledProductHeader({
    Key? key,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: kWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Od ${price.toStringAsFixed(2)} zł', // Formatowanie ceny
            style: const TextStyle(
              color: kLightPurple,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}