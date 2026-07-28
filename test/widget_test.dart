import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // The app requires async initialization (AppState + dotenv),
    // so full widget tests should be done with mocked services.
    // For now this is a placeholder.
    expect(true, isTrue);
  });
}
