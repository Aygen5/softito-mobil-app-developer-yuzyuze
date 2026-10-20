---
name: yorunge-feature-scaffold
description: Yörünge girişimcilik uygulamasında (Flutter) feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, mock veri katmanını, tema uyumlu UI ayrımını, alt bar sekme kaydını ve birim test iskeletini standartlara uygun üretir. Mentor, yatırımcı, programlar, topluluk, analiz gibi yeni ekran veya modül açılırken kullanılır.
---

# Yörünge Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken `project.md` içindeki Clean UI, reaktif State, tema ve mock veri kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar
1. **Asla tek dosyada toplama:**
   UI (`view/`), State Controller (`controller/`), Model (`models/`), mock veri (`data/`) ve alt bileşenler (`widget/`) ayrı dosyalarda açılmalıdır.

2. **State Yönetimi:**
   Hafif, yerel ve reaktif durumlar için `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
   Devasa `StatefulWidget`'lar ve sayfa genelinde ağır `setState` çağrıları ile mimariyi karmaşıklaştırmaktan kesinlikle kaçınılmalıdır. `provider`, `riverpod`, `bloc`, `getx` gibi paketler yasaktır.

3. **Const Zorunluluğu:**
   Statik olan tüm widget'larda `const` ifadesi zorunludur.

4. **Tema Zorunluluğu:**
   Widget içinde `Color(0xFF...)` ve sabit `TextStyle` yazılmaz. Renkler `context.spaceColors`, yazı stilleri `Theme.of(context).textTheme` üzerinden alınır.

5. **Metot Boyutu Sınırı:**
   40 satırı geçen `build` metotları alt özel widget sınıflarına ayrıştırılmalıdır.

6. **Mock Veri:**
   Gerçek ağ isteği yoktur. Veri `data/mock_<feature>_data.dart` içinden okunur. Kişi ve kurum adları uydurma, iletişim bilgileri yer tutucudur (`example.com`).

7. **Dosya Adlandırma:**
   Ana ekran dosyaları projenin istediği adı taşır: `mentor.dart`, `yatirimci.dart`, `programlar.dart`, `topluluk.dart`. Diğer dosyalar `snake_case` ve `<feature>_<rol>.dart` biçiminde olur.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adını (örnek: `mentor`) `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controller/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    data/
        mock_<feature_name>_data.dart
    view/
        <feature_name>.dart
    widget/
        <feature_name>_card.dart
        <feature_name>_filter_bar.dart
test/features/<feature_name>/
    <feature_name>_controller_test.dart
```

---

### Adım 2: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` (`const` constructor) olarak tanımla:

```dart
enum EslesmeDurumu { yok, beklemede, eslesti }

class Mentor {
  final String id;
  final String ad;
  final String unvan;
  final String sektor;
  final List<String> uzmanliklar;
  final int deneyimYili;
  final double puan;
  final EslesmeDurumu durum;

  const Mentor({
    required this.id,
    required this.ad,
    required this.unvan,
    required this.sektor,
    required this.uzmanliklar,
    required this.deneyimYili,
    required this.puan,
    this.durum = EslesmeDurumu.yok,
  });

  Mentor copyWith({
    String? id,
    String? ad,
    String? unvan,
    String? sektor,
    List<String>? uzmanliklar,
    int? deneyimYili,
    double? puan,
    EslesmeDurumu? durum,
  }) {
    return Mentor(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      unvan: unvan ?? this.unvan,
      sektor: sektor ?? this.sektor,
      uzmanliklar: uzmanliklar ?? this.uzmanliklar,
      deneyimYili: deneyimYili ?? this.deneyimYili,
      puan: puan ?? this.puan,
      durum: durum ?? this.durum,
    );
  }

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'] as String? ?? '',
      ad: json['ad'] as String? ?? '',
      unvan: json['unvan'] as String? ?? '',
      sektor: json['sektor'] as String? ?? '',
      uzmanliklar: (json['uzmanliklar'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deneyimYili: (json['deneyimYili'] as num?)?.toInt() ?? 0,
      puan: (json['puan'] as num?)?.toDouble() ?? 0,
      durum: EslesmeDurumu.values.firstWhere(
        (e) => e.name == json['durum'],
        orElse: () => EslesmeDurumu.yok,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'unvan': unvan,
      'sektor': sektor,
      'uzmanliklar': uzmanliklar,
      'deneyimYili': deneyimYili,
      'puan': puan,
      'durum': durum.name,
    };
  }
}
```

