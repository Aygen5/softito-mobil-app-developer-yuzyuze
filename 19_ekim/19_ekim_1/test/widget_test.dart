import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('SusadimApp launches with splash logo and transitions to dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pump();

    // Verify splash screen branding and logo presence
    expect(find.text('SUSADIM'), findsOneWidget);
    expect(find.text('Akıllı Hidrasyon & Fitness Takibi'), findsOneWidget);

    // Advance time past the splash delay (2200ms)
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify dashboard elements
    expect(find.text('Su & İçecek Takibi'), findsOneWidget);
    expect(find.text('İçecek & Su'), findsOneWidget);
    expect(find.text('Antrenman'), findsOneWidget);
    expect(find.text('Günlük Sıvı Dağılımı'), findsOneWidget);
    expect(find.text('İçecek Türü'), findsOneWidget);
  });
}
