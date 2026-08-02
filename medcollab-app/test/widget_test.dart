import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/app.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AppDependencies.instance.init();
  });

  testWidgets('Vocle app shows branded splash on launch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MedCollabApp());
    await tester.pump();

    expect(find.text('For doctors. Built for India.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
