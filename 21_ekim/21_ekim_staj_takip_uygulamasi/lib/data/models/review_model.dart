import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'user_model.dart';

/// İnceleme kararını belirten enum.
enum ReviewDecision {
  approve('approve', 'Onaylandı'),
  requestRevision('requestRevision', 'Düzeltme İstendi');

  final String value;
  final String label;

  const ReviewDecision(this.value, this.label);

  static ReviewDecision fromString(String? decision) {
    switch (decision?.toLowerCase()) {
      case 'requestrevision':
      case 'duzeltme':
        return ReviewDecision.requestRevision;
      case 'approve':
      case 'onay':
      default:
        return ReviewDecision.approve;
    }
  }

  bool get isApprove => this == ReviewDecision.approve;
  bool get isRevision => this == ReviewDecision.requestRevision;

  // Takma adlar
  static const ReviewDecision approved = ReviewDecision.approve;
  static const ReviewDecision revisionRequested = ReviewDecision.requestRevision;
}

/// Firestore `reviews` koleksiyonu veri modeli (Onay ve inceleme geçmişi).
class ReviewModel extends Equatable {
  final String id;
  final String reportId;
  final String reviewerId;
  final UserRole reviewerRole;
  final ReviewDecision decision;
  final String? comment;
  final double? score;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.reportId,
    required this.reviewerId,
    required this.reviewerRole,
    required this.decision,
    this.comment,
    this.score,
    required this.createdAt,
  });

  ReviewModel copyWith({
    String? id,
    String? reportId,
    String? reviewerId,
    UserRole? reviewerRole,
    ReviewDecision? decision,
    String? comment,
    double? score,
    DateTime? createdAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerRole: reviewerRole ?? this.reviewerRole,
      decision: decision ?? this.decision,
      comment: comment ?? this.comment,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reportId': reportId,
      'reviewerId': reviewerId,
      'reviewerRole': reviewerRole.value,
      'decision': decision.value,
      'comment': comment,
      'score': score,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return ReviewModel(
      id: docId ?? (map['id'] as String? ?? ''),
      reportId: map['reportId'] as String? ?? '',
      reviewerId: map['reviewerId'] as String? ?? '',
      reviewerRole: UserRole.fromString(map['reviewerRole'] as String?),
      decision: ReviewDecision.fromString(map['decision'] as String?),
      comment: map['comment'] as String?,
      score: (map['score'] as num?)?.toDouble(),
      createdAt: parseDate(map['createdAt']),
    );
  }

  factory ReviewModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ReviewModel.fromMap(data, docId: doc.id);
  }

  @override
  List<Object?> get props => [
    id,
    reportId,
    reviewerId,
    reviewerRole,
    decision,
    comment,
    score,
    createdAt,
  ];
}
