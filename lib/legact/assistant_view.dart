import 'dart:convert';
import 'dart:io'; // Pozostaje dla _saveFormData, jeśli nadal potrzebne
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Dla ładowania zasobów
import 'package:path_provider/path_provider.dart'; // Pozostaje dla _saveFormData

// Twoje stałe kolorów (bez zmian)
const Color kPrimaryDark = Color(0xFF1D1B20);
const Color kSurfaceLight = Color(0xFFE8DEF8);
const Color kSurfaceLighter = Color(0xFFFEF7FF);
const Color kWhite = Color(0xFFFFFFFF);
const Color kDarkGrey = Color(0xFF1D1B20); // Uwaga: kDarkGrey i kPrimaryDark są takie same
const Color kPurple = Color(0xFF4F378A);
const Color kPurple2 = Color(0xFF65558F);
const Color kRedError = Color(0xFF9C3732);
const Color kLightPurple = Color(0xFFD1C4E9);
const Color kMainBackground = Color(0xFF333333);

class AssistantView extends StatefulWidget {
  const AssistantView({super.key});

  @override
  State<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  int _currentStep = 0;

  int _selectedType = -1;
  int _selectedPriority = -1;

  final List<int> _budgetOptions = [2000, 3000, 4000, 5000, 8000, 16000];
  int? _selectedBudget;

  final List<String> _processorOptions = ["AMD", "Intel"];
  String? _selectedProcessor;

  final List<String> _graphicsCardOptions = ["NVIDIA", "AMD"];
  String? _selectedGraphicsCard;

