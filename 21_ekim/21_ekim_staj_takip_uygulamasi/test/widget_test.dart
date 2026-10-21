import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:staj_takip/app.dart';
import 'package:staj_takip/data/repositories/auth_repository.dart';
import 'package:staj_takip/data/repositories/daily_report_repository.dart';
import 'package:staj_takip/data/repositories/document_repository.dart';
import 'package:staj_takip/data/repositories/internship_repository.dart';
import 'package:staj_takip/data/repositories/review_repository.dart';
import 'package:staj_takip/data/repositories/user_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockInternshipRepository extends Mock implements InternshipRepository {}

class MockDailyReportRepository extends Mock implements DailyReportRepository {}

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  testWidgets('StajTakipApp initial route renders LoginView', (
    WidgetTester tester,
  ) async {
    final mockAuthRepo = MockAuthRepository();
    final mockUserRepo = MockUserRepository();
    final mockInternshipRepo = MockInternshipRepository();
    final mockDailyReportRepo = MockDailyReportRepository();
    final mockReviewRepo = MockReviewRepository();
    final mockDocumentRepo = MockDocumentRepository();
    final controller = StreamController<User?>();

    when(() => mockAuthRepo.authStateChanges)
        .thenAnswer((_) => controller.stream);

    await tester.pumpWidget(
      StajTakipApp(
        authRepository: mockAuthRepo,
        userRepository: mockUserRepo,
        internshipRepository: mockInternshipRepo,
        dailyReportRepository: mockDailyReportRepo,
        reviewRepository: mockReviewRepo,
        documentRepository: mockDocumentRepo,
      ),
    );

    // Initial load
    controller.add(null);
    await tester.pumpAndSettle();

    expect(find.text('StajTakip'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsWidgets);
    expect(find.text('E-posta Adresi'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);

    controller.close();
  });
}
