import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/AssistantViewModel.dart';
import 'package:first_app/widgets/AssistantWidgets.dart';

class Step1Widget extends StatelessWidget {
  final AssistantViewModel vm;
  const Step1Widget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeadline(text: 'Typ zestawu'),
          const StepSubText(text: 'Zaznacz przeznaczenie sprzętu.'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Gaming',
                  value: 0,
                  groupValue: vm.selectedType,
                  onChanged: (val) => vm.selectedType = val ?? -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Biurowe',
                  value: 1,
                  groupValue: vm.selectedType,
                  onChanged: (val) => vm.selectedType = val ?? -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Rendering',
                  value: 2,
                  groupValue: vm.selectedType,
                  onChanged: (val) => vm.selectedType = val ?? -1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RectRadioButton<int>(
                  label: 'Obliczenia',
                  value: 3,
                  groupValue: vm.selectedType,
                  onChanged: (val) => vm.selectedType = val ?? -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
