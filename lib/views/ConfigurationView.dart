import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/viewmodels/ConfigurationViewModel.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/views/PartViewMVVM.dart';
import 'package:first_app/views/SummaryViewMVVM.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:first_app/widgets/ConfigurationBottomBar.dart';
import 'package:first_app/widgets/ConfigurationSlotList.dart';

class ConfigurationView extends StatelessWidget {
  final String buildName;
  final Future<void> Function(List<Component>)? onSaveConfiguration;
  final List<Component>? initialComponents;

  const ConfigurationView({
    Key? key,
    required this.buildName,
    this.onSaveConfiguration,
    this.initialComponents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigurationViewModel>(
      create: (_) => ConfigurationViewModel(
        buildName: buildName,
        onSaveConfiguration: onSaveConfiguration,
        initialComponents: initialComponents,
      ),
      child: Consumer<ConfigurationViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: kMainBackground,
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              title: Text(vm.buildName, style: const TextStyle(color: kWhite)),
              actions: [
                IconButton(
                  key: const Key('save_button'),
                  icon: const Icon(Icons.save, color: kWhite),
                  onPressed: () => vm.saveConfiguration(context),
                ),
              ],
            ),
            body: ConfigurationSlotList(
              viewModel: vm,
              onSlotTap: (key) async {
                final component = await Navigator.push<Component?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PartViewMVVM(initialCategory: key),
                  ),
                );
                if (component != null) {
                  vm.selectSlot(component.category, component);
                }
              },
            ),
            bottomNavigationBar: ConfigurationBottomBar(
              onBackPressed: () => Navigator.pop(context),
              onSummaryPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SummaryViewMVVM(
                      buildName: vm.buildName,
                      components: vm.selected.values.whereType<Component>().toList(),
                      onSaveConfiguration: vm.onSaveConfiguration,
                      isSlotIncompatible: vm.isSlotIncompatible,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}