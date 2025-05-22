import 'package:flutter/material.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/legact/constants.dart';

import 'package:first_app/widgets/StyledProductHeader.dart';
import 'package:first_app/widgets/StyledSpecsList.dart';
import 'package:first_app/widgets/StyledDescriptionSection.dart';
import 'package:first_app/widgets/StyledOffersSection.dart';




class StyledDetailsSection extends StatelessWidget {
  final DetailedProduct product;

  const StyledDetailsSection({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledProductHeader(
          name: product.name,
          price: product.price,
        ),
        const Divider(color: kWhite, thickness: 1),
        StyledSpecsList(specs: product.specs),
        const Divider(color: kWhite, thickness: 1),
        StyledDescriptionSection(description: product.description),
        const Divider(color: kWhite, thickness: 1),
        StyledOffersSection(offers: product.offers),
        const SizedBox(height: 16),
      ],
    );
  }
}