---

### Adım 3: Mock Veri Dosyasını Oluşturma
`data/mock_<feature_name>_data.dart` içinde `const` liste olarak örnek veriyi tanımla:

```dart
import '../models/mentor_model.dart';

const List<Mentor> mockMentorlar = [
  Mentor(
    id: 'm1',
    ad: 'Elif Arslanoğlu',
    unvan: 'Seri Girişimci, Yapay Zekâ',
    sektor: 'Yapay Zekâ',
    uzmanliklar: ['Ürün Stratejisi', 'Yatırım Hazırlığı'],
    deneyimYili: 14,
    puan: 4.9,
  ),
  Mentor(
    id: 'm2',
    ad: 'Kerem Yaltırak',
    unvan: 'Uzay ve Havacılık Teknolojileri Danışmanı',
    sektor: 'Havacılık ve Uzay',
    uzmanliklar: ['Ar-Ge Yönetimi', 'Hibe Başvuruları'],
    deneyimYili: 20,
    puan: 4.8,
  ),
  // En az 8 mentor eklenir.
];
```

---

### Adım 4: Controller Dosyasını Yazma
`controller/<feature_name>_controller.dart` içinde mantığı `ValueNotifier` tanımları ve `dispose` metodu ile oluştur. Controller saf Dart'tır; `BuildContext` ve widget bilmez:

```dart
import 'package:flutter/foundation.dart';

import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';

class MentorController {
  final ValueNotifier<List<Mentor>> tumMentorlar =
      ValueNotifier<List<Mentor>>(mockMentorlar);
  final ValueNotifier<String?> seciliSektor = ValueNotifier<String?>(null);
  final ValueNotifier<List<Mentor>> gorunenMentorlar =
      ValueNotifier<List<Mentor>>(mockMentorlar);

  List<String> get sektorler =>
      tumMentorlar.value.map((m) => m.sektor).toSet().toList();

  void sektorSec(String? sektor) {
    seciliSektor.value = sektor;
    _filtrele();
  }

  void eslesmeIste(String mentorId) {
    tumMentorlar.value = [
      for (final m in tumMentorlar.value)
        if (m.id == mentorId && m.durum == EslesmeDurumu.yok)
          m.copyWith(durum: EslesmeDurumu.beklemede)
        else
          m,
    ];
    _filtrele();
  }

  void _filtrele() {
    final sektor = seciliSektor.value;
    gorunenMentorlar.value = sektor == null
        ? tumMentorlar.value
        : tumMentorlar.value.where((m) => m.sektor == sektor).toList();
  }

  void dispose() {
    tumMentorlar.dispose();
    seciliSektor.dispose();
    gorunenMentorlar.dispose();
  }
}
```

---

### Adım 5: Alt Bileşen (Widget) Dosyasını Oluşturma
`widget/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak alt bileşen UI katmanını oluştur. Renkler temadan gelir:

```dart
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/mentor_model.dart';

