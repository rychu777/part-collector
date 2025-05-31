// lib/models/BuildFile.dart

import 'package:first_app/models/component.dart';

class BuildFile {
  final String name;
  final List<Component> components;

  BuildFile({required this.name, required this.components});

  factory BuildFile.fromJsonMap(Map<String, dynamic> map) {
    final name = map['name'] as String;
    final compList = (map['components'] as List<dynamic>).map((e) {
      return Component.fromJson(e as Map<String, dynamic>);
    }).toList();
    return BuildFile(name: name, components: compList);
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'components': components.map((c) => c.toJson()).toList(),
    };
  }
}
