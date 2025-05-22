import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/models/component.dart';

class ConfigurationListViewModel extends ChangeNotifier {
  List<BuildFile> builds = [];
  bool isLoading = false;
  String? error;

  Future<void> loadBuilds() async {
    isLoading = true;
    notifyListeners();

    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> map = json.decode(manifest);
      final keys = map.keys
          .where((k) => k.startsWith('assets/generated-builds/') && k.endsWith('.json'))
          .toList()
        ..sort();

      final List<BuildFile> loaded = [];
      for (var path in keys) {
        final content = await rootBundle.loadString(path);
        final List<dynamic> items = json.decode(content);
        final name = path.split('/').last.replaceAll('.json', '');
        loaded.add(BuildFile.fromJson(name, items));
      }
      builds = loaded;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addBuild(BuildFile build) {
    builds.add(build);
    notifyListeners();
    // TODO: zapis do pliku
  }

  void deleteBuild(int index) {
    builds.removeAt(index);
    notifyListeners();
    // TODO: usunięcie pliku
  }

  void updateBuild(int index, List<Component> updated) {
    builds[index] = BuildFile(name: builds[index].name, components: updated);
    notifyListeners();
  }
}