class MentorCard extends StatelessWidget {
  final Mentor mentor;
  final VoidCallback onEslesmeIste;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onEslesmeIste,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlowCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mentor.ad, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(mentor.unvan, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final u in mentor.uzmanliklar) Chip(label: Text(u)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${mentor.puan} • ${mentor.deneyimYili} yıl',
                  style: textTheme.labelLarge
                      ?.copyWith(color: context.spaceColors.neonLime),
                ),
                _EslesmeButonu(
                  durum: mentor.durum,
                  onPressed: onEslesmeIste,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EslesmeButonu extends StatelessWidget {
  final EslesmeDurumu durum;
  final VoidCallback onPressed;

  const _EslesmeButonu({required this.durum, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bekliyor = durum != EslesmeDurumu.yok;
    return FilledButton(
      onPressed: bekliyor ? null : onPressed,
      child: Text(
        switch (durum) {
          EslesmeDurumu.yok => 'Eşleşme İste',
          EslesmeDurumu.beklemede => 'Beklemede',
          EslesmeDurumu.eslesti => 'Eşleşti',
        },
      ),
    );
  }
}
```

---

### Adım 6: View Dosyasını Oluşturma
`view/<feature_name>.dart` dosyasında `StatelessWidget` ve `ValueListenableBuilder` kullanılarak UI katmanını bağla. Controller'ı dışarıdan alır, yaşam döngüsünü üst katman (shell) yönetir:

```dart
import 'package:flutter/material.dart';

import '../controller/mentor_controller.dart';
import '../models/mentor_model.dart';
import '../widget/mentor_card.dart';

class MentorPage extends StatelessWidget {
  final MentorController controller;

  const MentorPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mentorlar')),
      body: ValueListenableBuilder<List<Mentor>>(
        valueListenable: controller.gorunenMentorlar,
        builder: (context, mentorlar, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: mentorlar.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final mentor = mentorlar[index];
              return MentorCard(
                mentor: mentor,
                onEslesmeIste: () => controller.eslesmeIste(mentor.id),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### Adım 7: Alt Bar Sekmesine Kaydetme
Yeni ana sekme sadece `project.md` içindeki 4 sekmeden biri ise `features/shell/` altında kaydedilir. **Yeni sekme eklemek için kullanıcıdan onay alınır.**

```dart
import 'package:flutter/material.dart';

class AnaIskelet extends StatelessWidget {
  final ValueNotifier<int> seciliSekme;
  final List<Widget> sayfalar;

  const AnaIskelet({
    super.key,
    required this.seciliSekme,
    required this.sayfalar,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: seciliSekme,
      builder: (context, index, _) {
        return Scaffold(
          body: IndexedStack(index: index, children: sayfalar),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => seciliSekme.value = i,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.psychology_alt_rounded),
                label: 'Mentor',
              ),
              NavigationDestination(
                icon: Icon(Icons.rocket_launch_rounded),
                label: 'Yatırımcılar',
              ),
              NavigationDestination(
                icon: Icon(Icons.workspace_premium_rounded),
                label: 'Programlar',
              ),
              NavigationDestination(
                icon: Icon(Icons.hub_rounded),
                label: 'Topluluk',
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

### Adım 8: Birim Test İskeletini Oluşturma
`test/features/<feature_name>/<feature_name>_controller_test.dart` dosyasında controller'ı saf Dart ile test et:

```dart
import 'package:flutter_test/flutter_test.dart';

import 'package:yorunge/features/mentor/controller/mentor_controller.dart';
import 'package:yorunge/features/mentor/models/mentor_model.dart';

void main() {
  late MentorController controller;

  setUp(() => controller = MentorController());
  tearDown(() => controller.dispose());

  test('sektör seçilince liste filtrelenir', () {
    final sektor = controller.sektorler.first;
    controller.sektorSec(sektor);

    expect(
      controller.gorunenMentorlar.value.every((m) => m.sektor == sektor),
      isTrue,
    );
  });

  test('eşleşme istenince durum beklemede olur', () {
    final id = controller.tumMentorlar.value.first.id;
    controller.eslesmeIste(id);

    final mentor =
        controller.tumMentorlar.value.firstWhere((m) => m.id == id);
    expect(mentor.durum, EslesmeDurumu.beklemede);
  });
}
```

---

## Özel Durumlar

### A) Topluluk Modülü (Yetki Kontrolü)
Paylaşım, beğeni ve yanıt kuralı controller'da uygulanır; UI yalnızca sonucu gösterir:

```dart
enum KullaniciDurumu { onaysiz, incelemede, onayli }

class ToplulukController {
  final ValueNotifier<KullaniciDurumu> kullaniciDurumu;

  ToplulukController(KullaniciDurumu baslangic)
      : kullaniciDurumu = ValueNotifier<KullaniciDurumu>(baslangic);

  bool get paylasabilir => kullaniciDurumu.value == KullaniciDurumu.onayli;

  bool gonderiEkle(String metin) {
    if (!paylasabilir) return false;
    if (metin.trim().isEmpty || metin.length > 280) return false;
    // gönderi listesine eklenir (immutable liste yeniden atanır)
    return true;
  }
}
```

Kapsam: tek seviyeli yanıt, beğen/geri al, 280 karakter sınırı. Takip, DM, hashtag, medya ve bildirim eklenmez.

### B) Analiz (Çok Sayfalı Test) Modülü
- Her bölüm (Fikir, Ekip, Traction, İnovasyon, Plan Tabloları, Pazar, Marka, Özet) ayrı widget dosyasıdır: `widget/analiz_bolum_<ad>.dart`.
- Controller `ValueNotifier<int> aktifAdim` ve her bölüm için ayrı `ValueNotifier<BolumCevaplari>` tutar; tek dev form state'i yoktur.
- Dinamik listeler (ekip üyeleri, kilometre taşları, Gantt görevleri) immutable liste + `copyWith` ile güncellenir.
- İleri butonu bölüm doğrulaması geçmeden aktif olmaz; taslak `shared_preferences` ile kaydedilir.
- Gönderimden sonra başvuru durumu `fikir_durumu` modülüne devredilir.

### C) Fikir Durumu Modülü
Hukuki süreç adımları bir `enum` + zaman çizelgesi widget'ı ile gösterilir: avukat ataması → şirket tipi belirleme → ticaret sicil kaydı → vergi kaydı → marka tescil başvurusu → ortaklık sözleşmeleri. Avukat ve gelir destek taahhüdü kartları mock veriden beslenir.

---

## Clean Architecture ve Kod Kalitesi Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın tek ve belirgin bir sorumluluğu olmalıdır.
- **Reusability:** `GlowCard`, `SectionHeader`, `StarfieldBackground` gibi ortak widget'lar `core/widgets/` altında tutulur ve feature'lar arasında tekrar kullanılır.
- **Testability:** Controller katmanı Flutter UI'dan bağımsız saf Dart ile test edilebilir olmalıdır (`unit test`).
- **Tema Uyumu:** Her yeni ekran hem karanlık hem aydınlık temada kontrol edilmelidir.

---

## Tamamlama Kontrol Listesi
Scaffold bittiğinde ajan şunları doğrular:
1. Klasör ve dosya adları `project.md` haritasıyla birebir uyumlu mu?
2. Statik widget'lar `const` mu, `build` metotları 40 satırı geçmiyor mu?
3. Widget içinde sabit renk/stil var mı? (olmamalı)
4. Controller `dispose()` çağrılıyor mu?
5. `await` sonrası `context.mounted` kontrolü yapılmış mı?
6. Mock veri hacmi `project.md` minimumlarını karşılıyor mu?

```bash
flutter analyze
flutter test
```

---

## Ekstra İpuçları
- **Dependency Injection:** Controller nesneleri shell katmanında oluşturulup view'lara kurucu parametresiyle verilir; servis lokatörü paketi eklenmez.
- **Lifecycle Yönetimi:** Notifier sızıntılarını (memory leak) önlemek için controller'ın `dispose()` metodu, onu oluşturan `StatefulWidget`'ın `dispose()` içinde mutlaka çağrılmalıdır.
- **Performans:** Yıldız alanı gibi sürekli animasyonlu arka planlar `RepaintBoundary` içine alınır.
- **Testing:** `flutter analyze` ve `flutter test` adımları ile sıfır uyarı politikası benimsenmelidir.

---

## Sık Sorulan Sorular (SSS)
### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Projede yeni bir ekran, özellik modülü (mentor, yatırımcı, programlar, topluluk, analiz, fikir durumu) veya temiz state ayrımı gerektiren işlevler eklenirken kullanılmalıdır.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
**Cevap:** Küçük bir tema renk düzeltmesi, metin değişikliği veya tek satırlık hata onarımları gibi yeni bir modül yapısı gerektirmeyen durumlarda kullanılmamalıdır.
