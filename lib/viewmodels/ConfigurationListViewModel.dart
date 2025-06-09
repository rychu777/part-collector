import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/models/component.dart';

class ConfigurationListViewModel extends ChangeNotifier {
  List<BuildFile> builds = [];
  bool isLoading = false;
  String? error;

  Future<Directory> _getGeneratedBuildsDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final genDir = Directory('${appDocDir.path}/generated-builds');
    if (!await genDir.exists()) {
      await genDir.create(recursive: true);
    }
    return genDir;
  }

  Future<void> loadBuilds() async {
    isLoading = true;
    notifyListeners();

    try {
      final genDir = await _getGeneratedBuildsDir();
      final List<BuildFile> loaded = [];

      for (var fileEntity in genDir.listSync()) {
        if (fileEntity is File && fileEntity.path.endsWith('.json')) {
          try {
            final content = await fileEntity.readAsString();
            final Map<String, dynamic> decoded = json.decode(content);
            final build = BuildFile.fromJsonMap(decoded);
            loaded.add(build);
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[ConfigListVM] Błąd parsowania ${fileEntity.path}: $e');
            }
          }
        }
      }

      builds = loaded;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBuild(BuildFile build) async {
    builds.add(build);
    notifyListeners();
    await _saveBuildToDisk(build);
  }

  Future<void> deleteBuild(int index) async {
    final toDelete = builds[index];
    builds.removeAt(index);
    notifyListeners();

    try {
      final genDir = await _getGeneratedBuildsDir();
      final fileName = _sanitizeFileName(toDelete.name);
      final filePath = '${genDir.path}/$fileName.json';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ConfigListVM] Błąd usuwania pliku: $e');
      }
    }
  }

  Future<void> updateBuild(int index, List<Component> updatedComponents) async {
    final old = builds[index];
    final updated = BuildFile(name: old.name, components: updatedComponents);
    builds[index] = updated;
    notifyListeners();
    await _saveBuildToDisk(updated);
  }

  Future<void> _saveBuildToDisk(BuildFile build) async {
    try {
      final genDir = await _getGeneratedBuildsDir();
      final fileName = _sanitizeFileName(build.name);
      final filePath = '${genDir.path}/$fileName.json';
      final Map<String, dynamic> jsonMap = build.toJsonMap();
      final file = File(filePath);
      await file.writeAsString(json.encode(jsonMap));
      if (kDebugMode) {
        debugPrint('[ConfigListVM] Zapisano build do: $filePath');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ConfigListVM] Błąd zapisu builda: $e');
      }
    }
  }

  String _sanitizeFileName(String name) {
    final sanitized = name
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w\-]'), '')
        .toLowerCase();
    return sanitized;
  }
}
