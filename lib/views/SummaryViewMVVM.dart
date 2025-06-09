// File: lib/views/summary_view_mvvm.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/viewmodels/SummaryViewModel.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:intl/intl.dart';
import 'package:first_app/widgets/SummaryMetricCard.dart';


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
      create: (_) => SummaryViewModel(
        buildName: buildName,
        components: components,
        incompatibilities: isSlotIncompatible,
      ),
      child: Consumer<SummaryViewModel>(
        builder: (ctx, vm, _) {
          final priceFormat = NumberFormat.currency(
            locale: 'pl_PL',
            symbol: 'zł',
            decimalDigits: 2,
          );

          return Scaffold(
            backgroundColor: kSurfaceLighter,
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              iconTheme: const IconThemeData(color: kWhite),
              title: const Text(
                'Podsumowanie',
                style: TextStyle(color: kWhite),
              ),
              centerTitle: true,
            ),


            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  Text(
                    'Twój zestaw jest gotowy!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPurple.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...vm.metrics
                      .map((metric) => SummaryMetricCard(metric: metric))
                      .toList(),

                  const SizedBox(height: 32),

                  Text(
                    'Całkowita cena za zestaw:',
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrimaryDark.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    priceFormat.format(vm.totalPrice),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: kPurple,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),


            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0)
                  .copyWith(bottom: MediaQuery.of(context).padding.bottom + 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Powrót',
                        style: TextStyle(color: kWhite, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRedError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _onSavePressed(context, vm),
                      child: const Text(
                        'Zapisz',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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


  void _onSavePressed(BuildContext context, SummaryViewModel vm) {
    if (vm.hasIncompatibleParts) {
      showDialog(
        context: context,
        builder: (ctxDialog) => AlertDialog(
          title: const Text('Niekompatybilne części'),
          content: const Text(
            'W konfiguracji znajdują się niekompatybilne części.\n'
                'Czy na pewno chcesz zapisać?',
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(ctxDialog).pop(),
            ),
            TextButton(
              child: const Text('Zapisz mimo to'),
              onPressed: () {
                Navigator.of(ctxDialog).pop();
                _performSaveAndPop(context, vm);
              },
            ),
          ],
        ),
      );
    } else {
      _performSaveAndPop(context, vm);
    }
  }

  Future<void> _performSaveAndPop(
      BuildContext context, SummaryViewModel vm) async {
    final messenger = ScaffoldMessenger.of(context);

    await vm.saveConfiguration(onSaveConfiguration);

    Navigator.pop(context);

    messenger.showSnackBar(
      SnackBar(content: Text('${vm.buildName} zapisano!')),
    );
  }
}
