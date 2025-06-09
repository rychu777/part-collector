import 'package:first_app/models/component.dart';

abstract class ConfigurationRepository {
  Future<List<Component>> fetchComponents(String category);
}