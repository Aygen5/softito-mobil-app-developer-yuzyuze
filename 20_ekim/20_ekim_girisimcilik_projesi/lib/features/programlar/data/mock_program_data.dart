import '../models/program_model.dart';

const List<ProgramModel> mockProgramlar = [
  // --- 1. HİBE PROGRAMLARI (3 adet) ---
  ProgramModel(
    id: 'pr_h1',
    ad: 'TÜBİTAK 1512 BİGG — Bireysel Genç Girişim',
    kurum: 'TÜBİTAK',
    kategori: ProgramKategori.hibe,
    destekTutari: '900.000 ₺ (Geri Ödemesiz Hibe)',
    uygunlukSartlari: [
      'Üniversite lisans son sınıf, mezun veya lisansüstü öğrenci',
      'Daha önce BİGG desteği almamış olmak',
      'Teknolojik veya yenilikçi iş fikri',
    ],
    sonBasvuruTarihi: '30 Kasım 2026',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'Uygulayıcı Kuruluş seçimi ve fikir sunumu',
      'Mentorluk ve iş planı hazırlama',
      'TÜBİTAK panel değerlendirmesi',
      'Şirketleşme ve hibe aktarımı',
    ],
    aciklama:
        'Yenilikçi teknoloji fikirlerinin şirketleşmesi için devletin en kapsamlı çekirdek sermaye hibesidir.',
  ),
  ProgramModel(
    id: 'pr_h2',
    ad: 'KOSGEB İleri Girişimci Destek Programı',
    kurum: 'KOSGEB',
    kategori: ProgramKategori.hibe,
    destekTutari: '375.000 ₺ - 1.000.000 ₺ Hibe',
    uygunlukSartlari: [
      'İleri girişimci eğitim sertifikası sahibi olmak',
      'İmalat veya yazılım NACE kodunda son 1 yılda kurulmuş şirket',
      'Makine-teçhizat ve yazılım alımları',
    ],
    sonBasvuruTarihi: 'Sürekli Açık',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'KBS e-Devlet girişi',
      'Proje teklif dosyasının yüklenmesi',
      'Kurul sunumu',
      'Harcama faturalandırma ve ödeme talebi',
    ],
    aciklama:
        'Yüksek teknoloji düzeyinde imalat ve yazılım alanında kurulan yeni işletmelere makine ve yazılım hibesi.',
  ),
  ProgramModel(
    id: 'pr_h3',
    ad: 'TÜBİTAK 1507 KOBİ Ar-Ge Başlangıç Destek Programı',
    kurum: 'TÜBİTAK',
    kategori: ProgramKategori.hibe,
    destekTutari: '%75 Hibe Oranı (2.400.000 ₺ Bütçe Üst Sınırı)',
    uygunlukSartlari: [
      'KOBİ ölçeğinde sermaye şirketi olmak',
      'Yeni bir ürün geliştirme veya süreç iyileştirme Ar-Ge projesi',
    ],
    sonBasvuruTarihi: '15 Aralık 2026',
    durum: ProgramDurum.yakinda,
    basvuruAdimlari: [
      'PRODIS sistemi üzerinden proje kaydı',
      'Ar-Ge içeriği ve bütçe planlaması',
      'Hakem değerlendirme ziyareti',
      'Dönemsel raporlama ve hibe iadesi',
    ],
    aciklama:
        'KOBİ’lerin ilk Ar-Ge projelerini teşvik etmek amacıyla personel, alet ve sarf giderlerini hibeyle karşılar.',
  ),

  // --- 2. DEVLET DESTEKLERİ (3 adet) ---
  ProgramModel(
    id: 'pr_d1',
    ad: 'Ticaret Bakanlığı E-Turquality (Bilişimin Yıldızları)',
    kurum: 'T.C. Ticaret Bakanlığı',
    kategori: ProgramKategori.devlet,
    destekTutari: '%70 Oranında, Yıllık 25.000.000 ₺\'ye Varan Teşvik',
    uygunlukSartlari: [
      'Bilişim, telekomünikasyon, yazılım veya oyun ihracatı yapan şirketler',
      'Yurt dışı pazarlama ve bulut bilişim harcamaları',
    ],
    sonBasvuruTarihi: 'Sürekli Açık',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'İhracatçı Birliği ön onayı',
      'Bilişim sektör raporu sunumu',
      'Bakanlık heyet incelemesi',
      'Harcama geri ödemeleri',
    ],
    aciklama:
        'Yazılım ve oyun şirketlerinin yurt dışı fuar, bulut sunucu, patent ve pazarlama giderlerini karşılayan devlet teşviki.',
  ),
  ProgramModel(
    id: 'pr_d2',
    ad: 'Kalkınma Ajansları Bölgesel Girişimcilik Fonu',
    kurum: 'Sanayi ve Teknoloji Bakanlığı',
    kategori: ProgramKategori.devlet,
    destekTutari: '500.000 ₺ Eş Finansman Desteği',
    uygunlukSartlari: [
      'Bölgesel kalkınma öncelikli sektörlerde faaliyet göstermek',
      'Yerel istihdam taahhüdü',
    ],
    sonBasvuruTarihi: '20 Ocak 2027',
    durum: ProgramDurum.yakinda,
    basvuruAdimlari: [
      'KAYS sistemi üzerinden başvuru',
      'Bölgesel uygunluk puanlaması',
      'Sözleşme imza süreci',
    ],
    aciklama:
        'Yerel kalkınmayı hızlandıran tarım, turizm ve teknoloji projelerine faizsiz geri ödemeli ve hibeli kaynak.',
  ),
  ProgramModel(
    id: 'pr_d3',
    ad: 'Teknopark Ar-Ge ve Vergi Muafiyet Teşvikleri',
    kurum: 'Sanayi ve Teknoloji Bakanlığı & TGB',
    kategori: ProgramKategori.devlet,
    destekTutari: '%100 Kurumlar Vergisi ve Gelir Stopaj Muafiyeti',
    uygunlukSartlari: [
      'Teknoloji Geliştirme Bölgesinde (TGB) ofis kiralamak',
      'Ar-Ge ve yazılım projesi onaylanmış olmak',
    ],
    sonBasvuruTarihi: 'Dönemsel Kabul',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'İlgili teknopark portalı başvurusu',
      'Hakem heyeti önünde proje sunumu',
      'Ofis tahsisi ve muafiyet başlangıcı',
    ],
    aciklama:
        'Ar-Ge personelinin maaş stopajı, SGK primi ve şirket kurumlar vergisi istisnasından faydalanma imkânı.',
  ),

  // --- 3. YURTDIŞI DESTEKLERİ (3 adet) ---
  ProgramModel(
    id: 'pr_y1',
    ad: 'Horizon Europe (Ufuk Avrupa) EIC Accelerator',
    kurum: 'Avrupa İnovasyon Konseyi (EIC)',
    kategori: ProgramKategori.yurtdisi,
    destekTutari: '2.5 Milyon € Hibe + 15 Milyon € Yatırım',
    uygunlukSartlari: [
      'Çığır açıcı derin teknoloji (Deep Tech) çözümleri',
      'TRL 6 seviyesine ulaşmış prototip/ürün',
      'Küresel ölçeklenme potansiyeli',
    ],
    sonBasvuruTarihi: '18 Şubat 2027',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      '3 dakikalık video + 10 sayfalık pitch deck',
      'Tam iş planı başvurusu',
      'Brüksel jüri mülakatı',
    ],
    aciklama:
        'Avrupa Birliği’nin en prestijli, pazar yaratan radikal teknoloji şirketlerine yönelik karma finansman desteği.',
  ),
  ProgramModel(
    id: 'pr_y2',
    ad: 'Eureka Eurostars 3 KOBİ Ortak Ar-Ge Programı',
    kurum: 'Eureka Network & TÜBİTAK',
    kategori: ProgramKategori.yurtdisi,
    destekTutari: '500.000 € Proje Başına Destek',
    uygunlukSartlari: [
      'En az 2 farklı Eureka ülkesinden partner şirket',
      'Ticarileşme süresi 2 yılı aşmayan pazar odaklı Ar-Ge',
    ],
    sonBasvuruTarihi: '12 Mart 2027',
    durum: ProgramDurum.yakinda,
    basvuruAdimlari: [
      'Uluslararası konsorsiyum oluşturma',
      'Eureka portalına ortak form yükleme',
      'Ulusal fonlama kuruluşu (TÜBİTAK) onayı',
    ],
    aciklama:
        'Avrupalı ortaklarla birlikte yenilikçi ürün geliştiren Ar-Ge yoğun KOBİ’lere doğrudan fon.',
  ),
  ProgramModel(
    id: 'pr_y3',
    ad: 'Global ScaleUp London İhracat Hızlandırma',
    kurum: 'London & Partners',
    kategori: ProgramKategori.yurtdisi,
    destekTutari: 'Ofis Tahsisi + 100.000 £ Değerinde Danışmanlık',
    uygunlukSartlari: [
      'Birleşik Krallık pazarına açılmak isteyen B2B girişimler',
      'Yıllık en az 100.000\$ ARR cirosu',
    ],
    sonBasvuruTarihi: '31 Ekim 2026',
    durum: ProgramDurum.kapandi,
    basvuruAdimlari: [
      'Online başvuru formu',
      'Kısa liste video mülakatı',
      'Londra kohortuna katılım',
    ],
    aciklama:
        'İngiltere ve Avrupa pazarına ürün ihraç etmek isteyen yazılım firmalarına yerel ağ ve hukuki destek.',
  ),

  // --- 4. ÖZEL SEKTÖR DESTEKLERİ (3 adet) ---
  ProgramModel(
    id: 'pr_o1',
    ad: 'Google for Startups Cloud Girişim Kredisi',
    kurum: 'Google Cloud Platform',
    kategori: ProgramKategori.ozelSektor,
    destekTutari: '100.000\$ - 200.000\$ Değerinde Cloud Kredisi',
    uygunlukSartlari: [
      'Seri A veya öncesi aşamada teknoloji girişimi olmak',
      'Girişim sermayesi veya yetkili hızlandırıcı referansı',
    ],
    sonBasvuruTarihi: 'Sürekli Açık',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'Kurumsal e-posta ile başvuru',
      'Girişimci profil doğrulaması',
      'Kredinin GCP hesabına tanımlanması',
    ],
    aciklama:
        'Yapay zekâ modelleri ve yüksek sunucu kaynakları için ücretsiz 2 yıllık Google Cloud altyapısı.',
  ),
  ProgramModel(
    id: 'pr_o2',
    ad: 'Microsoft for Startups Founders Hub',
    kurum: 'Microsoft',
    kategori: ProgramKategori.ozelSektor,
    destekTutari: '150.000\$ Azure + OpenAI API Kredisi',
    uygunlukSartlari: [
      'Herhangi bir aşamadaki yazılım girişimi (şirketleşme şartı yok)',
      'LinkedIn veya GitHub profili ile başvuru',
    ],
    sonBasvuruTarihi: 'Sürekli Açık',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'Founders Hub üzerinden kayıt',
      'Gereksinim belirleme ve kademeli kredi aktivasyonu',
    ],
    aciklama:
        'Azure OpenAI (GPT-4o), GitHub Enterprise ve Microsoft 365 araçlarına anında ücretsiz erişim.',
  ),
  ProgramModel(
    id: 'pr_o3',
    ad: 'AWS Activate Portfolio Paketi',
    kurum: 'Amazon Web Services',
    kategori: ProgramKategori.ozelSektor,
    destekTutari: '100.000\$ AWS Promotional Credit',
    uygunlukSartlari: [
      'Yörünge veya partner kuluçka merkezi üyesi olmak',
      'Daha önce aynı seviyede kredi almamış olmak',
    ],
    sonBasvuruTarihi: 'Sürekli Açık',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'Yörünge Organizasyon Kodu ile başvuru',
      'AWS hesabı eşleştirme',
      'Kredi onayı (3 iş günü)',
    ],
    aciklama:
        'AWS EC2, S3, SageMaker ve mimari teknik destek paketini içeren başlangıç kredisi.',
  ),

  // --- 5. KULUÇKA VE HIZLANDIRMA MERKEZLERİ (3 adet) ---
  ProgramModel(
    id: 'pr_k1',
    ad: 'İTÜ Çekirdek Erken Aşama Kuluçka & Big Bang',
    kurum: 'İTÜ ARI Teknokent',
    kategori: ProgramKategori.kulucka,
    destekTutari: 'Laboratuvar + Mentorluk + Big Bang Sahnesinde Ödüller',
    uygunlukSartlari: [
      'Fikir veya MVP aşamasında teknoloji girişimi',
      'Tam zamanlı çalışmaya istekli ekip',
    ],
    sonBasvuruTarihi: '15 Aralık 2026',
    durum: ProgramDurum.acik,
    basvuruAdimlari: [
      'Online iş planı başvurusu',
      'Ön değerlendirme sunumu (1 dk video)',
      'Ön kuluçka eğitim kampı',
      'Big Bang sahne seçmeleri',
    ],
    aciklama:
        'Türkiye\'nin ve dünyanın sayılı kuluçka merkezlerinden biri; yüzlerce mentor ve yatırımcı ağı.',
  ),
  ProgramModel(
    id: 'pr_k2',
    ad: 'Bilkent CYBERPARK CAP Hızlandırma Programı',
    kurum: 'Bilkent CYBERPARK',
    kategori: ProgramKategori.kulucka,
    destekTutari: 'Yurt Dışı Pazara Giriş Desteği ve B2B Görüşmeler',
    uygunlukSartlari: [
      'Ürünü hazır, satış yapmış veya ticarileşme aşamasındaki firmalar',
    ],
    sonBasvuruTarihi: '10 Ocak 2027',
    durum: ProgramDurum.yakinda,
    basvuruAdimlari: [
      'Şirket finansal ve ürün analizi',
      'Yurt dışı pazar eşleştirme kampı',
      'Hedef ülkede B2B görüşme heyeti',
    ],
    aciklama:
        'Yazılım firmalarını ABD ve Avrupa pazarlarındaki potansiyel müşterilerle yüz yüze buluşturan hızlandırıcı.',
  ),
  ProgramModel(
    id: 'pr_k3',
    ad: 'ODTÜ TEKNOKENT Yeni Fikirler Yeni İşler (YFYİ)',
    kurum: 'ODTÜ TEKNOKENT',
    kategori: ProgramKategori.kulucka,
    destekTutari: 'Nakit Destek + Ücretsiz Ofis + Prototipleme Atölyesi',
    uygunlukSartlari: [
      'Teknoloji tabanlı iş fikirleri',
      'Mühendislik veya tasarım tabanlı çekirdek kadro',
    ],
    sonBasvuruTarihi: '05 Kasım 2026',
    durum: ProgramDurum.kapandi,
    basvuruAdimlari: [
      'Fikir sunumu',
      'Doğrulama bootcamp aşaması',
      'Final Demo Day',
    ],
    aciklama:
        'Türkiye\'nin ilk hızlandırma yarışması; donanım ve derin teknoloji girişimlerine üretim atölyesi imkânı.',
  ),
];
