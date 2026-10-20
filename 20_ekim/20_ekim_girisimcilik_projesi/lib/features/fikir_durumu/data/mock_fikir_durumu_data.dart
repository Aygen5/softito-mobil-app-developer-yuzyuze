import '../models/fikir_durumu_model.dart';

const List<FikirDurumuModel> mockOrnekFikirler = [
  // 1. Fikir: Havacılık ve Uzay (İleri aşama, tescil bitti, sözleşme aşamasında)
  FikirDurumuModel(
    id: 'f_1',
    fikirAdi: 'AeroNova Hibrit İtki Sistemleri',
    sektor: 'Havacılık ve Uzay',
    aciklama:
        'Mikro uydular için çevre dostu ve düşük maliyetli hibrit roket itki modülü.',
    basvuruAsamasi: BasvuruAsamasi.onaylandi,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Mehmet Ali Kaya',
      baroSicilNo: 'Ankara Barosu — 34192',
      uzmanlik: 'Fikri Mülkiyet & Savunma Sanayii Sözleşmeleri',
      eposta: 'av.mehmetali@lexyorunge.example.com',
      telefon: '0 (532) 777 12 34',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 150000.0,
      gerceklesenTl: 125000.0,
      taahhutBitisTarihi: '31 Aralık 2027',
      aciklama:
          'Platform tarafından ilk 12 ay süresince Ar-Ge ve personel gelir desteği taahhüt edilmektedir.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama:
            'Yörünge platformu bünyesindeki savunma hukuku uzmanı avukat atandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi (Anonim Şirket)',
        aciklama:
            'Yatırım almaya uygun pay yapısı nedeniyle A.Ş. ana sözleşmesi hazırlandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS ve Ticaret Sicil Tescili',
        aciklama:
            'Ankara Ticaret Sicili Müdürlüğü nezdinde şirket tüzel kişiliği tescil edildi.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi Dairesi Kaydı ve Mükellefiyet',
        aciklama:
            'Vergi kimlik numarası alındı, e-fatura ve e-defter sistemleri açıldı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'TÜRKPATENT Marka ve İtki Patenti Başvurusu',
        aciklama:
            'İtki nozulu faydalı model ve marka tescil başvurusu yapıldı, bülten yayını bekleniyor.',
        durum: HukukiAdimDurumu.devamEdiyor,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Kurucular ve Hissedarlık Sözleşmesi (SHA)',
        aciklama:
            'Ters hak ediş (vesting) ve devir kısıtlamaları (drag/tag along) maddeleri hazırlanıyor.',
        durum: HukukiAdimDurumu.sirada,
      ),
    ],
  ),

  // 2. Fikir: Yapay Zekâ (Sağlık tanısı)
  FikirDurumuModel(
    id: 'f_2',
    fikirAdi: 'NeuroVision Tıbbi Görüntüleme AI',
    sektor: 'Sağlık Teknolojileri',
    aciklama:
        'MR ve BT taramalarında erken evre felç riskini saniyeler içinde analiz eden derin öğrenme modeli.',
    basvuruAsamasi: BasvuruAsamasi.onaylandi,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Zeynep Bilge Tan',
      baroSicilNo: 'İstanbul Barosu — 48210',
      uzmanlik: 'Biyomedikal Regülasyon ve KVKK / Sağlık Verileri',
      eposta: 'av.zeynep@lexyorunge.example.com',
      telefon: '0 (533) 888 23 45',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 200000.0,
      gerceklesenTl: 180000.0,
      taahhutBitisTarihi: '30 Haziran 2027',
      aciklama:
          'Klinik deneme aşamasında hastane entegrasyon masrafları için gelir desteği.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama: 'Sağlık bilişimi ve KVKK uzmanı avukat atandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi (Limited Şirket)',
        aciklama:
            'Çekirdek 2 akademisyen kurucu ortak ile Ltd. Şti. sözleşmesi imzalandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS ve Ticaret Sicil Tescili',
        aciklama: 'İstanbul Ticaret Odası sicil kaydı tamamlandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi Dairesi Kaydı ve Sağlık KVKK Uyumu',
        aciklama:
            'VERBİS kaydı ve anonimleştirilmiş hasta veri işleme izinleri tamamlandı.',
        durum: HukukiAdimDurumu.devamEdiyor,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'TÜRKPATENT Marka Tescili',
        aciklama:
            'NeuroVision markası 9. ve 42. emtia sınıflarında tescile sunuldu.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Hissedarlık ve Üniversite TTO Sözleşmesi',
        aciklama:
            'Akademik buluş payı ve fikri mülkiyet devir protokolü onay bekliyor.',
        durum: HukukiAdimDurumu.sirada,
      ),
    ],
  ),

  // 3. Fikir: Finansal Teknolojiler (Açık Bankacılık)
  FikirDurumuModel(
    id: 'f_3',
    fikirAdi: 'PayFlow Akıllı B2B Tahsilat',
    sektor: 'Finansal Teknolojiler',
    aciklama:
        'KOBİ’ler için açık bankacılık tabanlı çoklu hesap ve otomatik cari mutabakat platformu.',
    basvuruAsamasi: BasvuruAsamasi.onaylandi,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Selçuk Erdem',
      baroSicilNo: 'İstanbul Barosu — 29401',
      uzmanlik: 'Banka ve Finans Hukuku & BDDK/TCMB Lisanslama',
      eposta: 'av.selcuk@lexyorunge.example.com',
      telefon: '0 (535) 999 34 56',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 120000.0,
      gerceklesenTl: 95000.0,
      taahhutBitisTarihi: '31 Ekim 2027',
      aciklama:
          'İlk 500 tüccar katılımına kadar sunucu ve altyapı gelir desteği garantisi.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama: 'TCMB ödeme hizmetleri tecrübeli avukat görevlendirildi.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi (A.Ş. — Asgari Sermaye Uyumlu)',
        aciklama:
            'Fintek mevzuatı uyarınca 5.000.000 ₺ sermayeli A.Ş. esas sözleşmesi hazırlandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS ve Ticaret Sicil Tescili',
        aciklama: 'Ticaret sicil gazetesi ilanı yapıldı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi Kaydı ve TCMB Ön Başvuru Dosyası',
        aciklama:
            'TCMB Ödeme Hizmetleri Dairesi yetki belgesi ön incelemesi sürüyor.',
        durum: HukukiAdimDurumu.devamEdiyor,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'TÜRKPATENT Marka Tescili',
        aciklama: 'Finansal yazılım sınıflarında marka başvurusu yapıldı.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Ortaklık ve B2B Servis Seviyesi (SLA) Sözleşmesi',
        aciklama:
            'Banka entegrasyonu gizlilik ve sorumluluk protokolleri hazırlanıyor.',
        durum: HukukiAdimDurumu.sirada,
      ),
    ],
  ),

  // 4. Fikir: Temiz Enerji (Tohum aşaması)
  FikirDurumuModel(
    id: 'f_4',
    fikirAdi: 'VoltCycle Batarya Geri Kazanım',
    sektor: 'Temiz Enerji',
    aciklama:
        'Lityum-iyon pillerden yeşil kimya yöntemleriyle %98 saflıkta kobalt ve nikel ayrıştırma tesisi.',
    basvuruAsamasi: BasvuruAsamasi.onaylandi,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Deniz Akça',
      baroSicilNo: 'İzmir Barosu — 18320',
      uzmanlik: 'Çevre Mevzuatı ve Sanayi İzinleri',
      eposta: 'av.deniz@lexyorunge.example.com',
      telefon: '0 (536) 123 78 90',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 180000.0,
      gerceklesenTl: 140000.0,
      taahhutBitisTarihi: '31 Mart 2028',
      aciklama:
          'Geri dönüşüm pilot tesisi hammadde tedarik gelir desteği taahhüdü.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama: 'Çevre ve Şehircilik Bakanlığı izinleri uzmanı atandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi (Anonim Şirket)',
        aciklama: 'OSB kiralama şartlarına uygun A.Ş. statüsü belirlendi.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS Ticaret Sicili',
        aciklama: 'İzmir Ticaret Sicili Müdürlüğü tescili yapıldı.',
        durum: HukukiAdimDurumu.devamEdiyor,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi ve ÇED Muafiyet Yazısı',
        aciklama: 'Çevre Etki Değerlendirme (ÇED) başvuru süreci başlatıldı.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'TÜRKPATENT Kimyasal Proses Patenti',
        aciklama: 'Uluslararası PCT patent ön araştırması yapılıyor.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Hissedarlık ve Tehlikeli Atık Tedarik Protokolü',
        aciklama: 'Akü üreticileriyle çerçeve sözleşmeler hazırlanıyor.',
        durum: HukukiAdimDurumu.sirada,
      ),
    ],
  ),

  // 5. Fikir: Tarım Teknolojileri (İncelemede)
  FikirDurumuModel(
    id: 'f_5',
    fikirAdi: 'ToprakAI Otonom Tarla İzleme',
    sektor: 'Tarım Teknolojileri',
    aciklama:
        'Çok spektrumlu uydu ve dron verilerini birleştirerek rekolte kaybını önleyen erken uyarı yazılımı.',
    basvuruAsamasi: BasvuruAsamasi.inceleniyor,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Fatma Güler',
      baroSicilNo: 'Bursa Barosu — 12094',
      uzmanlik: 'Bilişim Hukuku ve Tarımsal Sözleşmeler',
      eposta: 'av.fatma@lexyorunge.example.com',
      telefon: '0 (537) 456 01 23',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 80000.0,
      gerceklesenTl: 0.0,
      taahhutBitisTarihi: '31 Ağustos 2027',
      aciklama:
          'Başvuru onaylandıktan sonra çiftçi kooperatifleriyle pilot dönem gelir desteği aktarılacaktır.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama:
            'Fikir uzman incelemesinde; onay sonrası avukat görevlendirilecek.',
        durum: HukukiAdimDurumu.devamEdiyor,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi',
        aciklama: 'Beklemede.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS Tescili',
        aciklama: 'Beklemede.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi Dairesi Kaydı',
        aciklama: 'Beklemede.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'Marka Tescili',
        aciklama: 'Beklemede.',
        durum: HukukiAdimDurumu.sirada,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Hissedarlık Sözleşmesi',
        aciklama: 'Beklemede.',
        durum: HukukiAdimDurumu.sirada,
      ),
    ],
  ),

  // 6. Fikir: B2B SaaS (Tüm adımları tamamlanmış rol model girişim)
  FikirDurumuModel(
    id: 'f_6',
    fikirAdi: 'LogiOrbit Akıllı Depo Optimizasyonu',
    sektor: 'SaaS & Bulut',
    aciklama:
        'E-ticaret lojistik depolarında rota ve raf yerleşimini yapay zekâ ile %35 hızlandıran bulut sistemi.',
    basvuruAsamasi: BasvuruAsamasi.onaylandi,
    avukat: AtananAvukatModel(
      adSoyad: 'Av. Canan Sezgin',
      baroSicilNo: 'İstanbul Barosu — 39105',
      uzmanlik: 'SaaS Sözleşmeleri & Uluslararası Yatırım Hukuku',
      eposta: 'av.canan@lexyorunge.example.com',
      telefon: '0 (538) 321 65 43',
    ),
    gelirDestegi: GelirDestekModel(
      aylikHedefTl: 250000.0,
      gerceklesenTl: 250000.0,
      taahhutBitisTarihi: '31 Aralık 2026',
      aciklama:
          'Taahhüt edilen ciro hedefine ulaşılmış ve şirket kendi kendine yeten kârlılık aşamasına geçmiştir.',
    ),
    hukukiAdimlar: [
      HukukiSurecAdimi(
        sira: 1,
        baslik: 'Ücretsiz Hukuk Danışmanı Ataması',
        aciklama:
            'SaaS hukuku uzmanı avukat başarıyla atandı ve tüm süreçleri yönetti.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 2,
        baslik: 'Şirket Türü Seçimi (Anonim Şirket)',
        aciklama: 'Yatırımcı opsiyon havuzlu (ESOP) A.Ş. kuruldu.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 3,
        baslik: 'MERSİS ve Ticaret Sicil Tescili',
        aciklama: 'Sicil tescili ve imza sirküleri tamamlandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 4,
        baslik: 'Vergi Dairesi Kaydı ve Teknopark Girişi',
        aciklama: 'Kurumlar vergisi muafiyeti onaylandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 5,
        baslik: 'TÜRKPATENT ve WIPO Uluslararası Marka Tescili',
        aciklama:
            'Madrid Protokolü kapsamında Avrupa ve ABD marka tescilleri alındı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
      HukukiSurecAdimi(
        sira: 6,
        baslik: 'Kurucular ve Yatırımcı Sözleşmeleri',
        aciklama: 'Tohum turu yatırım sözleşmeleri başarıyla imzalandı.',
        durum: HukukiAdimDurumu.tamamlandi,
      ),
    ],
  ),
];
