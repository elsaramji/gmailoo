import 'package:flutter_test/flutter_test.dart';
import 'package:gmailoo/app/app.dart';

void main() {
  testWidgets('GmailooApp smoke test renders splash', (WidgetTester tester) async {
    await tester.pumpWidget(const GmailooApp());
    expect(find.textContaining('جيميلو'), findsWidgets);
  });
}
