import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// ============================================================================
/// MEDYA SEÇİCİ SERVİSİ (IMAGE PICKER WRAPPER)
/// ============================================================================
/// Bu servis, kullanıcının cihazındaki fotoğraf galerisinden veya kamerasından
/// görsel seçmesini sağlayan `image_picker` kütüphanesini soyutlar (wrap eder).
/// 
/// 💡 Mimari Avantajı:
/// UI ekranlarında doğrudan `ImagePicker` nesneleri ve parametreleriyle uğraşmak yerine
/// tüm görsel seçim kuralları (sıkıştırma oranı, azami genişlik, hata kontrolü)
/// bu servis katmanında merkezi olarak yönetilir.
class MedyaSecicisiService {
  // ImagePicker kütüphanesinin temel nesnesi
  final ImagePicker _imagePicker = ImagePicker();

  /// ==========================================================================
  /// 1. GALERİDEN GÖRSEL SEÇME (PICK FROM GALLERY)
  /// ==========================================================================
  /// Kullanıcının fotoğraf albümünü açar, seçilen görseli optimize eder ve File nesnesi döner.
  Future<File?> galeridenSec() async {
    // pickImage metodu cihazın varsayılan galeri uygulamasını tetikler.
    final XFile? secilen = await _imagePicker.pickImage(
      source: ImageSource.gallery, // Kaynak: Fotoğraf Galerisi
      imageQuality: 80,             // %80 kalitede sıkıştırma (performans & kota tasarrufu)
      maxWidth: 1200,               // Görsel genişliğini en fazla 1200 piksele düşürür (OOM hatalarını önler)
    );

    // Kullanıcı fotoğraf seçmeden galeriden çıkış yaptıysa null döner
    if (secilen == null) return null;

    // XFile (Cross-platform Flutter dosya soyutlaması) -> dart:io File formatına çevrilir
    return File(secilen.path);
  }

  /// ==========================================================================
  /// 2. KAMERADAN YENİ FOTOĞRAF ÇEKME (CAPTURE FROM CAMERA)
  /// ==========================================================================
  /// Cihaz kamerasını açar, kullanıcının çektiği fotoğrafı optimize eder ve File nesnesi döner.
  Future<File?> kameradanSec() async {
    // Cihaz kamerasını açar
    final XFile? secilen = await _imagePicker.pickImage(
      source: ImageSource.camera,  // Kaynak: Cihaz Kamerası
      imageQuality: 80,            // Görsel kalitesi optimize edilir
      maxWidth: 1200,              // En-boy oranı korunarak genişlik sınırlandırılır
    );

    // Kullanıcı fotoğraf çekmeden iptal ettiyse null döner
    if (secilen == null) return null;

    // Yakalanan dosyanın dosya yolunu alarak dart:io File nesnesine dönüştürüyoruz
    return File(secilen.path);
  }
}
