import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('SusadimApp launches with splash logo and transitions to dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pump();

    // Splash ekranındaki marka ve başlık doğrulaması
    expect(find.text('SUSADIM v1'), findsOneWidget);
    expect(find.text('Akıllı Hidrasyon & Fitness Takibi'), findsOneWidget);

    // Animasyon ve geçiş süresini ilerlet (2200ms + geçiş)
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Dashboard ve alt navigasyon bileşenlerinin doğrulanması
    expect(find.text('Su & İçecek Takibi'), findsOneWidget);
    expect(find.text('İçecek & Su'), findsOneWidget);
    expect(find.text('Antrenman'), findsOneWidget);
    expect(find.text('Günlük Sıvı Dağılımı'), findsOneWidget);
    expect(find.text('İçecek Türü'), findsOneWidget);
  });
}
