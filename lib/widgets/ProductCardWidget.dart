import 'package:flutter/material.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/legact/constants.dart';
import 'package:first_app/views/DetailViewMVVM.dart'; // Importuj DetailViewMVVM

class ProductCardWidget extends StatelessWidget {
  final DetailedProduct product;
  final VoidCallback onDetailsPressed;
  final VoidCallback onAddPressed;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onDetailsPressed,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkGrey,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (product.imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrls.first,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: kSurfaceLighter.withOpacity(0.2),
                  child: Center(child: Icon(Icons.broken_image, color: kWhite.withOpacity(0.7), size: 50)),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(color: kWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Od \$${product.price.toStringAsFixed(2)} zł', style: const TextStyle(color: kLightPurple, fontSize: 16)),
                const SizedBox(height: 12),
                ...product.specs.entries.take(3).map((e) => Text('${e.key}: ${e.value}', style: const TextStyle(color: kWhite, fontSize: 14), overflow: TextOverflow.ellipsis)).toList(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: kSurfaceLight, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 10)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailViewMVVM(product: product)));
                          onDetailsPressed();
                        },
                        child: const Text('Szczegóły', style: TextStyle(color: kDarkGrey, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: kRedError, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 10)),
                        onPressed: onAddPressed,
                        child: const Text('Dodaj', style: TextStyle(color: kWhite, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}