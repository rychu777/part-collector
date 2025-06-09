import 'package:flutter/material.dart';
import 'package:first_app/viewmodels/AssistantViewModel.dart';
import 'package:first_app/legacy/constants.dart';
import 'package:first_app/widgets/AssistantWidgets.dart';

class Step3Widget extends StatelessWidget {
  final AssistantViewModel vm;
  const Step3Widget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeadline(text: 'Budżet'),
          const StepSubText(text: 'Wybierz przybliżoną kwotę.'),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: kSurfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: vm.selectedBudget != null ? kRedError : Colors.transparent,
                width: 3,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: vm.selectedBudget,
                isExpanded: true,
                hint: const Text(
                  'Wybierz budżet',
                  style: TextStyle(
                    color: kDarkGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: kDarkGrey,
                  size: 28,
                ),
                dropdownColor: kSurfaceLighter,
                style: const TextStyle(
                  color: kDarkGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                items: vm.budgetOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Center(child: Text('$value zł')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  vm.selectedBudget = newValue;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
