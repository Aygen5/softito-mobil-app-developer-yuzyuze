import 'package:flutter_test/flutter_test.dart';
import 'package:staj_takip/data/models/review_model.dart';
import 'package:staj_takip/data/models/user_model.dart';

void main() {
  group('ReviewModel Tests', () {
    final now = DateTime(2026, 7, 6, 11, 30);

    final review = ReviewModel(
      id: 'rev_55',
      reportId: 'rep_100',
      reviewerId: 'comp_1',
      reviewerRole: UserRole.companyRepresentative,
      decision: ReviewDecision.approve,
      comment: 'Günlük çalışma hedefleri başarıyla tamamlandı.',
      score: 95.0,
      createdAt: now,
    );

    test('toMap and fromMap should serialize all review fields', () {
      final map = review.toMap();
      expect(map['reviewerRole'], 'companyRepresentative');
      expect(map['decision'], 'approve');
      expect(map['score'], 95.0);
      expect(map['comment'], 'Günlük çalışma hedefleri başarıyla tamamlandı.');

      final deserialized = ReviewModel.fromMap(map);
      expect(deserialized.id, review.id);
      expect(deserialized.decision.isApprove, isTrue);
      expect(deserialized.reviewerRole.isCompanyRepresentative, isTrue);
      expect(deserialized.reviewerRole.isCompany, isTrue);
      expect(deserialized.score, 95.0);
    });

    test('ReviewDecision fromString handles revisionRequested', () {
      expect(
        ReviewDecision.fromString('requestRevision'),
        ReviewDecision.requestRevision,
      );
      expect(
        ReviewDecision.fromString('duzeltme'),
        ReviewDecision.requestRevision,
      );
      expect(ReviewDecision.fromString('approve'), ReviewDecision.approve);
    });
  });
}
