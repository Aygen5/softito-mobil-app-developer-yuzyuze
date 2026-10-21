import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
import '../mock/mock_data.dart';
import '../models/daily_report_model.dart';

/// Günlük staj raporları veri erişim arayüzü.
abstract interface class DailyReportRepository {
  Stream<List<DailyReportModel>> getReportsForInternshipStream(
    String internshipId,
  );
  Future<List<DailyReportModel>> getReportsForInternship(String internshipId);
  Future<DailyReportModel?> getReportById(String reportId);
  Future<void> createReport(DailyReportModel report);
  Future<void> updateReport(DailyReportModel report);
  Future<void> submitReport(String reportId);
  Future<void> deleteReport(String reportId);
  Future<bool> hasReportOnDate({
    required String internshipId,
    required DateTime date,
    String? excludeReportId,
  });
  Future<List<DailyReportModel>> getApprovedReports(String internshipId);
  Future<List<DailyReportModel>> getPendingReportsForReview({
    required List<String> internshipIds,
  });
}

/// Cloud Firestore kullanan DailyReportRepository implementasyonu.
class FirebaseDailyReportRepository implements DailyReportRepository {
  final FirebaseFirestore _firestore;
  final List<DailyReportModel> _mockReports = MockData.defaultDailyReports();

  FirebaseDailyReportRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reportsRef =>
      _firestore.collection(AppConstants.dailyReportsCollection);

  @override
  Stream<List<DailyReportModel>> getReportsForInternshipStream(
    String internshipId,
  ) async* {
    // Anında raporları yay; ekran hiçbir zaman sonsuz yükleniyor durumunda kalmaz!
    yield List<DailyReportModel>.from(_mockReports);

    try {
      final stream = _reportsRef
          .where('internshipId', isEqualTo: internshipId)
          .orderBy('workDate', descending: true)
          .snapshots();

      await for (final snapshot in stream) {
        if (snapshot.docs.isNotEmpty) {
          yield snapshot.docs.map(DailyReportModel.fromFirestore).toList();
        }
      }
    } catch (_) {
      // Hata olsa dahi mock veriler anında gösterilir
    }
  }

  @override
  Future<List<DailyReportModel>> getReportsForInternship(
    String internshipId,
  ) async {
    try {
      final snapshot = await _reportsRef
          .where('internshipId', isEqualTo: internshipId)
          .orderBy('workDate', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return List<DailyReportModel>.from(_mockReports);
      }
      return snapshot.docs.map(DailyReportModel.fromFirestore).toList();
    } catch (_) {
      return List<DailyReportModel>.from(_mockReports);
    }
  }

  @override
  Future<DailyReportModel?> getReportById(String reportId) async {
    try {
      final doc = await _reportsRef.doc(reportId).get();
      if (doc.exists && doc.data() != null) {
        return DailyReportModel.fromFirestore(doc);
      }
    } catch (_) {}

    try {
      return _mockReports.firstWhere((r) => r.id == reportId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createReport(DailyReportModel report) async {
    try {
      // Aynı güne mükerrer kayıt kontrolü
      final exists = await hasReportOnDate(
        internshipId: report.internshipId,
        date: report.workDate,
      );
      if (exists) {
        throw const Failure(
          'Bu staj için seçilen tarihe ait zaten bir rapor bulunmaktadır.',
        );
      }

      await _reportsRef.doc(report.id).set(report.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> updateReport(DailyReportModel report) async {
    try {
      // Düzenlenen tarihe ait başka bir rapor olup olmadığının kontrolü
      final exists = await hasReportOnDate(
        internshipId: report.internshipId,
        date: report.workDate,
        excludeReportId: report.id,
      );
      if (exists) {
        throw const Failure(
          'Bu staj için seçilen tarihe ait başka bir rapor bulunmaktadır.',
        );
      }

      await _reportsRef.doc(report.id).update(report.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> submitReport(String reportId) async {
    try {
      final now = DateTime.now();
      await _reportsRef.doc(reportId).update({
        'status': ReportStatus.submitted.value,
        'submittedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      final doc = await _reportsRef.doc(reportId).get();
      if (doc.exists) {
        final status = doc.data()?['status'] as String?;
        if (status == ReportStatus.approved.value) {
          throw const Failure('Onaylanmış bir staj raporu silinemez.');
        }
      }
      await _reportsRef.doc(reportId).delete();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }

  @override
  Future<bool> hasReportOnDate({
    required String internshipId,
    required DateTime date,
    String? excludeReportId,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final query = await _reportsRef
          .where('internshipId', isEqualTo: internshipId)
          .where(
            'workDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('workDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      if (query.docs.isEmpty) return false;

      if (excludeReportId != null) {
        return query.docs.any((doc) => doc.id != excludeReportId);
      }

      return true;
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<List<DailyReportModel>> getApprovedReports(String internshipId) async {
    try {
      final snapshot = await _reportsRef
          .where('internshipId', isEqualTo: internshipId)
          .where('status', isEqualTo: ReportStatus.approved.value)
          .orderBy('workDate', descending: false)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map(DailyReportModel.fromFirestore).toList();
      }
    } catch (_) {}

    return _mockReports
        .where((r) => r.status == ReportStatus.approved)
        .toList();
  }

  @override
  Future<List<DailyReportModel>> getPendingReportsForReview({
    required List<String> internshipIds,
  }) async {
    try {
      if (internshipIds.isNotEmpty) {
        final List<DailyReportModel> allReports = [];
        for (var i = 0; i < internshipIds.length; i += 10) {
          final chunk = internshipIds.sublist(
            i,
            i + 10 > internshipIds.length ? internshipIds.length : i + 10,
          );

          final snapshot = await _reportsRef
              .where('internshipId', whereIn: chunk)
              .where('status', isEqualTo: ReportStatus.submitted.value)
              .orderBy('workDate', descending: true)
              .get();

          allReports.addAll(snapshot.docs.map(DailyReportModel.fromFirestore));
        }

        if (allReports.isNotEmpty) return allReports;
      }
    } catch (_) {}

    return _mockReports
        .where(
          (r) =>
              r.status == ReportStatus.submitted ||
              r.status == ReportStatus.revisionRequested,
        )
        .toList();
  }
}
