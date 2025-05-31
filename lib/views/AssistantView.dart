import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/viewmodels/AssistantViewModel.dart';
import 'package:first_app/widgets/Step1Widget.dart';
import 'package:first_app/widgets/Step2Widget.dart';
import 'package:first_app/widgets/Step3Widget.dart';
import 'package:first_app/widgets/Step4Widget.dart';
import 'package:first_app/widgets/AssistantWidgets.dart';
import 'package:first_app/legact/constants.dart';

class AssistantView extends StatelessWidget {
  const AssistantView({Key? key}) : super(key: key);

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: kWhite)),
        backgroundColor: kRedError.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onFinish(BuildContext context, AssistantViewModel vm) async {
    if (!vm.isStepValid()) return;
    try {
      final loaded = await vm.loadConfiguration();
      Navigator.pop(context, loaded);
    } catch (e) {
      _showSnackBar(context, 'Nie znaleziono predefiniowanej konfiguracji.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AssistantViewModel>(
      create: (_) => AssistantViewModel(),
      child: Consumer<AssistantViewModel>(
        builder: (ctx, vm, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              centerTitle: true,
              iconTheme: const IconThemeData(color: kWhite),
              title: const Text('Asystent', style: TextStyle(color: kWhite)),
            ),
            body: Container(
              color: kMainBackground,
              child: Column(
                children: [
                  StepsProgressBar(currentStep: vm.currentStep),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: kWhite, thickness: 1),
                  ),
                  Expanded(child: _buildStepContent(context, vm)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(color: kWhite, thickness: 1),
                  ),
                  BottomButtonsBar(
                    isFirstStep: vm.currentStep == 0,
                    isLastStep: vm.currentStep == 3,
                    isStepValid: vm.isStepValid,
                    onBack: () {
                      if (vm.currentStep == 0) {
                        Navigator.pop(context);
                      } else {
                        vm.previousStep();
                      }
                    },
                    onNext: () {
                      if (vm.currentStep < 3) {
                        if (!vm.isStepValid()) {
                          switch (vm.currentStep) {
                            case 0:
                              _showSnackBar(context, 'Proszę wybrać typ.');
                              break;
                            case 1:
                              _showSnackBar(context, 'Proszę wybrać priorytet.');
                              break;
                            case 2:
                              _showSnackBar(context, 'Proszę wybrać budżet.');
                              break;
                          }
                          return;
                        }
                        vm.nextStep();
                      } else {
                        if (!vm.isStepValid()) {
                          if (vm.selectedProcessor == null) {
                            _showSnackBar(context, 'Proszę wybrać procesor.');
                          } else if (vm.selectedGraphicsCard == null) {
                            _showSnackBar(context, 'Proszę wybrać kartę graficzną.');
                          } else if (vm.selectedCooling == null) {
                            _showSnackBar(context, 'Proszę wybrać chłodzenie.');
                          }
                          return;
                        }
                        _onFinish(context, vm);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, AssistantViewModel vm) {
    switch (vm.currentStep) {
      case 0:
        return Step1Widget(vm: vm);
      case 1:
        return Step2Widget(vm: vm);
      case 2:
        return Step3Widget(vm: vm);
      case 3:
        return Step4Widget(vm: vm);
      default:
        return Step1Widget(vm: vm);
    }
  }
}
