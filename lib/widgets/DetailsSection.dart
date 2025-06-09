import 'package:flutter/material.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:first_app/models/Offer.dart';

class DetailsSection extends StatelessWidget {
  final DetailedProduct product;
  const DetailsSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(color: kWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Od ${product.price}', style: const TextStyle(color: kLightPurple, fontSize: 16)),
              ],
            ),
          ),
          const Divider(color: kWhite),
          _SpecsList(specs: product.specs),
          const Divider(color: kWhite),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(product.description, style: const TextStyle(color: kWhite)),
          ),
          const Divider(color: kWhite),
          _OffersSection(offers: product.offers),
        ],
      ),
    );
  }
}

class _SpecsList extends StatelessWidget {
  final Map<String, String> specs;
  const _SpecsList({required this.specs});

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('Brak specyfikacji', style: TextStyle(color: kWhite)));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: specs.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [Expanded(flex:3, child: Text(e.key, style: const TextStyle(color: kWhite, fontWeight: FontWeight.bold))), const SizedBox(width:8), Expanded(flex:5, child: Text(e.value, style: const TextStyle(color: kLightPurple))),],
          ),
        )).toList(),
      ),
    );
  }
}

class _OffersSection extends StatelessWidget {
  final List<Offer> offers;
  const _OffersSection({required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Oferty', style: TextStyle(color: kWhite, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...offers.map((o) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kSurfaceLight, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [Expanded(flex:3, child: Text(o.store, style: const TextStyle(color: kDarkGrey, fontWeight: FontWeight.w600))), Expanded(flex:2, child: Text(o.price, style: const TextStyle(color: kDarkGrey))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRedError), onPressed: () => debugPrint('Przekierowanie: ${o.url}'), child: const Text('Sprawdź', style: TextStyle(color: kWhite))),],
            ),
          )),
        ],
      ),
    );
  }
}