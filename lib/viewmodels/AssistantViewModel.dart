import 'package:flutter/foundation.dart';
import '../repositories/PrebuildRepository.dart';

class AssistantViewModel extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  int _selectedType = -1;
  int get selectedType => _selectedType;
  set selectedType(int value) {
    _selectedType = value;
    notifyListeners();
  }

  int _selectedPriority = -1;
  int get selectedPriority => _selectedPriority;
  set selectedPriority(int value) {
    _selectedPriority = value;
    notifyListeners();
  }

  int? _selectedBudget;
  int? get selectedBudget => _selectedBudget;
  set selectedBudget(int? value) {
    _selectedBudget = value;
    notifyListeners();
  }

  String? _selectedProcessor;
  String? get selectedProcessor => _selectedProcessor;
  set selectedProcessor(String? value) {
    _selectedProcessor = value;
    notifyListeners();
  }

  String? _selectedGraphicsCard;
  String? get selectedGraphicsCard => _selectedGraphicsCard;
  set selectedGraphicsCard(String? value) {
    _selectedGraphicsCard = value;
    notifyListeners();
  }

  String? _selectedCooling;
  String? get selectedCooling => _selectedCooling;
  set selectedCooling(String? value) {
    _selectedCooling = value;
    notifyListeners();
  }

  final List<int> budgetOptions = const [2000, 3000, 4000, 5000, 8000, 16000];
  final List<String> processorOptions = const ['AMD', 'Intel'];
  final List<String> graphicsCardOptions = const ['NVIDIA', 'AMD'];
  final List<String> coolingOptions = const ['Wodne', 'Klasyczne'];

  void nextStep() {
    if (isStepValid()) {
      if (_currentStep < 3) {
        _currentStep++;
        notifyListeners();
      }
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  bool isStepValid() {
    switch (_currentStep) {
      case 0:
        return _selectedType != -1;
      case 1:
        return _selectedPriority != -1;
      case 2:
        return _selectedBudget != null;
      case 3:
        return _selectedProcessor != null &&
            _selectedGraphicsCard != null &&
            _selectedCooling != null;
      default:
        return false;
    }
  }

  Future<String> loadConfiguration() async {
    if (_selectedProcessor == null ||
        _selectedGraphicsCard == null ||
        _selectedBudget == null) {
      throw Exception(
          'Nie wybrano wszystkich parametrów do wygenerowania zestawu.');
    }

    String procKey;
    if (_selectedProcessor!.toLowerCase() == 'amd') {
      procKey = 'ryzen';
    } else {
      procKey = _selectedProcessor!.toLowerCase();
    }

    final gpuKey = _selectedGraphicsCard!.toLowerCase();

    final budgetKey = _selectedBudget.toString();

    final fileName = '$procKey-$gpuKey-$budgetKey';
    final assetPath = 'assets/defaul2t-builds/$fileName';

    if (kDebugMode) {
      debugPrint('[AssistantViewModel] Próbuję załadować: $assetPath');
    }

    try {
      final repository = FirebasePrebuildRepository();
      final loaded = await repository.fetchPrebuildJsonByFileName(fileName);
      return loaded;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[AssistantViewModel] Błąd ładowania pliku konfiguracji: $e');
      }
      throw Exception('Nie znaleziono pliku konfiguracji: $assetPath');
    }
  }
}
