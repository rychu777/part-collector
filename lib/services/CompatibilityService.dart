import 'package:first_app/models/component.dart';

class CompatibilityService {
  Map<String, bool> checkAllCompatibility(Map<String, Component?> selectedComponents) {
    final Map<String, bool> incompatibilityFlags = {
      for (var key in selectedComponents.keys) key: false
    };

    final cpu = selectedComponents['CPU'];
    final motherboard = selectedComponents['MOTHERBOARD'];
    final ram = selectedComponents['RAM'];
    final disk = selectedComponents['DISKS'];
    final gpu = selectedComponents['GPU'];
    final psu = selectedComponents['PSU'];
    final caseComponent = selectedComponents['CASE'];
    final coolingComponent = selectedComponents['COOLING'];


    // CPU ↔ Motherboard socket check
    if (cpu != null && motherboard != null) {
      final cpuSocket = cpu.specs['Podstawka'] ?? '';
      final motherboardSocket = motherboard.specs['Socket'] ?? '';
      if (cpuSocket != motherboardSocket) {
        incompatibilityFlags['CPU'] = true;
        incompatibilityFlags['MOTHERBOARD'] = true;
      }
    }

    // RAM ↔ Motherboard RAM standard check
    if (ram != null && motherboard != null) {
      final ramStandard = ram.specs['Standard'] ?? '';
      final motherboardRamSupport = motherboard.specs['Obsługa RAM'] ?? '';
      if (!motherboardRamSupport.contains(ramStandard)) {
        incompatibilityFlags['RAM'] = true;
        incompatibilityFlags['MOTHERBOARD'] = true;
      }
    }

    // Disk ↔ Motherboard interface check (NVMe/SATA)
    if (disk != null && motherboard != null) {
      final diskInterface = disk.specs['Interfejs'] ?? '';
      final hasNVMeSlot = (motherboard.specs['Gniazda M.2'] ?? '').contains('NVMe');
      final hasSata = (diskInterface.contains('SATA') && (motherboard.specs['Socket'] != null));
      if (diskInterface.contains('NVMe') && !hasNVMeSlot) {
        incompatibilityFlags['DISKS'] = true;
        incompatibilityFlags['MOTHERBOARD'] = true;
      } else if (diskInterface.contains('SATA') && !hasSata) {
        incompatibilityFlags['DISKS'] = true;
        incompatibilityFlags['MOTHERBOARD'] = true;
      }
    }

    // PSU ↔ GPU (power check)
    if (psu != null && gpu != null) {
      final psuPowerStr = psu.specs['Moc']?.replaceAll(RegExp(r'\D'), '') ?? '0';
      final psuPower = int.tryParse(psuPowerStr) ?? 0;

      // Szacunkowe wymaganie – RTX 3080 wymaga min. 750W itd.
      final gpuName = gpu.name.toLowerCase();
      int requiredWattage = 0;

      if (gpuName.contains('4080'))
      {
        requiredWattage = 800;
      }
      else if (gpuName.contains('3080'))
        {
          requiredWattage = 750;
        }
      else if (gpuName.contains('6800'))
        {
          requiredWattage = 650;
        }
      else if (gpuName.contains('6600'))
        {
          requiredWattage = 550;
        }
      else {
        requiredWattage = 500; // ogólny minimum
      }
      if (psuPower < requiredWattage) {
        incompatibilityFlags['PSU'] = true;
        incompatibilityFlags['GPU'] = true;
      }
    }

    // Motherboard ↔ Case (form factor)
    if (motherboard != null && caseComponent != null) {
      final moboForm = motherboard.specs['Form Factor'] ?? '';
      final caseSupport = caseComponent.specs['Obsługa'] ?? '';
      if (!caseSupport.contains(moboForm)) {
        incompatibilityFlags['Motherboard'] = true;
        incompatibilityFlags['Case'] = true;
      }
    }

    return incompatibilityFlags;
  }
}
