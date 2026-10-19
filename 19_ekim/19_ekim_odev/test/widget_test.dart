import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gunlugum/main.dart';

void main() {
  testWidgets('GunlugumApp baslatildiginda takvim ekrani gorunur',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GunlugumApp());
    await tester.pumpAndSettle();

    // Uygulama basligi ve takvim bilesenlerini dogrula
    expect(find.text('Günlüğüm'), findsOneWidget);
    expect(find.text('Sessiz Defter'), findsOneWidget);
    expect(find.text('Pzt'), findsOneWidget);
    expect(find.text('Sal'), findsOneWidget);
  });

  testWidgets('Gunluk ekranina gecis ve geri donus dogrulanir',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GunlugumApp());
    await tester.pumpAndSettle();

    // "Bugün İçin Günlük Yaz" butonuna kaydır ve tıkla
    final writeButton = find.text('Bugün İçin Günlük Yaz');
    expect(writeButton, findsOneWidget);
    await tester.ensureVisible(writeButton);
    await tester.pumpAndSettle();
    await tester.tap(writeButton);
    await tester.pumpAndSettle();

    // Günlük ekranının açıldığını doğrula
    expect(find.text('Yazı Düzenleyici'), findsOneWidget);
    expect(find.text('GÜNLÜK NOTLARIM'), findsOneWidget);
    expect(find.text('Kaydet ve Mühürle'), findsOneWidget);

    // Geri butonuna basarak takvime dön
    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Tekrar ana takvim ekranında olduğunu doğrula
    expect(find.text('Günlüğüm'), findsOneWidget);
  });
}
