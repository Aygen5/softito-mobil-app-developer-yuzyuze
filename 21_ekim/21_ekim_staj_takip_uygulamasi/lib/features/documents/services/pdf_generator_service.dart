import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';

/// PDF formatında Resmî Staj Defteri üreten servis.
class PdfGeneratorService {
  final pw.Font? customRegularFont;
  final pw.Font? customBoldFont;

  PdfGeneratorService({
    this.customRegularFont,
    this.customBoldFont,
  });

  /// Staj defterini kurallara uygun olarak üretir ve Uint8List bayt dizisi döndürür.
  Future<Uint8List> generateInternshipJournalPdf({
    required UserModel student,
    required InternshipModel internship,
    required List<DailyReportModel> approvedReports,
    UserModel? advisor,
    UserModel? companySupervisor,
  }) async {
    final pdf = pw.Document(
      title: 'Staj Defteri - ${student.fullName}',
      author: AppConstants.appName,
      subject: 'Resmî Staj Defteri',
    );

    // Türkçe karakterleri destekleyen fontları çözümle
    final regularFont = customRegularFont ?? await _resolveRegularFont();
    final boldFont = customBoldFont ?? await _resolveBoldFont();

    final theme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
    );

    final dateFormat = DateFormat('dd.MM.yyyy');
    final totalHours = approvedReports.fold<int>(
      0,
      (sum, item) => sum + item.hoursWorked,
    );

