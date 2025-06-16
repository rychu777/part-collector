import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:first_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding binding =
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Sprawdza czas uruchomienia aplikacji', (WidgetTester tester) async {
    // Start pomiaru czasu
    final stopwatch = Stopwatch()..start();

    // Uruchomienie aplikacji
    app.main();
    await tester.pumpAndSettle();

    // Zatrzymaj stoper po pełnym załadowaniu UI
    stopwatch.stop();
    final elapsed = stopwatch.elapsedMilliseconds;

    print('Czas uruchamiania aplikacji: $elapsed ms');

    // Możesz też asertywne ograniczenie dodać:
    expect(elapsed < 2000, true, reason: 'Aplikacja uruchamia się zbyt długo');
  });
}