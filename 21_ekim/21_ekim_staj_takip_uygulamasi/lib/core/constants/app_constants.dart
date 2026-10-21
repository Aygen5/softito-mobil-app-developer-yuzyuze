/// StajTakip uygulaması genel sabitleri.
abstract final class AppConstants {
  // Uygulama Bilgileri
  static const appName = 'StajTakip';
  static const appVersion = '1.0.0';

  // Firestore Koleksiyon Adları
  static const usersCollection = 'users';
  static const internshipsCollection = 'internships';
  static const dailyReportsCollection = 'dailyReports';
  static const reviewsCollection = 'reviews';

  // Firebase Storage Yolları
  static const reportAttachmentsPath = 'report_attachments';

  // Dosya Kısıtlamaları
  static const maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const allowedFileExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'doc',
    'docx',
  ];

  // Varsayılan Staj Değerleri
  static const defaultRequiredDays = 30;
  static const standardDailyHours = 8;

  // Doğrulama Regex'leri
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static const minPasswordLength = 6;
}
