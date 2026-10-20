import '../models/topluluk_model.dart';

final List<ToplulukGonderiModel> mockToplulukGonderileri = [
  ToplulukGonderiModel(
    id: 'post_1',
    yazar: 'Baran Çelik',
    girisimAdi: 'AeroPulse Teknoloji',
    metin:
        'Yörünge ekibinin atadığı avukatımız sayesinde bugün Anonim Şirket kuruluşumuzu ve MERSİS tescilimizi sıfır masrafla tamamladık! Girişimcilik yolculuğumuz resmen başladı 🚀',
    tarih: DateTime.now().subtract(const Duration(minutes: 45)),
    begeniSayisi: 28,
    begenildi: true,
    yanitlar: [
      ToplulukYanitModel(
        id: 'rep_1_1',
        yazar: 'Ece Yılmaz',
        unvan: 'BioSensing Kurucusu',
        metin:
            'Tebrikler Baran! MERSİS süreci kaç gün sürdü acaba? Biz de noter aşamasındayız.',
        tarih: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ToplulukYanitModel(
        id: 'rep_1_2',
        yazar: 'Baran Çelik',
        unvan: 'AeroPulse',
        metin:
            'Avukatımız tüm evrakları hazırladığı için sicil müdürlüğünde sadece 1 iş gününde onaylandı Ece.',
        tarih: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ],
  ),
  ToplulukGonderiModel(
    id: 'post_2',
    yazar: 'Selin Aktaş',
    girisimAdi: 'AgriSense IoT',
    metin:
        'TÜBİTAK 1512 BİGG 2. Aşama panel sunumumuzu az önce tamamladık. Panelistler özellikle ticarileşme ve pilot müşteri geri bildirimlerini çok olumlu karşıladı.',
    tarih: DateTime.now().subtract(const Duration(hours: 2)),
    begeniSayisi: 42,
    begenildi: false,
    yanitlar: [
      ToplulukYanitModel(
        id: 'rep_2_1',
        yazar: 'Kemal Sunal',
        unvan: 'GreenVolt',
        metin: 'Harika haber Selin! Sonuçlar ne zaman açıklanıyor?',
        tarih: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  ToplulukGonderiModel(
    id: 'post_3',
    yazar: 'Tolga Karahan',
    girisimAdi: 'CloudShield',
    metin:
        'İlk B2B SaaS ücretli müşterimizi bugün onboard ettik! Aylık 1.200\$ MRR ile gelir destek taahhüdümüzün ilk çeyrek hedefine ulaştık. Destek olan tüm mentorlarımıza teşekkürler.',
    tarih: DateTime.now().subtract(const Duration(hours: 4)),
    begeniSayisi: 65,
    begenildi: true,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_4',
    yazar: 'Damla Ersoy',
    girisimAdi: 'NeuroLearn',
    metin:
        'Yapay zekâ tabanlı disleksi tarama uygulamamızın MVP testlerini 120 öğrenciyle tamamladık. Doğruluk oranı %91 çıktı. Şimdi klinik onay sürecine geçiyoruz.',
    tarih: DateTime.now().subtract(const Duration(hours: 6)),
    begeniSayisi: 39,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_5',
    yazar: 'Onur Varol',
    girisimAdi: 'SimuFlight',
    metin:
        'Savunma sanayii için geliştirdiğimiz İHA uçuş simülatörünün ilk donanım entegrasyonu tamamlandı. Hafta sonu Teknofest demo alanında canlı göstereceğiz.',
    tarih: DateTime.now().subtract(const Duration(hours: 9)),
    begeniSayisi: 51,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_6',
    yazar: 'Melis Taner',
    girisimAdi: 'EcoPack',
    metin:
        'Biyobozunur ambalaj prototipimiz için Türk Patent Enstitüsü’ne faydalı model başvurumuzu yaptık. Yörünge fikri mülkiyet vekilimiz sayesinde süreç kusursuz aktı.',
    tarih: DateTime.now().subtract(const Duration(hours: 12)),
    begeniSayisi: 33,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_7',
    yazar: 'Emirhan Kılıç',
    girisimAdi: 'FinRoute',
    metin:
        'Açık bankacılık API entegrasyonunda BDDK regülasyon uyumu için mentor Mert Aksoy ile yaptığımız 1 saatlik görüşme bize en az 3 ay zaman kazandırdı. Platform müthiş!',
    tarih: DateTime.now().subtract(const Duration(hours: 16)),
    begeniSayisi: 47,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_8',
    yazar: 'Gizem Korkmaz',
    girisimAdi: 'RoboLogist',
    metin:
        'Otonom depo robotumuzun batarya ömrünü %25 artıran yeni güç yönetim kartımızın testleri bitti. Tohum turu öncesi değerlememizi güncelliyoruz.',
    tarih: DateTime.now().subtract(const Duration(days: 1)),
    begeniSayisi: 29,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_9',
    yazar: 'Serkan Öztürk',
    girisimAdi: 'DataPrism',
    metin:
        'Yurt dışı açılımı için İngiltere’de şirket kurma konusunda tecrübesi olan bir girişimci arkadaş var mı? Çifte vergilendirme anlaşmasını konuşmak isterim.',
    tarih: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    begeniSayisi: 19,
    begenildi: false,
    yanitlar: [
      ToplulukYanitModel(
        id: 'rep_9_1',
        yazar: 'Ceren Aydın',
        unvan: 'ScaleEurope',
        metin:
            'Biz 6 ay önce kurduk Serkan, DM kapalı olduğu için topluluktan yazıyorum; Ticaret Bakanlığı teşvik masası çok yardımcı oluyor.',
        tarih: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ],
  ),
  ToplulukGonderiModel(
    id: 'post_10',
    yazar: 'Burcu Deniz',
    girisimAdi: 'HealthAI Lab',
    metin:
        'Radyoloji görüntülerinde akciğer nodülü tespiti yapan yapay zekâ modelimiz için CE medikal cihaz sertifikasyonu başvurumuzu resmileştirdik.',
    tarih: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    begeniSayisi: 58,
    begenildi: true,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_11',
    yazar: 'Kaan Demir',
    girisimAdi: 'VoltStation',
    metin:
        'Elektrikli araç şarj istasyonu optimizasyon yazılımımız ilk 50 şarj noktasında devreye alındı. Günlük tüketimde %14 şebeke tasarrufu sağlandı.',
    tarih: DateTime.now().subtract(const Duration(days: 2)),
    begeniSayisi: 37,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_12',
    yazar: 'İpek Şahin',
    girisimAdi: 'GameCraft Studio',
    metin:
        'Steam ve App Store için geliştirdiğimiz uzay strateji oyunumuzun kapalı beta testlerine 500 girişimci davet ediyoruz. Link profilimizde!',
    tarih: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    begeniSayisi: 74,
    begenildi: false,
    yanitlar: [],
  ),
  ToplulukGonderiModel(
    id: 'post_13',
    yazar: 'Ahmet Faruk Yüce',
    girisimAdi: 'BioEnzim Tech',
    metin:
        'Endüstriyel atıklardan çevre dostu enzim üretim projemiz Sanayi Bakanlığı Teknogirişim sermaye desteği almaya hak kazandı!',
    tarih: DateTime.now().subtract(const Duration(days: 3)),
    begeniSayisi: 83,
    begenildi: true,
    yanitlar: [],
  ),
];
