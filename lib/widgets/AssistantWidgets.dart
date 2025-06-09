import 'package:flutter/material.dart';
import 'package:first_app/legacy/constants.dart';

class RectRadioButton<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final double? height;

  const RectRadioButton({
    Key? key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        height: height ?? 70,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: kSurfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kRedError : Colors.grey.shade400,
            width: selected ? 3 : 1.5,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: kRedError.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kDarkGrey,
              fontSize: 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class StepsProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepsProgressBar({
    Key? key,
    required this.currentStep,
    this.totalSteps = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < totalSteps; i++) {
      final bool isActive = i <= currentStep;
      widgets.add(
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? kPurple : Colors.grey[700],
          child: Text(
            (i + 1).toString(),
            style: const TextStyle(
              color: kWhite,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      if (i < totalSteps - 1) {
        widgets.add(
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 3,
              decoration: BoxDecoration(
                color: (i < currentStep) ? kPurple : Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Row(children: widgets),
    );
  }
}

class StepHeadline extends StatelessWidget {
  final String text;

  const StepHeadline({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class StepSubText extends StatelessWidget {
  final String text;

  const StepSubText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kLightPurple,
          fontSize: 16,
        ),
      ),
    );
  }
}

class HardwareChoiceRow extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const HardwareChoiceRow({
    Key? key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kLightPurple,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((option) {
            return Expanded(
              child: RectRadioButton<String>(
                label: option,
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            );
          }).toList().fold<List<Widget>>([], (prev, element) {
            if (prev.isNotEmpty) prev.add(const SizedBox(width: 12));
            prev.add(element);
            return prev;
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class BottomButtonsBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isFirstStep;
  final bool isLastStep;
  final bool Function() isStepValid;

  const BottomButtonsBar({
    Key? key,
    required this.onBack,
    required this.onNext,
    required this.isFirstStep,
    required this.isLastStep,
    required this.isStepValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryDark,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDark,
                side: BorderSide(color: kRedError, width: 2),
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              ),
              onPressed: isFirstStep ? () => Navigator.pop(context) : onBack,
              child: Text(
                isFirstStep ? 'Anuluj' : 'Powrót',
                style: TextStyle(color: kRedError, fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRedError,
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              ),
              onPressed: () {
                if (!isStepValid()) {
                  String errorMsg = '';
                  switch ((isLastStep ? 3 : null)) {
                    default:
                      break;
                  }
                }
                onNext();
              },
              child: Text(
                isLastStep ? 'Zakończ' : 'Dalej',
                style: const TextStyle(
                  color: kWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
