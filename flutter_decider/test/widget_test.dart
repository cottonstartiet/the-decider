import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_decider/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DeciderApp());

    expect(find.text('Decider'), findsOneWidget);
    expect(find.text('Heads or Tails'), findsOneWidget);
  });
}
