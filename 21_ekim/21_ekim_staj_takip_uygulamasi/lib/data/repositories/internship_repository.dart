import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
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
        return null;
      }
      return InternshipModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<InternshipModel?> getActiveInternshipForStudent(
    String studentId,
  ) async {
    try {
      final query = await _internshipsRef
          .where('studentId', isEqualTo: studentId)
          .where('status', isEqualTo: InternshipStatus.active.value)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        // Eğer active yoksa en son oluşturulan stajı kontrol et
        final fallback = await _internshipsRef
            .where('studentId', isEqualTo: studentId)
            .limit(1)
            .get();
        if (fallback.docs.isEmpty) return null;
        return InternshipModel.fromFirestore(fallback.docs.first);
      }

      return InternshipModel.fromFirestore(query.docs.first);
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Stream<InternshipModel?> getActiveInternshipStream(String studentId) {
    return _internshipsRef
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: InternshipStatus.active.value)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return InternshipModel.fromFirestore(snapshot.docs.first);
        });
  }

  @override
  Future<List<InternshipModel>> getInternshipsForSupervisor(
    String supervisorId,
  ) async {
    try {
      final query = await _internshipsRef
          .where('companySupervisorId', isEqualTo: supervisorId)
          .get();

      return query.docs.map(InternshipModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
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

      return query.docs.map(InternshipModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
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
