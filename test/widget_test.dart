import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_assign/main.dart';

void main() {
  testWidgets('shows app title', (WidgetTester tester) async {
    await tester.pumpWidget(const HackerNewsApp());

    expect(find.text('Hacker News'), findsOneWidget);
  });
}
