import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tajer/my_root_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App launches successfully", (tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    await tester.pumpWidget(MyRootApp());

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(MyRootApp), findsOneWidget);
  });
}