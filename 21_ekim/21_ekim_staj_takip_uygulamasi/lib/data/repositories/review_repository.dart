import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
import '../models/daily_report_model.dart';
import '../models/review_model.dart';

/// Rapor onay, puanlama ve düzeltme geçmişi veri erişim arayüzü.
abstract interface class ReviewRepository {
  Future<void> submitReview({
    required ReviewModel review,
    required DailyReportModel updatedReport,
  });
  Future<List<ReviewModel>> getReviewsForReport(String reportId);
  Stream<List<ReviewModel>> getReviewsForReportStream(String reportId);
}

/// Cloud Firestore kullanan ReviewRepository implementasyonu.
class FirebaseReviewRepository implements ReviewRepository {
  final FirebaseFirestore _firestore;

  FirebaseReviewRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reviewsRef =>
      _firestore.collection(AppConstants.reviewsCollection);

  CollectionReference<Map<String, dynamic>> get _reportsRef =>
      _firestore.collection(AppConstants.dailyReportsCollection);

  @override
  Future<void> submitReview({
    required ReviewModel review,
    required DailyReportModel updatedReport,
  }) async {
    try {
      // Değerlendirme kaydı ile rapor durum güncellemesi batch ile atomik yapılır
      final batch = _firestore.batch();

      // 1. İnceleme geçmişine yeni belge ekle
      final reviewDoc = _reviewsRef.doc(review.id.isEmpty ? null : review.id);
      final finalReview = review.id.isEmpty
          ? review.copyWith(id: reviewDoc.id)
          : review;
      batch.set(reviewDoc, finalReview.toMap());

      // 2. Rapor belgesini yeni durum ve onay bayraklarıyla güncelle
      final reportDoc = _reportsRef.doc(updatedReport.id);
      batch.update(reportDoc, updatedReport.toMap());

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<List<ReviewModel>> getReviewsForReport(String reportId) async {
    try {
      final snapshot = await _reviewsRef
          .where('reportId', isEqualTo: reportId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map(ReviewModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Stream<List<ReviewModel>> getReviewsForReportStream(String reportId) {
    return _reviewsRef
        .where('reportId', isEqualTo: reportId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(ReviewModel.fromFirestore).toList();
        });
  }
}
