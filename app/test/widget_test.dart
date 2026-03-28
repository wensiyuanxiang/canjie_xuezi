import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zaozi/app.dart';

void main() {
  testWidgets('home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ZaoziApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('仓颉学字'), findsOneWidget);
    expect(find.text('开始冒险'), findsOneWidget);
    expect(find.text('山野冒险'), findsNWidgets(2));
  });
}
