import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/AssistantViewModel.dart';
import 'package:first_app/widgets/AssistantWidgets.dart';

class Step2Widget extends StatelessWidget {
  final AssistantViewModel vm;
  const Step2Widget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeadline(text: 'Priorytet'),
          const StepSubText(text: 'Zaznacz, na czym Ci zależy.'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Możliwość\nrozbudowy',
                  value: 0,
                  groupValue: vm.selectedPriority,
                  onChanged: (val) => vm.selectedPriority = val ?? -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Niezawodność',
                  value: 1,
                  groupValue: vm.selectedPriority,
                  onChanged: (val) => vm.selectedPriority = val ?? -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Wydajność',
                  value: 2,
                  groupValue: vm.selectedPriority,
                  onChanged: (val) => vm.selectedPriority = val ?? -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Kultura\npracy',
                  value: 3,
                  groupValue: vm.selectedPriority,
                  onChanged: (val) => vm.selectedPriority = val ?? -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
