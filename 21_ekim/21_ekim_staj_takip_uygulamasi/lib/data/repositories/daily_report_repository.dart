import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
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

  FirebaseDailyReportRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reportsRef =>
      _firestore.collection(AppConstants.dailyReportsCollection);

  @override
  Stream<List<DailyReportModel>> getReportsForInternshipStream(
    String internshipId,
  ) {
    return _reportsRef
        .where('internshipId', isEqualTo: internshipId)
        .orderBy('workDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(DailyReportModel.fromFirestore).toList();
        });
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

      return snapshot.docs.map(DailyReportModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<DailyReportModel?> getReportById(String reportId) async {
    try {
      final doc = await _reportsRef.doc(reportId).get();
      if (!doc.exists || doc.data() == null) return null;
      return DailyReportModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
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

      return snapshot.docs.map(DailyReportModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<List<DailyReportModel>> getPendingReportsForReview({
    required List<String> internshipIds,
  }) async {
    if (internshipIds.isEmpty) return [];

    try {
      // Firestore `whereIn` sınırı 10 ile limitlidir; güvenli chunklama
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

      return allReports;
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
