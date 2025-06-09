import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:first_app/models/DetailedProduct.dart';

class BottomBar extends StatelessWidget {
  final DetailedProduct? product;
  const BottomBar({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kDarkGrey, side: const BorderSide(color: kRedError, width: 3)),
            onPressed: () => Navigator.pop(context),
            child: const Text('Powrót', style: TextStyle(color: kRedError)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kRedError),
            onPressed: () => debugPrint('Dodano do koszyka'),
            child: const Text('Dodaj', style: TextStyle(color: kWhite)),
          ),
        ],
      ),
    );
  }
}
