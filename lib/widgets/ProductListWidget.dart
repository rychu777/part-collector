// lib/views/widgets/product_list_widget.dart
import 'package:flutter/material.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/widgets/ProductCardWidget.dart';
import 'package:first_app/legacy/constants.dart';

class ProductListWidget extends StatelessWidget {
  final List<DetailedProduct> products;
  final Function(DetailedProduct) onProductDetails;
  final Function(DetailedProduct) onAddProduct;

  const ProductListWidget({
    Key? key,
    required this.products,
    required this.onProductDetails,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Brak produktów spełniających kryteria',
          style: TextStyle(color: kWhite, fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (itemCtx, index) {
        final product = products[index];
        return ProductCardWidget(
          product: product,
          onDetailsPressed: () => onProductDetails(product),
          onAddPressed: () => onAddProduct(product),
        );
      },
    );
  }
}