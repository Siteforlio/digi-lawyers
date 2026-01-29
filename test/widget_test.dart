import 'package:flutter_test/flutter_test.dart';
import 'package:only_law_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const OnlyLawApp());
    await tester.pumpAndSettle();
  });
}
