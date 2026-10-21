import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Kullanıcı rollerini belirten kontrollü enum.
enum UserRole {
  student('student', 'Öğrenci'),
  academicAdvisor('academicAdvisor', 'Akademik Danışman'),
  companyRepresentative('companyRepresentative', 'Şirket Yetkilisi');

  final String value;
  final String label;

  const UserRole(this.value, this.label);

  static UserRole fromString(String? role) {
    final normalized = role?.toLowerCase().trim();
    switch (normalized) {
      case 'companyrepresentative':
      case 'company':
      case 'kurum':
      case 'sirketyetkilisi':
      case 'şirketyetkilisi':
        return UserRole.companyRepresentative;
      case 'academicadvisor':
      case 'advisor':
      case 'danisman':
      case 'danışman':
        return UserRole.academicAdvisor;
      case 'student':
      case 'ogrenci':
      case 'öğrenci':
      default:
        return UserRole.student;
    }
  }

  bool get isStudent => this == UserRole.student;
  bool get isAcademicAdvisor => this == UserRole.academicAdvisor;
  bool get isCompanyRepresentative => this == UserRole.companyRepresentative;

  // Geriye dönük ve pratik kullanım için yardımcı getter'lar
  bool get isAdvisor => isAcademicAdvisor;
  bool get isCompany => isCompanyRepresentative;
}

/// Firestore `users` koleksiyonu veri modeli.
class UserModel extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final UserRole role;
  final String? institutionId;
  final bool isActive;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    this.institutionId,
    this.isActive = true,
    required this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    UserRole? role,
    String? institutionId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      institutionId: institutionId ?? this.institutionId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'role': role.value,
      'institutionId': institutionId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      uid: docId ?? (map['uid'] as String? ?? ''),
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String?),
      institutionId: map['institutionId'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: parseDate(map['createdAt']),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel.fromMap(data, docId: doc.id);
  }

  @override
  List<Object?> get props => [uid, fullName, email, role, institutionId, isActive, createdAt];
}
