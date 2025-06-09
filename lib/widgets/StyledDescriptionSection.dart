import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';

class StyledDescriptionSection extends StatelessWidget {
  final String description;

  const StyledDescriptionSection({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        description.isEmpty ? 'Brak opisu' : description, // Dodana obsługa pustego opisu
        style: const TextStyle(color: kWhite),
      ),
    );
  }
}