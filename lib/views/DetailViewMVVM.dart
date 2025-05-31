import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/legact/constants.dart';
import 'package:first_app/viewmodels/DetailViewModel.dart';
import 'package:first_app/models/DetailedProduct.dart';
import 'package:first_app/models/component.dart';

import 'package:first_app/widgets/StyledImageCarousel.dart';
import 'package:first_app/widgets/StyledDetailsSection.dart';
import 'package:first_app/widgets/StyledBottomBar.dart';

class DetailViewMVVM extends StatelessWidget {
  final DetailedProduct product;

  const DetailViewMVVM({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailViewModel>(
      create: (_) => DetailViewModel(product),
      child: Consumer<DetailViewModel>(
        builder: (ctx, vm, _) {
          return Scaffold(
            backgroundColor: kMainBackground,
            body: SafeArea(
              child: Column(
                children: [
                  StyledImageCarousel(
                    images: product.imageUrls,
                    currentIndex: vm.currentImageIndex,
                    onPageChanged: vm.setImageIndex,
                    onBackPressed: () => Navigator.pop(ctx),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: StyledDetailsSection(product: product),
                    ),
                  ),
                  StyledBottomBar(
                    onBackPressed: () => Navigator.pop(ctx),
                    onAddPressed: () {
                      final comp = Component(
                        id: product.id,
                        name: product.name,
                        category: product.category.toUpperCase(),
                        price: product.price,
                        description: product.description,
                        imageUrls: product.imageUrls,
                        specs: product.specs,
                        manufacturer: product.manufacturer,
                        compatibilityTag: product.compatibilityTag,
                      );

                      debugPrint('Dodano ${product.name} do konfiguracji');

                      Navigator.pop(context);
                      Navigator.pop<Component>(context, comp);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
