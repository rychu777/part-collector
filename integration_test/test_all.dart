// integration_test/test_all.dart
import 'startup_performance_test.dart' as startup_test;
import 'build_add_delete_test.dart' as build_test;
import 'component_add_test.dart' as component_test;
import 'assistant_test.dart' as assistant_test;
import 'component_detail_test.dart' as component_detail_test;
import 'category_drawer_test.dart' as category_test;
import 'filter_drawer_test.dart' as filter_test;

// flutter test integration_test/test_all.dart
void main() {

  startup_test.main();

  build_test.main();

  component_detail_test.main();

  category_test.main();

  filter_test.main();

  component_test.main();

  assistant_test.main();
}