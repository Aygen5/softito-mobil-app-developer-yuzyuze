# VERDANT — MİMARİ VE KOD ORGANİZASYONU

## 1. Mimari Amaç

Verdant uygulaması, Flutter ve Dart kullanılarak geliştirilecek; okunabilir, test edilebilir, bakımı kolay ve yeni özelliklerle genişletilebilir bir mimariye sahip olmalıdır.

Proje gereksiz kurumsal karmaşıklık içermemeli, ancak bütün iş mantığı tek bir dosyaya da yığılmamalıdır.

Temel yaklaşım:

**View → Cubit → Repository → Yerel Veri Kaynağı**

Ekranlar doğrudan veri kaynağını değiştirmemelidir. İş kuralları widget'ların içine yerleştirilmemelidir.

## 2. Mimari Kurallar

1. Arayüz ile iş mantığı ayrılmalıdır.
2. Ekranlar Cubit durumlarını dinlemelidir.
3. Cubit işlemleri repository üzerinden yürütmelidir.
4. Demo verileri ayrı bir kaynakta tanımlanmalıdır.
5. Streak ve başarı hesapları ayrı bir iş mantığı katmanında tutulmalıdır.
6. Aynı veri için farklı ekranlarda bağımsız sabit değerler kullanılmamalıdır.
7. Tek bir devasa Cubit oluşturulmamalıdır.
8. Her küçük widget için gereksiz dosya veya katman oluşturulmamalıdır.
9. Gereksiz soyutlamalardan kaçınılmalıdır.
10. Yeni bir paket ancak gerçek bir ihtiyaç varsa eklenmelidir.

## 3. Önerilen Klasör Yapısı

Aşağıdaki yapı başlangıç mimarisidir. Mevcut proje incelenmeden dosyalar topluca taşınmamalı veya silinmemelidir.

```text
lib/
├── main.dart
├── app.dart
│
├── app/
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── di/
│       └── app_dependencies.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── demo_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── streak_calculator.dart
│   │   ├── progress_calculator.dart
│   │   └── achievement_calculator.dart
│   └── widgets/
│       ├── app_scaffold.dart
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_bottom_navigation.dart
│       ├── empty_state.dart
│       └── loading_indicator.dart
│
├── data/
│   ├── demo/
│   │   ├── demo_data_factory.dart
│   │   ├── demo_habits.dart
│   │   └── demo_history.dart
│   └── repositories/
│       ├── habit_repository.dart
│       ├── habit_repository_impl.dart
│       ├── statistics_repository.dart
│       ├── statistics_repository_impl.dart
│       ├── settings_repository.dart
│       └── settings_repository_impl.dart
│
├── models/
│   ├── habit.dart
│   ├── habit_completion.dart
│   ├── habit_reminder.dart
│   ├── habit_category.dart
│   ├── habit_schedule.dart
│   ├── daily_progress.dart
│   ├── achievement.dart
│   └── app_settings.dart
│
├── features/
│   ├── onboarding/
│   │   ├── view/
│   │   │   ├── welcome_screen.dart
│   │   │   └── register_screen.dart
│   │   └── cubit/
│   │       └── onboarding_cubit.dart
│   │
│   ├── home/
│   │   ├── view/
│   │   │   └── home_screen.dart
│   │   ├── cubit/
│   │   │   ├── home_cubit.dart
│   │   │   └── home_state.dart
│   │   └── widgets/
│   │       ├── daily_progress_card.dart
│   │       ├── habit_card.dart
│   │       ├── daily_quote_card.dart
│   │       ├── hydration_card.dart
│   │       └── add_habit_button.dart
│   │
│   ├── habits/
│   │   ├── view/
│   │   │   ├── habits_screen.dart
│   │   │   └── habit_form_sheet.dart
│   │   ├── cubit/
│   │   │   ├── habits_cubit.dart
│   │   │   └── habits_state.dart
│   │   └── widgets/
│   │       ├── habit_icon_picker.dart
│   │       ├── habit_color_picker.dart
│   │       ├── weekday_selector.dart
│   │       ├── reminder_time_picker.dart
│   │       └── habit_category_selector.dart
│   │
│   ├── calendar/
│   │   ├── view/
│   │   │   └── calendar_screen.dart
│   │   ├── cubit/
│   │   │   ├── calendar_cubit.dart
│   │   │   └── calendar_state.dart
│   │   └── widgets/
│   │       ├── month_calendar.dart
│   │       ├── activity_heatmap.dart
│   │       ├── calendar_legend.dart
│   │       └── selected_day_details.dart
│   │
│   ├── statistics/
│   │   ├── view/
│   │   │   └── statistics_screen.dart
│   │   ├── cubit/
│   │   │   ├── statistics_cubit.dart
│   │   │   └── statistics_state.dart
│   │   └── widgets/
│   │       ├── overview_stat_card.dart
│   │       ├── weekly_completion_chart.dart
│   │       ├── habit_consistency_card.dart
│   │       ├── insight_card.dart
│   │       ├── achievement_grid.dart
│   │       └── achievement_detail_sheet.dart
│   │
│   └── shell/
│       └── main_shell.dart
│
└── services/
    └── notification_service.dart

test/
├── models/
├── repositories/
├── utils/
└── features/
```

