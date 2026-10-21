import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Günlük rapor durumunu temsil eden kontrollü enum.
enum ReportStatus {
  draft('draft', 'Taslak'),
  submitted('submitted', 'Onay Bekliyor'),
  revisionRequested('revisionRequested', 'Düzeltme İstendi'),
  approved('approved', 'Onaylandı');

  final String value;
  final String label;

  const ReportStatus(this.value, this.label);

  static ReportStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'submitted':
      case 'onaybekliyor':
        return ReportStatus.submitted;
      case 'revisionrequested':
      case 'duzeltme':
        return ReportStatus.revisionRequested;
      case 'approved':
      case 'onaylandi':
        return ReportStatus.approved;
      case 'draft':
      case 'taslak':
      default:
        return ReportStatus.draft;
    }
  }

  bool get isDraft => this == ReportStatus.draft;
  bool get isSubmitted => this == ReportStatus.submitted;
  bool get isRevisionRequested => this == ReportStatus.revisionRequested;
  bool get isApproved => this == ReportStatus.approved;
}

/// Firestore `dailyReports` koleksiyonu veri modeli.
class DailyReportModel extends Equatable {
  final String id;
  final String internshipId;
  final String studentId;
  final DateTime workDate;
  final String tasks;
  final String learnings;
  final int hoursWorked;
  final List<String> attachmentPaths;
  final ReportStatus status;
  final bool companyApproved;
  final bool advisorApproved;
  final String? revisionComment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? submittedAt;

  const DailyReportModel({
    required this.id,
    required this.internshipId,
    required this.studentId,
    required this.workDate,
    required this.tasks,
    required this.learnings,
    this.hoursWorked = 8,
    this.attachmentPaths = const [],
    this.status = ReportStatus.draft,
    this.companyApproved = false,
    this.advisorApproved = false,
    this.revisionComment,
    required this.createdAt,
    required this.updatedAt,
    this.submittedAt,
  });

  bool get hasAttachments => attachmentPaths.isNotEmpty;

  DailyReportModel copyWith({
    String? id,
    String? internshipId,
    String? studentId,
    DateTime? workDate,
    String? tasks,
    String? learnings,
    int? hoursWorked,
    List<String>? attachmentPaths,
    ReportStatus? status,
    bool? companyApproved,
    bool? advisorApproved,
    String? revisionComment,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? submittedAt,
  }) {
    return DailyReportModel(
      id: id ?? this.id,
      internshipId: internshipId ?? this.internshipId,
      studentId: studentId ?? this.studentId,
      workDate: workDate ?? this.workDate,
      tasks: tasks ?? this.tasks,
      learnings: learnings ?? this.learnings,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      attachmentPaths: attachmentPaths ?? this.attachmentPaths,
      status: status ?? this.status,
      companyApproved: companyApproved ?? this.companyApproved,
      advisorApproved: advisorApproved ?? this.advisorApproved,
      revisionComment: revisionComment ?? this.revisionComment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'internshipId': internshipId,
      'studentId': studentId,
      'workDate': Timestamp.fromDate(workDate),
      'tasks': tasks,
      'learnings': learnings,
      'hoursWorked': hoursWorked,
      'attachmentPaths': attachmentPaths,
      'status': status.value,
      'companyApproved': companyApproved,
      'advisorApproved': advisorApproved,
      'revisionComment': revisionComment,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'submittedAt': submittedAt != null
          ? Timestamp.fromDate(submittedAt!)
          : null,
    };
  }

  factory DailyReportModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    DateTime? parseNullableDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return DailyReportModel(
      id: docId ?? (map['id'] as String? ?? ''),
      internshipId: map['internshipId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      workDate: parseDate(map['workDate']),
      tasks: map['tasks'] as String? ?? '',
      learnings: map['learnings'] as String? ?? '',
      hoursWorked: (map['hoursWorked'] as num?)?.toInt() ?? 8,
      attachmentPaths:
          (map['attachmentPaths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      status: ReportStatus.fromString(map['status'] as String?),
      companyApproved: map['companyApproved'] as bool? ?? false,
      advisorApproved: map['advisorApproved'] as bool? ?? false,
      revisionComment: map['revisionComment'] as String?,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      submittedAt: parseNullableDate(map['submittedAt']),
    );
  }

  factory DailyReportModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return DailyReportModel.fromMap(data, docId: doc.id);
  }

  @override
  List<Object?> get props => [
    id,
    internshipId,
    studentId,
    workDate,
    tasks,
    learnings,
    hoursWorked,
    attachmentPaths,
    status,
    companyApproved,
    advisorApproved,
    revisionComment,
    createdAt,
    updatedAt,
    submittedAt,
  ];
}
