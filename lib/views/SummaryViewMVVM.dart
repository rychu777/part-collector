import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/viewmodels/SummaryViewModel.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/legact/constants.dart';
import 'package:intl/intl.dart';

class SummaryViewMVVM extends StatelessWidget {
  final String buildName;
  final List<Component> components;
  final Future<void> Function(List<Component>)? onSaveConfiguration;
  final Map<String, bool>? isSlotIncompatible;

  const SummaryViewMVVM({
    Key? key,
    required this.buildName,
    required this.components,
    this.onSaveConfiguration,
    this.isSlotIncompatible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SummaryViewModel>(
      create: (_) =>
          SummaryViewModel(
            buildName: buildName,
            components: components,
            incompatibilities: isSlotIncompatible,
          ),
      child: Consumer<SummaryViewModel>(
        builder: (ctx, vm, _) {
          final priceFormat = NumberFormat.currency(
              locale: 'pl_PL', symbol: 'zł', decimalDigits: 2);
          return Scaffold(
            backgroundColor: kSurfaceLighter,
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              title: const Text(
                  'Podsumowanie', style: TextStyle(color: kWhite)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Twój zestaw: \${vm.buildName}', style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPurple)),
                  const SizedBox(height: 24),
                  const SizedBox(height: 32),
                  Text('Całkowita cena za zestaw:', style: TextStyle(
                      fontSize: 18, color: kPrimaryDark.withOpacity(0.7))),
                  const SizedBox(height: 8),
                  Text(priceFormat.format(vm.totalPrice),
                      style: const TextStyle(fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: kPurple)),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16).copyWith(bottom: MediaQuery
                  .of(context)
                  .padding
                  .bottom + 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryDark),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                          'Powrót', style: TextStyle(color: kWhite)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kRedError),
                      onPressed: () =>
                          vm.saveConfiguration(onSaveConfiguration),
                      child: const Text(
                          'Zapisz', style: TextStyle(color: kWhite)),
                    ),
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