import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/ConfigurationViewModel.dart';
import 'package:first_app/widgets/ConfigurationSlotCard.dart';

class ConfigurationSlotList extends StatelessWidget {
  final ConfigurationViewModel viewModel;
  final Function(String) onSlotTap;

  const ConfigurationSlotList({
    Key? key,
    required this.viewModel,
    required this.onSlotTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ConfigurationViewModel.slots.length,
      itemBuilder: (ctx, index) {
        final key = ConfigurationViewModel.slots.keys.elementAt(index);
        final label = ConfigurationViewModel.slots[key]!;
        final comp = viewModel.selected[key];
        final image = ConfigurationViewModel.slotImages[key]!;
        final incompatible = viewModel.isSlotIncompatible[key] ?? false;

        return ConfigurationSlotCard(
          key: ValueKey(key),
          slotKey: key,
          label: label,
          component: comp,
          image: image,
          isIncompatible: incompatible,
          onTap: () => onSlotTap(key),
        );
      },
    );
  }
}