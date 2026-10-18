import 'package:flutter_test/flutter_test.dart';
import 'package:musa_fly_app/main.dart';

void main() {
  testWidgets('MusaFly App boots up successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MusaFlyApp());
    expect(find.byType(MusaFlyApp), findsOneWidget);
  });
}
