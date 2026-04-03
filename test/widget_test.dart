import 'package:flutter_test/flutter_test.dart';
import 'package:mysegar_flutter/main.dart';

void main() {
  testWidgets('MySegar home screen renders', (tester) async {
    await tester.pumpWidget(const MySegarApp());
    expect(find.text('MySegar'), findsOneWidget);
  });
}