    // 1. Kapak ve Bilgilendirme Sayfası
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(36),
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Başlık Alanı
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blue900, width: 2),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  color: PdfColors.blue50,
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'T.C. ÜNİVERSİTE / KURUM BAŞKANLIĞI',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                        color: PdfColors.blue900,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'RESMÎ STAJ TAKİP VE UYGULAMA DEFTERİ',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 18,
                        color: PdfColors.blue900,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Dijital Onaylı Staj Günlüğü Belgesi',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // Bilgi Tabloları
              pw.Text(
                '1. ÖĞRENCİ VE STAJ BİLGİLERİ',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  _buildTableRow(
                    'Öğrenci Adı Soyadı',
                    student.fullName,
                    'Öğrenci / Kurum No',
                    student.institutionId ?? '-',
                    boldFont,
                    regularFont,
                  ),
                  _buildTableRow(
                    'E-Posta Adresi',
                    student.email,
                    'Kayıt Durumu',
                    student.isActive ? 'Aktif' : 'Pasif',
                    boldFont,
                    regularFont,
                  ),
                  _buildTableRow(
                    'Staj Yapılan Kurum',
                    internship.companyName,
                    'Zorunlu İş Günü',
                    '${internship.requiredDays} İş Günü',
                    boldFont,
                    regularFont,
                  ),
                  _buildTableRow(
                    'Staj Başlangıç Tarihi',
                    dateFormat.format(internship.startDate),
                    'Staj Bitiş Tarihi',
                    dateFormat.format(internship.endDate),
                    boldFont,
                    regularFont,
                  ),
                  _buildTableRow(
                    'Onaylanan Gün Sayısı',
                    '${approvedReports.length} Gün',
                    'Toplam Çalışma Saati',
                    '$totalHours Saat',
                    boldFont,
                    regularFont,
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Onay Yetkilileri
              pw.Text(
                '2. ONAY VE DEĞERLENDİRME YETKİLİLERİ',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                children: [
                  _buildTableRow(
                    'Kurum Staj Yetkilisi',
                    companySupervisor?.fullName ?? internship.companyName,
                    'Kurum İletişim',
                    companySupervisor?.email ?? '-',
                    boldFont,
                    regularFont,
                  ),
                  _buildTableRow(
                    'Akademik Danışman',
                    advisor?.fullName ?? 'Atanmış Danışman',
                    'Danışman E-Posta',
                    advisor?.email ?? '-',
                    boldFont,
                    regularFont,
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // Açıklama Notu
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Text(
                  'Bu staj defteri; kurum yetkilisi ve akademik danışman tarafından dijital olarak incelenip çift aşamalı onayı tamamlanmış (${approvedReports.length}) adet günlük çalışma raporunu içermektedir. Onaylanmamış veya taslak durumundaki raporlar deftere dahil edilmemiştir.',
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 10,
                    color: PdfColors.grey800,
                    lineSpacing: 1.4,
                  ),
                ),
              ),

              pw.Spacer(),

              // İmza Blokları
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildSignatureBox('Öğrenci İmzası', student.fullName, boldFont, regularFont),
                  _buildSignatureBox('Kurum Yetkilisi Onay & Kaşe', companySupervisor?.fullName ?? 'Kurum Yetkilisi', boldFont, regularFont),
                  _buildSignatureBox('Akademik Danışman Onay', advisor?.fullName ?? 'Akademik Danışman', boldFont, regularFont),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text(
                  'StajTakip Sistemi Tarafından Dijital Olarak Doğrulanmıştır • ${dateFormat.format(DateTime.now())}',
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // 2. Günlük Rapor Kayıtları (MultiPage)
    if (approvedReports.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            theme: theme,
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(36),
          ),
          header: (context) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.only(bottom: 6),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.8),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Staj Defteri — ${student.fullName} (${student.institutionId ?? ''})',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Text(
                    internship.companyName,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            );
          },
          footer: (context) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(top: 12),
              padding: const pw.EdgeInsets.only(top: 6),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(color: PdfColors.grey400, width: 0.8),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Resmî Staj Günlüğü • Onaylı Kayıtlar',
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 8,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Text(
                    'Sayfa ${context.pageNumber} / ${context.pagesCount}',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            );
          },
          build: (context) {
            return [
              pw.Text(
                '3. GÜNLÜK ÇALIŞMA RAPORLARI',
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 13,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 10),
              ...List.generate(approvedReports.length, (index) {
                final report = approvedReports[index];
                final dayNumber = index + 1;
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 14),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      // Rapor Başlığı
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(5)),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'GÜN #$dayNumber — ${dateFormat.format(report.workDate)}',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 10,
                                color: PdfColors.blue900,
                              ),
                            ),
                            pw.Text(
                              'Çalışma Süresi: ${report.hoursWorked} Saat',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 9,
                                color: PdfColors.grey800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Yapılan İşler
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Yapılan İşler ve Çalışmalar:',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 9,
                                color: PdfColors.grey900,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              report.tasks,
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 9,
                                color: PdfColors.grey800,
                                lineSpacing: 1.3,
                              ),
                            ),
                            pw.SizedBox(height: 6),
                            // Kazanımlar
                            pw.Text(
                              'Öğrenilenler ve Kazanımlar:',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 9,
                                color: PdfColors.grey900,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              report.learnings,
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 9,
                                color: PdfColors.grey800,
                                lineSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Onay Şeritleri
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: PdfColors.grey200),
                          ),
                          color: PdfColors.green50,
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              '✓ Kurum Onayı: Tamamlandı',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 8,
                                color: PdfColors.green900,
                              ),
                            ),
                            pw.Text(
                              '✓ Danışman Onayı: Tamamlandı',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 8,
                                color: PdfColors.green900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ];
          },
        ),
      );
    }

    return pdf.save();
  }

  static pw.TableRow _buildTableRow(
    String label1,
    String value1,
    String label2,
    String value2,
    pw.Font boldFont,
    pw.Font regularFont,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label1, style: pw.TextStyle(font: boldFont, fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value1, style: pw.TextStyle(font: regularFont, fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(label2, style: pw.TextStyle(font: boldFont, fontSize: 9)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(value2, style: pw.TextStyle(font: regularFont, fontSize: 9)),
        ),
      ],
    );
  }

  static pw.Widget _buildSignatureBox(
    String title,
    String name,
    pw.Font boldFont,
    pw.Font regularFont,
  ) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(font: boldFont, fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            name,
            style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColors.grey800),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 28),
          pw.Container(
            height: 0.5,
            color: PdfColors.grey400,
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'İmza / Mühür',
            style: pw.TextStyle(font: regularFont, fontSize: 7, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  Future<pw.Font> _resolveRegularFont() async {
    try {
      return await PdfGoogleFonts.robotoRegular();
    } catch (_) {
      return pw.Font.helvetica();
    }
  }

  Future<pw.Font> _resolveBoldFont() async {
    try {
      return await PdfGoogleFonts.robotoBold();
    } catch (_) {
      return pw.Font.helveticaBold();
    }
  }
}
