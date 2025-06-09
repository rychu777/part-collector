import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:first_app/models/Offer.dart';
class StyledOffersSection extends StatelessWidget {
  final List<Offer> offers;

  const StyledOffersSection({Key? key, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Brak dostępnych ofert',
          style: TextStyle(color: kWhite),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Oferty',
            style: TextStyle(
              color: kWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: offers.map((offer) {
              final storeName = offer.store;
              final storePrice = offer.price;
              final storeUrl = offer.url;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kSurfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        storeName,
                        style: const TextStyle(
                          color: kDarkGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        storePrice,
                        style: const TextStyle(
                          color: kDarkGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('Przekierowanie do: $storeUrl');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRedError,
                      ),
                      child: const Text(
                        'Sprawdź',
                        style: TextStyle(color: kWhite),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}