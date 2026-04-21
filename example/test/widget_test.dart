import 'package:flutter_test/flutter_test.dart';
import 'package:card_shuffler_example/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const CardShufflerApp());
    expect(find.text('🃏 Card Shuffler Demo'), findsOneWidget);
  });
}
