import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:gymcoach/main.dart';
import 'package:gymcoach/providers/auth_provider.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    final auth = AuthProvider();
    await auth.init();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: auth),
        ],
        child: const GymCoachApp(),
      ),
    );
    await tester.pump();

    expect(find.text('GYMCOACH'), findsWidgets);
  });
}
