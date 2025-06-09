// services/compatibility_service.dart

import 'package:first_app/models/component.dart';

class CompatibilityService {
  Map<String, bool> checkAllCompatibility(Map<String, Component?> selectedComponents) {
    final Map<String, bool> incompatibilityFlags = {
      for (var key in selectedComponents.keys) key: false
    };


    final cpu = selectedComponents['CPU'];
    final gpu = selectedComponents['GPU'];

    if (cpu != null && gpu != null) {
      incompatibilityFlags['CPU'] = true;
      incompatibilityFlags['GPU'] = true;
    }

    return incompatibilityFlags;
  }
}