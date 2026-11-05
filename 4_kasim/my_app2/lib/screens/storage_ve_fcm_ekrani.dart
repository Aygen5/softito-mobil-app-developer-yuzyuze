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
class StorageVeFcmEkrani extends StatefulWidget {
  const StorageVeFcmEkrani({super.key});

  @override
  State<StorageVeFcmEkrani> createState() => _StorageVeFcmEkraniState();
}

class _StorageVeFcmEkraniState extends State<StorageVeFcmEkrani> {
  // ---------------------------------------------------------------------------
  // 1. SERVİS NESNELERİ (SERVICE INSTANCES)
  // ---------------------------------------------------------------------------
  final StorageServisi _storageServisi = StorageServisi();
  final FcmBildirimServisi _fcmBildirimServisi = FcmBildirimServisi();

  // ---------------------------------------------------------------------------
  // 2. STORAGE İLE İLGİLİ STATE DEĞİŞKENLERİ
  // ---------------------------------------------------------------------------
  File? _secilenDosya;
  String? _yuklenenUrl;
  double _yuklemeOrani = 0.0;
  bool _yukleniyorMu = false;

  // ---------------------------------------------------------------------------
  // 3. FCM BİLDİRİM İLE İLGİLİ STATE DEĞİŞKENLERİ
  // ---------------------------------------------------------------------------
  String? _fcmToken;
  bool _konuyaAboneMi = false;
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
    // Ön planda (Foreground) veya arka plandan tıklanınca yeni bir FCM mesajı geldiğinde tetiklenecek callback
    _fcmBildirimServisi.onMesajGeldi = (message) {
      final baslik = message.notification?.title ??
          message.data['title'] ??
          "Yeni Bildirim";
      final icerik = message.notification?.body ??
          message.data['body'] ??
          message.data['message'] ??
          "";

      setState(() {
        // Gelen bildirimi listenin en başına (index 0) ekliyoruz
        _bildirimler.insert(
          0,
          BildirimModeli(
            id: message.messageId ?? DateTime.now().toIso8601String(),
            baslik: baslik,
            icerik: icerik,
            tarih: DateTime.now(),
            okunduMu: false,
          ),
        );
      });
    };

    // Bildirime tıklandığında tetiklenecek bildirim yanıt callback'i
    _fcmBildirimServisi.onBildirimeTiklandi = (payload) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bildirime tıklandı! ($payload)'),
            backgroundColor: const Color(0xFF0284C7),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    };

    // Bildirim izinlerini ve bildirim kanalını başlat
    await _fcmBildirimServisi.baslat();

    // Firebase'den bu cihaza özel oluşturulan FCM Token'ı al ve State'e yaz
    final token = await _fcmBildirimServisi.tokenAl();
    if (mounted) {
      setState(() => _fcmToken = token);
    }
  }

  /// Cihazda anlık test bildirimi tetikleme metodu
  Future<void> _testBildirimiTetikle() async {
    const testBaslik = "Softito Test Bildirimi 🚀";
    const testIcerik = "Bildirim mekanizması sorunsuz ve aktif olarak çalışıyor!";

    // Heads-up yerel bildirimi gönder
    await _fcmBildirimServisi.testBildirimiGoster(
      baslik: testBaslik,
      icerik: testIcerik,
    );

    // Uygulama içi bildirim listesine ekle
    setState(() {
      _bildirimler.insert(
        0,
        BildirimModeli(
          id: 'test_${DateTime.now().millisecondsSinceEpoch}',
          baslik: testBaslik,
          icerik: testIcerik,
          tarih: DateTime.now(),
          okunduMu: false,
        ),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Test bildirimi oluşturuldu! Bildirim panelinizi kontrol edin."),
          backgroundColor: Color(0xFF006C4A),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
    if (_secilenDosya == null) return;

    setState(() {
      _yukleniyorMu = true;
    });

    try {
      final dosyaAdi = 'profil_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final task = _storageServisi.yuklemeBaslat(
        dosya: _secilenDosya!,
        dosyaAdi: dosyaAdi,
      );

      task.snapshotEvents.listen((snapshot) {
        setState(() {
          _yuklemeOrani = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      final tamamlanan = await task;
      final url = await _storageServisi.urlGetir(tamamlanan.ref);

      setState(() {
        _yuklenenUrl = url;
        _yuklemeOrani = 0.0;
        _secilenDosya = null;
        _yukleniyorMu = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Görsel buluta başarıyla yüklendi"),
            backgroundColor: Color.fromARGB(255, 0, 165, 94),
          ),
        );
      }
    } catch (e) {
      setState(() => _yukleniyorMu = false);

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
              onTestBildirimiGonder: _testBildirimiTetikle,
            ),
          ],
        ),
      ),
    );
  }
}