Bu yapı ihtiyaçlara göre sadeleştirilebilir. Ancak katmanların sorumlulukları korunmalıdır.

## 4. Uygulama Başlangıcı

`main.dart` şu sorumlulukları taşımalıdır:

- Flutter başlangıcını yapmak.
- Gerekli platform servislerini başlatmak.
- Bildirim servisini güvenli biçimde hazırlamak.
- Demo verilerini oluşturmak.
- Repository bağımlılıklarını hazırlamak.
- Uygulamayı çalıştırmak.

Başlatma sırasında bir platform servisi hata verirse uygulama gereksiz yere tamamen çökmemelidir. Hata yönetimi uygun olmalıdır.

`app.dart` şu sorumlulukları taşımalıdır:

- MaterialApp.router oluşturmak.
- Tema ayarlarını uygulamak.
- GoRouter yapılandırmasını bağlamak.
- Global localization ve benzeri uygulama ayarlarını yapmak.

İş mantığı `main.dart` veya `app.dart` içine yerleştirilmemelidir.

## 5. GoRouter ve Shell Yapısı

GoRouter ile aşağıdaki rotalar tanımlanmalıdır:

- `/welcome`
- `/register`
- `/home`
- `/habits`
- `/calendar`
- `/statistics`

Ana uygulama rotaları bir `ShellRoute` veya uygun bir `StatefulShellRoute` üzerinden yönetilmelidir.

Dört ana sekme:
- Ana Sayfa.
- Takvim.
- İstatistikler.
- Alışkanlıklar.

Alt gezinme çubuğu, ana sekmeler arasında geçişte görünür kalmalıdır.

Ana sekmelerin birbirinden bağımsız gezinme geçmişi tutması gerekiyorsa `StatefulShellRoute.indexedStack` tercih edilebilir. Ancak proje gereksinimi yoksa daha basit `ShellRoute` kullanımı da kabul edilir.

Modal açılması için yeni bir ana navigasyon sekmesi oluşturulmamalıdır. Alışkanlık formu ilgili ekran üzerinden modal veya bottom sheet olarak açılmalıdır.

Demo ile Devam Et butonu, authentication olmadan ana uygulama rotasına yönlendirmelidir.

## 6. Veri Modelleri

### 6.1. Habit

`Habit` en az aşağıdaki alanları içermelidir:

