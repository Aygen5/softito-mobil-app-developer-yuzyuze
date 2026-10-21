import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/failure.dart';

/// Firebase Storage dosya yükleme ve erişim veri arayüzü.
abstract interface class DocumentRepository {
  Future<String> uploadFile({
    required String path,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  });
  Future<void> deleteFile(String storagePath);
  Future<String> getDownloadUrl(String storagePath);
}

/// Firebase Storage kullanan DocumentRepository implementasyonu.
class FirebaseDocumentRepository implements DocumentRepository {
  final FirebaseStorage _storage;

  FirebaseDocumentRepository({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile({
    required String path,
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) async {
    // 1. Boyut kontrolü
    if (bytes.length > AppConstants.maxFileSizeBytes) {
      throw const Failure('Dosya boyutu 10 MB sınırını aşamaz.');
    }

    // 2. Uzantı kontrolü
    final ext = fileName.split('.').last.toLowerCase();
    if (!AppConstants.allowedFileExtensions.contains(ext)) {
      throw Failure(
        'Desteklenmeyen dosya türü ($ext). İzin verilenler: ${AppConstants.allowedFileExtensions.join(', ')}',
      );
    }

    try {
      final fullPath = '$path/$fileName';
      final ref = _storage.ref().child(fullPath);

      final metadata = SettableMetadata(
        contentType: contentType ?? _resolveContentType(ext),
        customMetadata: {
          'originalName': fileName,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = ref.putData(bytes, metadata);
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Failure.fromStorageCode(e.code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }

  @override
  Future<void> deleteFile(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Failure.fromStorageCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Failure.fromStorageCode(e.code);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  String _resolveContentType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }
}
