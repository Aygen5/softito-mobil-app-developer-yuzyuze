import 'package:flutter_test/flutter_test.dart';
import 'package:staj_takip/data/models/internship_model.dart';

void main() {
  group('InternshipModel Tests', () {
    final start = DateTime(2026, 7, 1);
    final end = DateTime(2026, 8, 15);
    final now = DateTime(2026, 6, 20);

    final internship = InternshipModel(
      id: 'intern_001',
      studentId: 'student_1',
      companySupervisorId: 'comp_1',
      academicAdvisorId: 'adv_1',
      companyName: 'Softito Bilişim A.Ş.',
      startDate: start,
      endDate: end,
      requiredDays: 30,
      status: InternshipStatus.active,
      createdAt: now,
    );

    test('toMap and fromMap should preserve all fields', () {
      final map = internship.toMap();
      expect(map['companyName'], 'Softito Bilişim A.Ş.');
      expect(map['requiredDays'], 30);
      expect(map['status'], 'active');

      final deserialized = InternshipModel.fromMap(map);
      expect(deserialized.id, internship.id);
      expect(deserialized.companyName, internship.companyName);
      expect(deserialized.status.isActive, isTrue);
      expect(deserialized.requiredDays, 30);
    });

    test('InternshipStatus fromString handles unknown properly', () {
      expect(InternshipStatus.fromString('active'), InternshipStatus.active);
      expect(
        InternshipStatus.fromString('completed'),
        InternshipStatus.completed,
      );
      expect(
        InternshipStatus.fromString('anything_else'),
        InternshipStatus.pending,
      );
    });
  });
}