- `id`: Benzersiz kimlik.
- `name`: Alışkanlık adı.
- `category`: Kategori.
- `iconKey`: İkonu temsil eden sabit anahtar.
- `colorValue`: Renk değeri.
- `goalValue`: Sayısal hedef.
- `goalUnit`: Hedef birimi.
- `schedule`: Tekrarlanacak günler.
- `startDate`: Başlangıç tarihi.
- `challengeDurationDays`: Varsa hedef dönem.
- `reminder`: Hatırlatma ayarları.
- `isArchived`: Arşiv durumu.
- `createdAt`: Oluşturulma tarihi.

Alışkanlığın güncel durumu yalnızca `status` gibi elle değiştirilen bir metinden belirlenmemelidir. Durum; başlangıç tarihi, plan, hedef ve tamamlama kayıtları üzerinden gerektiğinde hesaplanmalıdır.

### 6.2. HabitCompletion

Her tamamlama kaydı en az şunları içermelidir:

- `habitId`.
- `date`.
- `value`.
- `isCompleted`.
- Gerekliyse kısmi hedef durumu.

Tarihler karşılaştırılırken saat bileşeni dikkate alınmamalı; gün düzeyinde normalleştirilmelidir.

Bir alışkanlık için bir günde birden fazla ilerleme girdisi desteklenecekse toplam miktar ve tamamlama kuralı açıkça tanımlanmalıdır. İlk sürümde gereksiz karmaşıklık oluşturulmamalıdır.

### 6.3. HabitSchedule

Tekrarlanacak günleri ve günlük/haftalık planı temsil eder.

Haftanın günleri tek bir sihirli sayı veya okunması zor metin olarak saklanmamalıdır. Uygun bir enum veya tip güvenli yapı kullanılmalıdır.

### 6.4. HabitReminder

Hatırlatma bilgilerini tutar:

- Etkinlik durumu.
- Saat ve dakika.
- Gerekli tekrarlama günleri.

### 6.5. Achievement

Rozet bilgilerini tutar:

- Benzersiz kimlik.
- Başlık.
- Açıklama.
- İkon anahtarı.
- Görsel renk.
- Kazanılma koşulu.
- Kilitli/kazanılmış durumunu hesaplamak için gerekli bilgi.

Kazanılma durumu iş kurallarından türetilmelidir.

## 7. Repository Sorumlulukları

### HabitRepository

Aşağıdaki işlemleri sağlamalıdır:

- Bütün alışkanlıkları getirme.
- Alışkanlık ekleme.
- Alışkanlık güncelleme.
- Alışkanlık silme.
- Günlük tamamlama kaydı oluşturma.
- Tamamlama kaydını geri alma.
- Tarih aralığı için geçmişi getirme.
- Belirli bir günün kayıtlarını getirme.
- Alışkanlık bazında geçmişi filtreleme.

Bu repository ilk sürümde bellekte tutulan verilerle çalışacaktır.

### StatisticsRepository

Aşağıdaki hesaplamaları sağlamalıdır:

- Toplam tamamlama.
- Günlük tamamlanma oranı.
- Haftalık ve aylık başarı yüzdesi.
- Güncel streak.
- En uzun streak.
- Alışkanlık bazlı tutarlılık.
- En istikrarlı alışkanlık.
- Geliştirilmesi gereken alışkanlık.
- Rozet kazanılma durumu.

Aynı hesaplama birden fazla Cubit içinde tekrar yazılmamalıdır.

### SettingsRepository

Gerekli basit yerel tercihler için kullanılabilir:
- Hatırlatma tercihleri.
- Görsel veya davranışsal küçük ayarlar.
- Kullanıcının seçtiği görünüm tercihleri.

Kapsam gerektirmiyorsa bu repository gereksiz yere büyütülmemelidir.

## 8. Cubit Sorumlulukları

### HomeCubit

- Günlük alışkanlık listesini sağlar.
- Günlük ilerlemeyi hesaplanmış veriden alır.
- Tamamlama ve geri alma işlemlerini yönetir.
- Motivasyon sözünü seçer.
- Ana sayfanın durumunu günceller.

### HabitsCubit

