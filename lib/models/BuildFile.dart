import 'package:first_app/models/component.dart';

class BuildFile {
  final String name;
  final List<Component> components;

  BuildFile({required this.name, required this.components});

  factory BuildFile.fromJson(String name, List<dynamic> items) {
    return BuildFile(
      name: name,
      components: items.map((e) => Component.fromJson(e)).toList(),
    );
  }
}