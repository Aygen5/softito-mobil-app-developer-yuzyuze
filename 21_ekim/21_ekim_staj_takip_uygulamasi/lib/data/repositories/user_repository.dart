import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';
import '../mock/mock_data.dart';
import '../models/user_model.dart';

/// Kullanıcı profil yönetimi veri erişim arayüzü.
abstract interface class UserRepository {
  Future<UserModel?> getUserProfile(String uid);
  Stream<UserModel?> getUserProfileStream(String uid);
  Future<void> createUserProfile(UserModel user);
  Future<void> updateUserProfile(UserModel user);
}

/// Cloud Firestore kullanan UserRepository implementasyonu.
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(AppConstants.usersCollection);

  @override
  Future<UserModel?> getUserProfile(String uid) async {
    if (uid == MockData.studentUser.uid) return MockData.studentUser;
    if (uid == MockData.companyUser.uid) return MockData.companyUser;
    if (uid == MockData.advisorUser.uid) return MockData.advisorUser;

    try {
      final doc = await _usersRef.doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Stream<UserModel?> getUserProfileStream(String uid) {
    if (uid == MockData.studentUser.uid) {
      return Stream.value(MockData.studentUser);
    }
    if (uid == MockData.companyUser.uid) {
      return Stream.value(MockData.companyUser);
    }
    if (uid == MockData.advisorUser.uid) {
      return Stream.value(MockData.advisorUser);
    }

    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    });
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _usersRef.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _usersRef.doc(user.uid).update(user.toMap());
    } on FirebaseException catch (e) {
      throw Failure.fromFirestoreCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