  final List<String> _coolingOptions = ["Wodne", "Klasyczne"];
  String? _selectedCooling;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kWhite),
        title: const Text(
          'Asystent',
          style: TextStyle(color: kWhite),
        ),
      ),
      body: Container(
        color: kMainBackground,
        child: Column(
          children: [
            _buildProgressBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: kWhite, thickness: 1),
            ),
            Expanded(child: _buildCurrentStepContent()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: kWhite, thickness: 1),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    List<Widget> steps = [];
    const totalSteps = 4;
    for (int i = 0; i < totalSteps; i++) {
      final bool isActive = i <= _currentStep;
      steps.add(
          CircleAvatar(
            radius: 14,
            backgroundColor: isActive ? kPurple : Colors.grey[700],
            child: Text(
              (i + 1).toString(),
              style: const TextStyle(color: kWhite, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
      );
      if (i < totalSteps - 1) {
        steps.add(
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 3,
                decoration: BoxDecoration(
                    color: (i < _currentStep) ? kPurple : Colors.grey[700],
                    borderRadius: BorderRadius.circular(2)
                ),
              ),
            )
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Row(
        children: steps,
      ),
    );
  }


  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Typ zestawu'),
          _buildSubText('Zaznacz podstawowe przeznaczenie swojego sprzętu komputerowego.'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildRectRadioButton(label: 'Gaming', value: 0, groupValue: _selectedType, onChanged: (val) => setState(() => _selectedType = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildRectRadioButton(label: 'Biurowe', value: 1, groupValue: _selectedType, onChanged: (val) => setState(() => _selectedType = val!))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildRectRadioButton(label: 'Rendering', value: 2, groupValue: _selectedType, onChanged: (val) => setState(() => _selectedType = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildRectRadioButton(label: 'Obliczenia', value: 3, groupValue: _selectedType, onChanged: (val) => setState(() => _selectedType = val!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Priorytet'),
          _buildSubText('Zaznacz, na czym zależy Ci najbardziej.'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildRectRadioButton(label: 'Możliwość\nrozbudowy', value: 0, groupValue: _selectedPriority, onChanged: (val) => setState(() => _selectedPriority = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildRectRadioButton(label: 'Niezawodność', value: 1, groupValue: _selectedPriority, onChanged: (val) => setState(() => _selectedPriority = val!))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildRectRadioButton(label: 'Wydajność', value: 2, groupValue: _selectedPriority, onChanged: (val) => setState(() => _selectedPriority = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildRectRadioButton(label: 'Kultura\npracy', value: 3, groupValue: _selectedPriority, onChanged: (val) => setState(() => _selectedPriority = val!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Budżet'),
          _buildSubText('Wybierz przybliżoną kwotę, którą chcesz przeznaczyć.'),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: kSurfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedBudget != null ? kRedError : Colors.transparent,
                width: 3,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedBudget,
                isExpanded: true,
                hint: const Text(
                  'Wybierz budżet',
                  style: TextStyle(color: kDarkGrey, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: kDarkGrey, size: 28),
                dropdownColor: kSurfaceLighter,
                style: const TextStyle(color: kDarkGrey, fontSize: 18, fontWeight: FontWeight.w600),
                items: _budgetOptions.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Center(child: Text('$value zł')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedBudget = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Preferencje sprzętowe'),
          _buildSubText('Wybierz preferowane komponenty.'),
          const SizedBox(height: 24),
          _buildHardwareChoiceRow(
            title: 'Procesor',
            options: _processorOptions,
            groupValue: _selectedProcessor,
            onChanged: (val) => setState(() => _selectedProcessor = val),
          ),
          _buildHardwareChoiceRow(
            title: 'Karta graficzna',
            options: _graphicsCardOptions,
            groupValue: _selectedGraphicsCard,
            onChanged: (val) => setState(() => _selectedGraphicsCard = val),
          ),
          _buildHardwareChoiceRow(
            title: 'Chłodzenie procesora',
            options: _coolingOptions,
            groupValue: _selectedCooling,
            onChanged: (val) => setState(() => _selectedCooling = val),
          ),
        ],
      ),
    );
  }

  Widget _buildHardwareChoiceRow({
    required String title,
    required List<String> options,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: kLightPurple, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((option) {
            return Expanded(
              child: _buildRectRadioButton<String>(
                label: option,
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            );
          }).toList()
              .fold<List<Widget>>([], (previousValue, element) {
            if (previousValue.isNotEmpty) {
              previousValue.add(const SizedBox(width: 12));
            }
            previousValue.add(element);
            return previousValue;
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: kPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep == 0)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGrey,
                side: const BorderSide(color: kRedError, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Anuluj', style: TextStyle(color: kRedError, fontSize: 16)),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGrey,
                side: const BorderSide(color: kRedError, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  if (_currentStep > 0) _currentStep--;
                });
              },
              child: const Text('Powrót', style: TextStyle(color: kRedError, fontSize: 16)),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedError,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              if (!_isStepValid()) return;
              if (_currentStep < 3) {
                setState(() {
                  _currentStep++;
                });
              } else {
                await _showFinishDialog();
              }
            },
            child: Text(
              _currentStep < 3 ? 'Dalej' : 'Zakończ',
              style: const TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStepValid() {
    String errorMsg = '';
    switch (_currentStep) {
      case 0:
        if (_selectedType == -1) errorMsg = 'Proszę wybrać typ zestawu.';
        break;
      case 1:
        if (_selectedPriority == -1) errorMsg = 'Proszę wybrać priorytet.';
        break;
      case 2:
        if (_selectedBudget == null) errorMsg = 'Proszę wybrać budżet.';
        break;
      case 3:
        if (_selectedProcessor == null) errorMsg = 'Proszę wybrać procesor.';
        else if (_selectedGraphicsCard == null) errorMsg = 'Proszę wybrać kartę graficzną.';
        else if (_selectedCooling == null) errorMsg = 'Proszę wybrać rodzaj chłodzenia.';
        break;
    }
    if (errorMsg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg, style: const TextStyle(color: kWhite)),
          backgroundColor: kRedError.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _showFinishDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kSurfaceLighter,
          title: const Text('Zakończyć konfigurację?', style: TextStyle(color: kDarkGrey)),
          content: const Text(
            'Czy chcesz zakończyć i zobaczyć proponowany zestaw?',
            style: TextStyle(color: kDarkGrey),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anuluj', style: TextStyle(color: kPurple)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Tak, zakończ', style: TextStyle(color: kRedError, fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final formData = _collectFormData();
                await _saveFormData(formData);

                String? loadedBuildData;
                String? errorMessage;

                try {
                  String processorKey = _selectedProcessor!.toLowerCase();
                  String gpuKey = _selectedGraphicsCard!.toLowerCase();
                  String budgetKey = _selectedBudget.toString();


                  String fileName = '$processorKey-$gpuKey-$budgetKey.json';
                  String filePath = 'assets/default-builds/$fileName';

                  debugPrint('Próba załadowania pliku konfiguracyjnego: $filePath');
                  loadedBuildData = await rootBundle.loadString(filePath);

                  Navigator.pop(context, loadedBuildData);

                } catch (e) {
                  debugPrint('Błąd ładowania pliku konfiguracyjnego: $e');
                  errorMessage = 'Nie znaleziono predefiniowanej konfiguracji dla wybranych opcji. Spróbuj innych wyborów.';
                }

                if (errorMessage != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage, style: const TextStyle(color: kWhite)),
                      backgroundColor: kRedError,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  Map<String, dynamic> _collectFormData() {
    return {
      'selectedType': _selectedType,
      'selectedPriority': _selectedPriority,
      'selectedBudget': _selectedBudget,
      'selectedProcessor': _selectedProcessor,
      'selectedGraphicsCard': _selectedGraphicsCard,
      'selectedCooling': _selectedCooling,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _saveFormData(Map<String, dynamic> formData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/assistant_choices.json');
      await file.writeAsString(jsonEncode(formData));
      debugPrint('Dane formularza asystenta zapisane do: ${file.path}');
    } catch (e) {
      debugPrint('Błąd zapisu formularza asystenta: $e');
    }
  }

  Widget _buildHeadline(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: kWhite, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: kLightPurple, fontSize: 16),
      ),
    );
  }

  Widget _buildRectRadioButton<T>({
    required String label,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
    double? height,
  }) {
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
          boxShadow: selected ? [
            BoxShadow(
              color: kRedError.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ] : [],
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