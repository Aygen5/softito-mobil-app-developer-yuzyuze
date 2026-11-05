import 'dart:io';

import 'package:flutter/material.dart';

import '../models/bildirim_modeli.dart';
import '../services/fcm_bildirim_servisi.dart';
import '../services/storage_service.dart';
import '../widgets/bildirim_listesi_kartı.dart';
import '../widgets/gorsel_yukleme.karti.dart';

/// ============================================================================
/// FIREBASE STORAGE & FCM ANA YÖNETİM EKRANI (MAIN SCREEN)
/// ============================================================================
/// Bu ekran; hem Firebase Cloud Messaging (FCM) anlık bildirim altyapısını hem de
/// Firebase Cloud Storage medya yükleme süreçlerini tek bir çatı altında birleştiren,
/// State yönetimini ve servis koordinasyonunu sağlayan ana ekran widget'ıdır.
///
/// 💡 Mimari Yaklaşım:
/// Ekran 'Stateful' olarak kurgulanmıştır. Servislerden (Storage & FCM) gelen
/// dinamik veriler (yükleme yüzdesi, dosya URL'i, gelen bildirimler, token)
/// ekranın State'inde tutulur ve alt widget'lara (GorselYuklemeKarti, BildirimListesiKarti)
/// parametre ve callback fonksiyonları olarak aktarılır.
class StorageVeFcmEkrani extends StatefulWidget {
  const StorageVeFcmEkrani({super.key});

  @override
  State<StorageVeFcmEkrani> createState() => _StorageVeFcmEkraniState();
}

class _StorageVeFcmEkraniState extends State<StorageVeFcmEkrani> {
  // ---------------------------------------------------------------------------
  // 1. SERVİS NESNELERİ (SERVICE INSTANCES)
  // ---------------------------------------------------------------------------
  // Firebase Cloud Storage dosya seçme ve yükleme işlemlerini yöneten servis
  final StorageServisi _storageServisi = StorageServisi();

  // Firebase Cloud Messaging bildirim izinleri, dinleyicisi ve token işlemlerini yöneten servis
  final FcmBildirimServisi _fcmBildirimServisi = FcmBildirimServisi();

  // ---------------------------------------------------------------------------
  // 2. STORAGE İLE İLGİLİ STATE DEĞİŞKENLERİ
  // ---------------------------------------------------------------------------
  // Galeriden veya kameradan seçilen yerel görsel dosyası (seçilmediyse null)
  File? _secilenDosya;

  // Buluta başarıyla yüklendikten sonra dönen HTTPS indirme bağlantısı (Download URL)
  String? _yuklenenUrl;

  // Firebase Storage yükleme ilerleme oranı (0.0 ile 1.0 arasında değer alır)
  double _yuklemeOrani = 0.0;

  // Dosya yükleme işleminin devam edip etmediğini belirten durum bayrağı
  bool _yukleniyorMu = false;

  // ---------------------------------------------------------------------------
  // 3. FCM BİLDİRİM İLE İLGİLİ STATE DEĞİŞKENLERİ
  // ---------------------------------------------------------------------------
  // Cihazın Firebase'e kayıtlı benzersiz FCM Token'ı (test bildirimleri için kullanılır)
  String? _fcmToken;

  // Kullanıcının 'tum_sinif' genel yayın konusuna (topic) abone olup olmadığı
  bool _konuyaAboneMi = false;

  // Uygulama çalışırken FCM üzerinden gelen anlık bildirimlerin listesi
  final List<BildirimModeli> _bildirimler = [];

  // ===========================================================================
  // YAŞAM DÖNGÜSÜ (LIFECYCLE) METOTLARI
  // ===========================================================================
  @override
  void initState() {
    super.initState();
    // Ekran ilk açıldığında FCM servisini ve bildirim dinleyicisini başlatıyoruz
    _fcmKur();
  }

  // ===========================================================================
  // FCM KURULUM VE BİLDİRİM YÖNETİM METOTLARI
  // ===========================================================================
  /// FCM izinlerini talep eder, ön plan mesaj dinleyicisini bağlar ve cihaz token'ını alır.
  Future<void> _fcmKur() async {
    // Ön planda (Foreground) yeni bir FCM mesajı geldiğinde tetiklenecek callback
    _fcmBildirimServisi.onMesajGeldi = (message) {
      setState(() {
        // Gelen bildirimi listenin en başına (index 0) ekliyoruz
        _bildirimler.insert(
          0,
          BildirimModeli(
            id: message.messageId ?? DateTime.now().toIso8601String(),
            baslik: message.notification?.title ?? "Yeni Bildirim",
            icerik: message.notification?.body ?? "",
            tarih: DateTime.now(),
            okunduMu: false,
          ),
        );
      });
    };

    // Bildirim izinlerini ve yerel bildirim motorunu başlat
    await _fcmBildirimServisi.baslat();

    // Firebase'den bu cihaza özel oluşturulan FCM Token'ı al ve State'e yaz
    final token = await _fcmBildirimServisi.tokenAl();
    setState(() => _fcmToken = token);
  }

