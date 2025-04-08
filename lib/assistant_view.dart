import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const Color kPrimaryDark = Color(0xFF1D1B20);
const Color kSurfaceLight = Color(0xFFE8DEF8);
const Color kSurfaceLighter = Color(0xFFFEF7FF);
const Color kWhite = Color(0xFFFFFFFF);
const Color kDarkGrey = Color(0xFF1D1B20);
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
  RangeValues _budgetRange = const RangeValues(0, 1000);
  final List<int> _selectedAnswers = List<int>.filled(6, -1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: kPrimaryDark,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const SafeArea(
                child: Text(
                  'Menu Mockup',
                  style: TextStyle(color: kWhite, fontSize: 24),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: kWhite, thickness: 1),
            ),
            Expanded(
              child: Container(
                color: kSurfaceLighter,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: kDarkGrey),
                      title: const Text('Przycisk 1'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, color: kDarkGrey),
                      title: const Text('Przycisk 2'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          return _buildStepCircleWithLine(index, isActive);
        }),
      ),
    );
  }

  Widget _buildStepCircleWithLine(int index, bool isActive) {
    final stepNumber = index + 1;
    final bool showLine = index < 3;

    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isActive ? kPurple : Colors.grey,
            child: Text(
              stepNumber.toString(),
              style: const TextStyle(color: kWhite),
            ),
          ),
          if (showLine)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 2,
                color: (index < _currentStep) ? kPurple : Colors.grey,
              ),
            ),
        ],
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

  // --- KROK 1 ---
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Typ zestawu'),
          _buildSubText('Zaznacz podstawowe przeznaczenie swojego sprzętu komputerowego'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Gaming',
                  selected: _selectedType == 0,
                  onTap: () => setState(() => _selectedType = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Biurowe',
                  selected: _selectedType == 1,
                  onTap: () => setState(() => _selectedType = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Rendering',
                  selected: _selectedType == 2,
                  onTap: () => setState(() => _selectedType = 2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Obliczenia',
                  selected: _selectedType == 3,
                  onTap: () => setState(() => _selectedType = 3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- KROK 2 ---
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Priorytet'),
          _buildSubText('Zaznacz na czym zależy ci najbardziej'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Możliwość\nrozbudowy',
                  selected: _selectedPriority == 0,
                  onTap: () => setState(() => _selectedPriority = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Niezawodność',
                  selected: _selectedPriority == 1,
                  onTap: () => setState(() => _selectedPriority = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Wydajność',
                  selected: _selectedPriority == 2,
                  onTap: () => setState(() => _selectedPriority = 2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRectRadioButton(
                  label: 'Kultura\npracy',
                  selected: _selectedPriority == 3,
                  onTap: () => setState(() => _selectedPriority = 3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- KROK 3 ---
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Budżet'),
          _buildSubText('Dobierz kwotę, w której zamierzasz się zmieścić'),
          const SizedBox(height: 16),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Od: ${_budgetRange.start.toInt()} zł  —  Do: ${_budgetRange.end.toInt()} zł',
                  style: const TextStyle(color: kWhite, fontSize: 16),
                ),
                RangeSlider(
                  values: _budgetRange,
                  min: 0,
                  max: 2000,
                  divisions: 40,
                  labels: RangeLabels(
                    '${_budgetRange.start.toInt()} zł',
                    '${_budgetRange.end.toInt()} zł',
                  ),
                  activeColor: kRedError,
                  inactiveColor: Colors.grey,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _budgetRange = values;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- KROK 4 ---
  Widget _buildStep4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline('Pozostałe opcje'),
          _buildSubText('Wybierz pojedyncze odpowiedzi (mniej pól)'),
          const SizedBox(height: 16),
          _buildLabeledTripleRadioRow(
            label: 'Kolor',
            questionIndex: 0,
            opt1: 'Srebrno',
            opt2: 'Niebiesko',
            opt3: 'Oba',
          ),
          _buildLabeledTripleRadioRow(
            label: 'Preferencje',
            questionIndex: 1,
            opt1: 'Tak',
            opt2: 'Niekoniecznie',
            opt3: 'Nie',
          ),
          _buildLabeledTripleRadioRow(
            label: 'Procesor',
            questionIndex: 2,
            opt1: 'AMD',
            opt2: 'Intel',
            opt3: 'Obojętnie',
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTripleRadioRow({
    required String label,
    required int questionIndex,
    required String opt1,
    required String opt2,
    required String opt3,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: kLightPurple, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildTripleRadioRow(questionIndex, opt1, opt2, opt3),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTripleRadioRow(int questionIndex, String opt1, String opt2, String opt3) {
    return Row(
      children: [
        Expanded(
          child: _buildRectRadioButton(
            label: opt1,
            selected: _selectedAnswers[questionIndex] == 0,
            onTap: () {
              setState(() {
                _selectedAnswers[questionIndex] = 0;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRectRadioButton(
            label: opt2,
            selected: _selectedAnswers[questionIndex] == 1,
            onTap: () {
              setState(() {
                _selectedAnswers[questionIndex] = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRectRadioButton(
            label: opt3,
            selected: _selectedAnswers[questionIndex] == 2,
            onTap: () {
              setState(() {
                _selectedAnswers[questionIndex] = 2;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: kPrimaryDark,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep == 0)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGrey,
                side: const BorderSide(color: kRedError, width: 3),
                textStyle: const TextStyle(color: kRedError),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Anuluj',
                style: TextStyle(color: kRedError),
              ),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGrey,
                side: const BorderSide(color: kRedError, width: 3),
                textStyle: const TextStyle(color: kRedError),
              ),
              onPressed: () {
                setState(() {
                  if (_currentStep > 0) _currentStep--;
                });
              },
              child: const Text(
                'Powrót',
                style: TextStyle(color: kRedError),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedError,
              textStyle: const TextStyle(color: kWhite),
            ),
            onPressed: () {
              if (!_isStepValid()) return;
              setState(() {
                if (_currentStep < 3) {
                  _currentStep++;
                } else {
                  _showFinishDialog();
                }
              });
            },
            child: Text(
              _currentStep < 3 ? 'Dalej' : 'Zakończ',
              style: const TextStyle(color: kWhite),
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
        if (_selectedType == -1) {
          errorMsg = 'Proszę wybrać typ zestawu.';
        }
        break;
      case 1:
        if (_selectedPriority == -1) {
          errorMsg = 'Proszę wybrać priorytet.';
        }
        break;
      case 3:
        if (_selectedAnswers[0] == -1 ||
            _selectedAnswers[1] == -1 ||
            _selectedAnswers[2] == -1) {
          errorMsg = 'Proszę uzupełnić wszystkie odpowiedzi.';
        }
        break;
      default:
        break;
    }
    if (errorMsg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
      return false;
    }
    return true;
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Czy na pewno chcesz zakończyć?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final formData = _collectFormData();
                await _saveFormData(formData);
                Navigator.pop(context, jsonEncode(formData));
              },
              child: const Text('Tak'),
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
      'budgetStart': _budgetRange.start,
      'budgetEnd': _budgetRange.end,
      'selectedAnswers': _selectedAnswers,
    };
  }

  Future<void> _saveFormData(Map<String, dynamic> formData) async {
    try {
      final file = await _getLocalFile();
      // Nadpisujemy zawartość pliku
      await file.writeAsString(jsonEncode(formData));
      debugPrint('Dane formularza zapisane do: ${file.path}');
    } catch (e) {
      debugPrint('Błąd zapisu formularza: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/form.json');
  }

  Widget _buildHeadline(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: kWhite,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(color: kLightPurple, fontSize: 16),
      ),
    );
  }

  Widget _buildRectRadioButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: kSurfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? kRedError : Colors.transparent,
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
