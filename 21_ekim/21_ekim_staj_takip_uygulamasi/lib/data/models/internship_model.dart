import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Staj sürecinin genel durumunu belirten kontrollü enum.
enum InternshipStatus {
  pending('pending', 'Onay Bekliyor'),
  active('active', 'Devam Ediyor'),
  completed('completed', 'Tamamlandı'),
  cancelled('cancelled', 'İptal Edildi');

  final String value;
  final String label;

  const InternshipStatus(this.value, this.label);

  static InternshipStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return InternshipStatus.active;
      case 'completed':
        return InternshipStatus.completed;
      case 'cancelled':
        return InternshipStatus.cancelled;
      case 'pending':
      default:
        return InternshipStatus.pending;
    }
  }

  bool get isActive => this == InternshipStatus.active;
  bool get isCompleted => this == InternshipStatus.completed;
}

/// Firestore `internships` koleksiyonu veri modeli.
class InternshipModel extends Equatable {
  final String id;
  final String studentId;
  final String? companySupervisorId;
  final String? academicAdvisorId;
  final String companyName;
  final DateTime startDate;
  final DateTime endDate;
  final int requiredDays;
  final InternshipStatus status;
  final DateTime createdAt;

  const InternshipModel({
    required this.id,
    required this.studentId,
    this.companySupervisorId,
    this.academicAdvisorId,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.requiredDays,
    this.status = InternshipStatus.active,
    required this.createdAt,
  });

  InternshipModel copyWith({
    String? id,
    String? studentId,
    String? companySupervisorId,
    String? academicAdvisorId,
    String? companyName,
    DateTime? startDate,
    DateTime? endDate,
    int? requiredDays,
    InternshipStatus? status,
    DateTime? createdAt,
  }) {
    return InternshipModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      companySupervisorId: companySupervisorId ?? this.companySupervisorId,
      academicAdvisorId: academicAdvisorId ?? this.academicAdvisorId,
      companyName: companyName ?? this.companyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requiredDays: requiredDays ?? this.requiredDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'companySupervisorId': companySupervisorId,
      'academicAdvisorId': academicAdvisorId,
      'companyName': companyName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'requiredDays': requiredDays,
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory InternshipModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return InternshipModel(
      id: docId ?? (map['id'] as String? ?? ''),
      studentId: map['studentId'] as String? ?? '',
      companySupervisorId: map['companySupervisorId'] as String?,
      academicAdvisorId: map['academicAdvisorId'] as String?,
      companyName: map['companyName'] as String? ?? '',
      startDate: parseDate(map['startDate']),
      endDate: parseDate(map['endDate']),
      requiredDays: (map['requiredDays'] as num?)?.toInt() ?? 30,
      status: InternshipStatus.fromString(map['status'] as String?),
      createdAt: parseDate(map['createdAt']),
    );
  }

  factory InternshipModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return InternshipModel.fromMap(data, docId: doc.id);
  }

  @override
  List<Object?> get props => [
    id,
    studentId,
    companySupervisorId,
    academicAdvisorId,
    companyName,
    startDate,
    endDate,
    requiredDays,
    status,
    createdAt,
  ];
}