  /// Kullanıcının konuya (Topic) abone olma veya abonelikten çıkma durumunu yönetir.
  Future<void> _abonelikDegistir(bool deger) async {
    setState(() => _konuyaAboneMi = deger);
    if (deger) {
      // 'tum_sinif' yayınına abone ol
      await _fcmBildirimServisi.konudanAboneOl('tum_sinif');
    } else {
      // 'tum_sinif' yayınından çık
      await _fcmBildirimServisi.konudanAyril('tum_sinif');
    }
  }

  // ===========================================================================
  // STORAGE (MEDYA SEÇME VE BULUTA YÜKLEME) METOTLARI
  // ===========================================================================
  /// ImagePicker ile cihaz kamerasından veya galerisinden fotoğraf seçtirir.
  Future<void> _gorselSec({required bool kameradan}) async {
    final dosya = await _storageServisi.gorselSec(kameradan: kameradan);
    if (dosya != null) {
      setState(() {
        _secilenDosya = dosya;
        _yuklenenUrl = null; // Yeni dosya seçildiği için eski URL sıfırlanır
        _yuklemeOrani = 0.0;
      });
    }
  }

  /// Seçilen yerel dosyayı Firebase Storage havuzuna asenkron olarak yükler.
  Future<void> _bulutaYukle() async {
    // Seçilmiş bir dosya yoksa işlem yapma
    if (_secilenDosya == null) return;

    setState(() {
      _yukleniyorMu = true;
    });

    try {
      // Benzersiz bir dosya ismi oluşturuluyor (Örn: profil_1699185000000.jpg)
      final dosyaAdi = 'profil_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Storage servisinde yükleme görevi (UploadTask) başlatılıyor
      final task = _storageServisi.yuklemeBaslat(
        dosya: _secilenDosya!,
        dosyaAdi: dosyaAdi,
      );

      // Yükleme akışını (Stream) dinleyerek anlık aktarılan byte oranını güncelliyoruz
      task.snapshotEvents.listen((snapshot) {
        setState(() {
          _yuklemeOrani = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Yüklemenin tamamen bitmesini bekliyoruz
      final tamamlanan = await task;

      // Buluta yüklenen dosyanın indirme bağlantısını (Download URL) alıyoruz
      final url = await _storageServisi.urlGetir(tamamlanan.ref);

      // Yükleme başarıyla bittiğinde State güncellenir
      setState(() {
        _yuklenenUrl = url;
        _yuklemeOrani = 0.0;
        _secilenDosya = null;
        _yukleniyorMu = false;
      });

      // Kullanıcıya işlemin başarılı olduğunu bildiren yeşil SnackBar göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Görsel buluta başarıyla yüklendi"),
            backgroundColor: Color.fromARGB(255, 0, 165, 94),
          ),
        );
      }
    } catch (e) {
      // Hata durumunda yükleniyor durumunu kapat
      setState(() => _yukleniyorMu = false);

      // Kullanıcıya hata mesajı içeren kırmızı SnackBar göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yükleme hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ===========================================================================
  // ARAYÜZ (UI) OLUŞTURMA METODU
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF6EB),
      // Üst Başlık Çubuğu
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SoftitoStorage ve Fcm Çalışması',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              "Bulut Yükleme ve Push Bildirimleri",
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xffDF9F5E),
        foregroundColor: Colors.white,
      ),
      // Kaydırılabilir Ana Gövde
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 1. GÖRSEL YÜKLEME KARTI (STORAGE MODÜLÜ)
            GorselYuklemeKarti(
              secilenDosya: _secilenDosya,
              yuklenenUrl: _yuklenenUrl,
              yuklemeOrani: _yuklemeOrani,
              yukleniyorMu: _yukleniyorMu,
              onGaleridenSec: () => _gorselSec(kameradan: false),
              onKameradanCek: () => _gorselSec(kameradan: true),
              onBulutaYukle: _bulutaYukle,
            ),
            const SizedBox(height: 16),

            /// 2. FCM BİLDİRİM LİSTESİ VE TOKEN KARTI (FCM MODÜLÜ)
            BildirimListesiKarti(
              bildirimler: _bildirimler,
              token: _fcmToken,
              konuyaAboneMi: _konuyaAboneMi,
              onAboneDegisti: _abonelikDegistir,
            ),
          ],
        ),
      ),
    );
  }
}