- Alışkanlık listesini yönetir.
- Ekleme, düzenleme ve silme işlemlerini yürütür.
- Form için gerekli seçim durumlarını yönetebilir.
- Başarılı işlem sonrası ilgili veriyi yeniler.

Formun kendi geçici durumunu küçük bir yerel form controller ile yönetmek uygunsa sırf her alan için Cubit oluşturulması gerekmez.

### CalendarCubit

- Seçili ayı yönetir.
- Önceki ve sonraki aya geçişi yönetir.
- Seçili günü tutar.
- Alışkanlık filtresini yönetir.
- Günlük kayıtları ve aktivite ızgarasını sağlar.

### StatisticsCubit

- Haftalık/aylık dönem seçimini yönetir.
- İstatistik özetini sağlar.
- Grafik verilerini hazırlar.
- Rozet durumlarını sağlar.

### OnboardingCubit

- Giriş ve kayıt ekranlarındaki demo akışını yönetebilir.
- Demo ile devam et işlemini gerçekleştirir.

Bu Cubit gerçek kullanıcı doğrulaması yapmamalıdır.

## 9. Veri Akışı

Örnek: Kullanıcı bir alışkanlığı tamamladığında:

1. Kullanıcı karttaki tamamlama butonuna dokunur.
2. İlgili Cubit işlemi başlatır.
3. Cubit repository üzerinden tamamlama kaydını değiştirir.
4. Ortak demo veri kaynağı güncellenir.
5. İlgili Cubit yeni durumu yayınlar.
6. Günlük ilerleme ve ilgili görsel durumlar yenilenir.
7. Takvim, istatistik ve rozet ekranları aynı veriyi kullanır.
8. Yeni bir başarı kazanıldıysa uygun animasyon tetiklenebilir.

Bir widget yalnızca animasyon göstermek için veri kaynağını değiştirmemelidir.

## 10. Streak Hesaplama Kuralları

Streak, art arda tamamlanan planlı günleri temsil eder.

- Alışkanlığın planlanmadığı günler seriyi gereksiz yere bozmaz.
- Henüz gelmemiş günler seriyi bozmaz.
- Planlanmış ve geçmiş bir gün tamamlanmamışsa seri kesilebilir.
- Başlangıç tarihinden önceki günler hesaba katılmaz.
- Arşivlenmiş alışkanlıklar için geçmiş kayıtlar korunur.
- En uzun seri tarihsel tamamlamalardan hesaplanır.
- Güncel seri ile meydan okuma ilerlemesi farklı kavramlardır.

Günlük bir alışkanlığın bugünkü kaydı henüz tamamlanmadıysa, günün hangi saatinde olunduğuna göre devam eden seri mantığı dikkatle ele alınmalıdır. Kullanıcı gününü bitirmeden serisi gereksiz yere sıfırlanmamalıdır.

Streak hesapları `streak_calculator.dart` gibi merkezi bir yardımcıda bulunmalıdır.

## 11. Günlük ve Genel İlerleme Kuralları

Günlük tamamlanma oranı:

Tamamlanan planlı alışkanlık sayısı / O gün planlanan alışkanlık sayısı.

Günlük oran, 30 günlük meydan okuma ilerlemesiyle karıştırılmamalıdır.

Kısmi hedefler için:
- Alışkanlığın hedefi ve birimi dikkate alınmalıdır.
- Kısmi miktar varsa gerçek miktar gösterilmelidir.
- Tamamlanma durumu açık bir kurala göre belirlenmelidir.

Örneğin su hedefi 3.000 ml ve kayıt 2.500 ml ise:
- Miktar göstergesi 2.500/3.000 ml olmalıdır.
- Hedef tamamlama yüzdesi yaklaşık %83 olmalıdır.
- Alışkanlık henüz tamamlanmış sayılmamalıdır.

## 12. Motivasyon Sözleri

Motivasyon sözleri yerel bir Dart koleksiyonunda bulunmalıdır.

