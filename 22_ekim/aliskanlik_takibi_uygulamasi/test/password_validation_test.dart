import 'package:aliskanlik_takibi_uygulamasi/core/widgets/password_validation_indicator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Şifre Güvenlik Kriterleri ve Anlık Validasyon Testleri', () {
    test('Büyük harf validasyonu doğru çalışır', () {
      expect(PasswordValidationIndicator.hasUpperCase('a'), isFalse);
      expect(PasswordValidationIndicator.hasUpperCase('aygen'), isFalse);
      expect(PasswordValidationIndicator.hasUpperCase('A'), isTrue);
      expect(PasswordValidationIndicator.hasUpperCase('Aygen'), isTrue);
      expect(PasswordValidationIndicator.hasUpperCase('şemsiye'), isFalse);
      expect(PasswordValidationIndicator.hasUpperCase('Şemsiye'), isTrue);
      expect(PasswordValidationIndicator.hasUpperCase('İstanbul'), isTrue);
    });

    test('Rakam validasyonu doğru çalışır', () {
      expect(PasswordValidationIndicator.hasDigit('Aygen'), isFalse);
      expect(PasswordValidationIndicator.hasDigit('Aygen2'), isTrue);
      expect(PasswordValidationIndicator.hasDigit('Aygen2005'), isTrue);
      expect(PasswordValidationIndicator.hasDigit('2026'), isTrue);
    });

    test('En az 8 karakter validasyonu doğru çalışır', () {
      expect(PasswordValidationIndicator.hasMinLength('Aygen'), isFalse);
      expect(PasswordValidationIndicator.hasMinLength('Aygen20'), isFalse); // 7 chars
      expect(PasswordValidationIndicator.hasMinLength('Aygen200'), isTrue); // 8 chars
      expect(PasswordValidationIndicator.hasMinLength('Aygen2005'), isTrue); // 9 chars
    });

    test('Kullanıcı Aygen2005 yazdığında adım adım kurallar sağlanır', () {
      // 1. Kullanıcı sadece 'A' yazdı
      expect(PasswordValidationIndicator.hasUpperCase('A'), isTrue);
      expect(PasswordValidationIndicator.hasDigit('A'), isFalse);
      expect(PasswordValidationIndicator.hasMinLength('A'), isFalse);
      expect(PasswordValidationIndicator.isAllValid('A'), isFalse);

      // 2. Kullanıcı 'Aygen2' yazdı
      expect(PasswordValidationIndicator.hasUpperCase('Aygen2'), isTrue);
      expect(PasswordValidationIndicator.hasDigit('Aygen2'), isTrue);
      expect(PasswordValidationIndicator.hasMinLength('Aygen2'), isFalse); // 6 chars
      expect(PasswordValidationIndicator.isAllValid('Aygen2'), isFalse);

      // 3. Kullanıcı 'Aygen2005' yazdı (hepsi geçerli)
      expect(PasswordValidationIndicator.hasUpperCase('Aygen2005'), isTrue);
      expect(PasswordValidationIndicator.hasDigit('Aygen2005'), isTrue);
      expect(PasswordValidationIndicator.hasMinLength('Aygen2005'), isTrue);
      expect(PasswordValidationIndicator.isAllValid('Aygen2005'), isTrue);
    });
  });
}
