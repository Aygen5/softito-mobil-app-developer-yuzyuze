import 'package:flutter_test/flutter_test.dart';
import 'package:staj_takip/data/models/user_model.dart';

void main() {
  group('UserModel Serialization Tests', () {
    final now = DateTime(2026, 10, 21, 14, 0);
    final user = UserModel(
      uid: 'user_123',
      fullName: 'Ahmet Yılmaz',
      email: 'ahmet@universite.edu.tr',
      role: UserRole.student,
      institutionId: 'inst_1',
      isActive: true,
      createdAt: now,
    );

    test('toMap and fromMap should be consistent', () {
      final map = user.toMap();
      expect(map['uid'], 'user_123');
      expect(map['role'], 'student');
      expect(map['fullName'], 'Ahmet Yılmaz');

      final deserialized = UserModel.fromMap(map);
      expect(deserialized.uid, user.uid);
      expect(deserialized.role, UserRole.student);
      expect(deserialized.role.isStudent, isTrue);
      expect(deserialized.email, user.email);
    });

    test(
      'UserRole parsing should handle case-insensitive strings and aliases',
      () {
        expect(
          UserRole.fromString('companyRepresentative'),
          UserRole.companyRepresentative,
        );
        expect(UserRole.fromString('company'), UserRole.companyRepresentative);
        expect(UserRole.fromString('kurum'), UserRole.companyRepresentative);
        expect(
          UserRole.fromString('sirketyetkilisi'),
          UserRole.companyRepresentative,
        );
        expect(
          UserRole.fromString('academicAdvisor'),
          UserRole.academicAdvisor,
        );
        expect(UserRole.fromString('ADVISOR'), UserRole.academicAdvisor);
        expect(UserRole.fromString('danisman'), UserRole.academicAdvisor);
        expect(UserRole.fromString('unknown'), UserRole.student);
      },
    );
  });
}