Ana sayfa her yeniden açıldığında yeni bir söz seçilebilir. Kullanılabilir alternatif varsa hemen önce gösterilen söz tekrar seçilmemelidir.

Sözler alışkanlık temasına uygun olmalıdır:
- Süreklilik.
- Kitap okuma.
- Sağlıklı yaşam.
- Su tüketimi.
- Hareket.
- Küçük adımlar.

Rastgele söz seçimi uygulamanın tamamını yeniden oluşturmamalı; yalnızca ilgili durum güncellenmelidir.

## 13. Bildirim Servisi

`NotificationService` aşağıdaki sorumlulukları taşımalıdır:

- Bildirim izinlerini istemek.
- Yerel bildirimleri planlamak.
- Bildirimleri güncellemek.
- Alışkanlık silindiğinde ilgili bildirimleri iptal etmek.
- Hatırlatma kapatıldığında ilgili planlamayı kaldırmak.
- Uygun platform yapılandırmasını kullanmak.
- İzin verilmediğinde güvenli biçimde çalışmaya devam etmek.

Bildirim kimlikleri her alışkanlık için kararlı ve çakışmayacak biçimde oluşturulmalıdır.

Saat ve tekrar günleri doğru biçimde kullanılmalıdır.

Gerçek cihaz testleri yapılmadan bütün platformlarda bildirimin kesin çalıştığı iddia edilmemelidir.

## 14. Tema ve Bileşenler

Tema değerleri `core/theme` altında merkezi olarak tanımlanmalıdır.

Tek tek widget'lar rastgele renkler, boşluklar veya köşe yarıçapları üretmemelidir.

Yeniden kullanılabilir bileşenler:
- AppCard.
- AppButton.
- HabitCard.
- CircularProgressCard.
- ProgressBar.
- QuoteCard.
- AchievementBadge.
- StatisticCard.
- EmptyState.
- BottomNavigation.
- HabitFormSheet.

Bileşenler gerektiğinde özelleştirilebilir parametreler almalı, ancak tüm tasarım sistemi her widget içinde yeniden oluşturulmamalıdır.

## 15. Hata Yönetimi

- Hata mesajları Türkçe olmalıdır.
- Bildirim izin hatası uygulamayı çökertmemelidir.
- Geçersiz form değerleri kullanıcıya gösterilmelidir.
- Silme işlemi başarısız olduğunda yanlış başarı mesajı gösterilmemelidir.
- Asenkron işlemler uygun yükleniyor ve hata durumlarına sahip olmalıdır.
- Boş listeler ve geçmişi olmayan tarihler doğru ele alınmalıdır.

## 16. Test Edilebilirlik

İş mantığı widget'lardan bağımsız test edilebilir olmalıdır.

Öncelikli testler:
- Streak hesaplaması.
- Günlük tamamlama oranı.
- Kısmi su hedefi.
- Haftalık ve aylık başarı oranları.
- Rozet kazanma koşulları.
- Başlangıç verilerinin tutarlılığı.
- Alışkanlık ekleme ve silme.
- Tamamlama ve geri alma.
- Tarih aralığı filtreleme.

Testlerde sabit bir referans tarihi kullanılarak bugünün tarihine bağımlılık azaltılmalıdır.

## 17. Mimari Tamamlanma Ölçütleri

- View katmanı doğrudan repository uygulamasına bağımlı olmamalıdır.
- Cubit içinde gereksiz UI kodu bulunmamalıdır.
- Hesaplamalar merkezi ve test edilebilir olmalıdır.
- Demo verileri tek bir ortak kaynaktan yönetilmelidir.
- GoRouter ana gezinmeyi yönetmelidir.
- Modal işlemleri ana sekme yapısını bozmamalıdır.
- Bildirimler ayrı servis tarafından yönetilmelidir.
- Dosyalar gerçek sorumluluklarına göre ayrılmalıdır.
- Gereksiz mimari katmanlar oluşturulmamalıdır.