import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';


/// Uygulamanın Başlangıç Noktası (Entry Point)

/// Dart ve Flutter programlarında execution (kodun çalışmaya başladığı yer) her zaman 'main()' fonksiyonudur.
/// 'async' anahtar kelimesi: Bu fonksiyon içinde 'await' (asenkron bekleme) kullanılacağını belirtir.
/// Uygulama ayağa kalkmadan önce yerelleştirme gibi bazı hazırlıkların tamamlanmasını beklemek zorundayız.
void main() async {

  /// 1. WidgetsFlutterBinding.ensureInitialized():
  /// Flutter motoru (Engine) ile widget ağacı arasındaki iletişimi kurar.
  /// 'runApp' çağrılmadan önce asenkron işlemler (veritabanı, yerelleştirme, dosya okuma vb.) yapılacaksa bu satırın MUTLAKA en başta çağrılması gerekir.
  WidgetsFlutterBinding.ensureInitialized();

  /// 2. initializeDateFormatting('tr_TR', null):
  /// 'intl' kütüphanesinin Türkçe tarih ve para formatlarını (ay isimleri, gün isimleri, para formatı) doğru şekilde yüklemesini sağlar.
  /// Bu sayede '20 Ekim 2026' veya '1.450 ₺' gibi yerelleştirilmiş formatları hata almadan kullanabiliriz.
  await initializeDateFormatting('tr_TR', null);

  /// 3. runApp(...):
  /// Verilen kök Widget'ı (burada RotaRentApp) alır ve cihazın ekranına bağlar.
  /// Flutter'ın 'Widget Tree' (Widget Ağacı) oluşturma süreci buradan başlar.
  /// 'const' kullanımı: Derleme zamanında sabit oluşturarak bellek ve performans kazandırır.
  runApp(const RotaRentApp());
}

