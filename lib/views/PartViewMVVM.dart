import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/legact/constants.dart';
import 'package:first_app/viewmodels/PartViewModel.dart';
import 'package:first_app/viewmodels/ProductCatalogViewModel.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/widgets/FilterDrawerWidget.dart';
import 'package:first_app/widgets/ProductListWidget.dart';
import 'package:first_app/widgets/CategoryDrawerWidget.dart';

class PartViewMVVM extends StatelessWidget {
  final String? initialCategory;

  const PartViewMVVM({Key? key, this.initialCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final catalog = Provider.of<ProductCatalogViewModel>(context, listen: false);

    return ChangeNotifierProvider<PartViewModel>(
      create: (_) => PartViewModel(catalog, initialCategory: initialCategory),
      child: Consumer<PartViewModel>(
        builder: (ctx, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.error != null) {
            return Scaffold(
              body: Center(
                child: Text('Błąd: ${vm.error}', style: const TextStyle(color: kRedError)),
              ),
            );
          }

          if (vm.selectedCategory.isEmpty && vm.categories.isNotEmpty) {
            vm.selectCategory(vm.categories.first);
          }

          final displayCat = vm.selectedCategory.isEmpty
              ? (vm.categories.isNotEmpty ? vm.categories.first : 'Brak kategorii')
              : vm.selectedCategory;

          return Scaffold(
            backgroundColor: kMainBackground,
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              title: Text('Wybierz podzespół: ${displayCat}', style: const TextStyle(color: kWhite)),
              actions: [
                Builder(
                  builder: (drawerCtx) => IconButton(
                    icon: const Icon(Icons.filter_list, color: kWhite),
                    onPressed: () => Scaffold.of(drawerCtx).openEndDrawer(),
                  ),
                ),
              ],
            ),
            drawer: CategoryDrawerWidget(
              categories: vm.categories,
              selectedCategory: vm.selectedCategory,
              onCategorySelected: (category) {
                Navigator.pop(ctx);
                vm.selectCategory(category);
              },
            ),
            endDrawer: FilterDrawerWidget(
              filterOptions: vm.filterOptions,
              selectedFilters: vm.selectedFilters,
              onToggleFilter: vm.toggleFilter,
              onApplyFilters: () => Navigator.pop(ctx),
            ),
            body: ProductListWidget(
              products: vm.products,
              onProductDetails: (_) {},
              onAddProduct: (product) {
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
                Navigator.pop<Component>(ctx, comp);
              },
            ),
          );
        },
      ),
    );
  }
}
