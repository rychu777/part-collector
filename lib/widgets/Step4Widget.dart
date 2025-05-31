import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/AssistantViewModel.dart';
import 'package:first_app/widgets/AssistantWidgets.dart';

class Step4Widget extends StatelessWidget {
  final AssistantViewModel vm;
  const Step4Widget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeadline(text: 'Preferencje sprzętowe'),
          const StepSubText(text: 'Wybierz preferowane komponenty.'),
          const SizedBox(height: 24),
          HardwareChoiceRow(
            title: 'Procesor',
            options: vm.processorOptions,
            groupValue: vm.selectedProcessor,
            onChanged: (val) => vm.selectedProcessor = val,
          ),
          HardwareChoiceRow(
            title: 'Karta graficzna',
            options: vm.graphicsCardOptions,
            groupValue: vm.selectedGraphicsCard,
            onChanged: (val) => vm.selectedGraphicsCard = val,
          ),
          HardwareChoiceRow(
            title: 'Chłodzenie procesora',
            options: vm.coolingOptions,
            groupValue: vm.selectedCooling,
            onChanged: (val) => vm.selectedCooling = val,
          ),
        ],
      ),
    );
  }
}
