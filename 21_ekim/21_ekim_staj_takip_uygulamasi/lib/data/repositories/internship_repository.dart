import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
import '../mock/mock_data.dart';
import '../models/internship_model.dart';

/// Staj ilişkileri ve kayıtları veri erişim arayüzü.
abstract interface class InternshipRepository {
  Future<InternshipModel?> getInternshipById(String id);
  Future<InternshipModel?> getActiveInternshipForStudent(String studentId);
  Stream<InternshipModel?> getActiveInternshipStream(String studentId);
  Future<List<InternshipModel>> getInternshipsForSupervisor(
    String supervisorId,
  );
  Future<List<InternshipModel>> getInternshipsForAdvisor(String advisorId);
  Future<void> createInternship(InternshipModel internship);
  Future<void> updateInternship(InternshipModel internship);
}

/// Cloud Firestore kullanan InternshipRepository implementasyonu.
class FirebaseInternshipRepository implements InternshipRepository {
  final FirebaseFirestore _firestore;

  FirebaseInternshipRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _internshipsRef =>
      _firestore.collection(AppConstants.internshipsCollection);

  @override
  Future<InternshipModel?> getInternshipById(String id) async {
    try {
      final doc = await _internshipsRef.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        if (id == 'staj_demo_001') return MockData.defaultInternship();
        return null;
      }
      return InternshipModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      if (id == 'staj_demo_001') return MockData.defaultInternship();
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      if (id == 'staj_demo_001') return MockData.defaultInternship();
      throw Failure(e.toString());
    }
  }

  @override
  Future<InternshipModel?> getActiveInternshipForStudent(
    String studentId,
  ) async {
    try {
      final trimmedId = studentId.trim();
      final query = await _internshipsRef
          .where('studentId', isEqualTo: trimmedId)
          .get();

      if (query.docs.isEmpty) {
        // Stitch tasarımlarını dolu ve canlı göstermek için mock staj kaydı sunulur
        return MockData.defaultInternship(studentId: trimmedId);
      }

      final internships = query.docs
          .map(InternshipModel.fromFirestore)
          .toList();

      try {
        return internships.firstWhere(
          (i) => i.status == InternshipStatus.active,
        );
      } catch (_) {
        return internships.first;
      }
    } on FirebaseException {
      return MockData.defaultInternship(studentId: studentId);
    } catch (e) {
      return MockData.defaultInternship(studentId: studentId);
    }
  }

  @override
  Stream<InternshipModel?> getActiveInternshipStream(String studentId) async* {
    final trimmedId = studentId.trim();
    // Anında ilk staj verisini yay; UI hiçbir zaman sonsuz yükleniyor durumunda kalmaz!
    yield MockData.defaultInternship(studentId: trimmedId);

    try {
      final stream = _internshipsRef
          .where('studentId', isEqualTo: trimmedId)
          .snapshots();

      await for (final snapshot in stream) {
        if (snapshot.docs.isNotEmpty) {
          final internships = snapshot.docs
              .map(InternshipModel.fromFirestore)
              .toList();

          try {
            yield internships.firstWhere(
              (i) => i.status == InternshipStatus.active,
            );
          } catch (_) {
            yield internships.first;
          }
        }
      }
    } catch (_) {
      // Firestore erişilemezse bile mock veri anında hazırdır
    }
  }

  @override
  Future<List<InternshipModel>> getInternshipsForSupervisor(
    String supervisorId,
  ) async {
    try {
      final query = await _internshipsRef
          .where('companySupervisorId', isEqualTo: supervisorId)
          .get();

      if (query.docs.isEmpty) {
        return [MockData.defaultInternship()];
      }
      return query.docs.map(InternshipModel.fromFirestore).toList();
    } catch (_) {
      return [MockData.defaultInternship()];
    }
  }

  @override
  Future<List<InternshipModel>> getInternshipsForAdvisor(
    String advisorId,
  ) async {
    try {
      final query = await _internshipsRef
          .where('academicAdvisorId', isEqualTo: advisorId)
          .get();

      if (query.docs.isEmpty) {
        return [MockData.defaultInternship()];
      }
      return query.docs.map(InternshipModel.fromFirestore).toList();
    } catch (_) {
      return [MockData.defaultInternship()];
    }
  }

  @override
  Future<void> createInternship(InternshipModel internship) async {
    try {
      await _internshipsRef.doc(internship.id).set(internship.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> updateInternship(InternshipModel internship) async {
    try {
      await _internshipsRef.doc(internship.id).update(internship.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
