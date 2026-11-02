import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

// main(): Flutter uygulamasının çalışmaya başladığı ana giriş fonksiyonudur.
void main() {
  // runApp(): Kök widget'ı ekrana bağlayıp widget ağacını başlatan fonksiyondur.
  runApp(const MiniMagazaApiUygulamasi());
}

// MiniMagazaApiUygulamasi: Tüm uygulamanın tema, başlık ve başlangıç ekranını yönettiğimiz ana widget.
class MiniMagazaApiUygulamasi extends StatelessWidget {
  const MiniMagazaApiUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: Google Material Design standartlarını (renkler, fontlar, routing) uygulamamıza kazandıran sarmalayıcıdır.
    return MaterialApp(
      title: 'Mini Mağaza Canlı API',
      debugShowCheckedModeBanner: false, // Sağ üstteki DEBUG bandını kaldırmak için kullanıldı
      // ThemeData: Uygulamanın genel renk ve stil şablonunu belirler
      theme: ThemeData(
        useMaterial3: true, // Modern Material 3 tasarım bileşenlerini kullanmak için true yaptık
        // colorSchemeSeed: Tek bir ana renk vererek tüm buton, AppBar ve kart renklerinin uyumlu türetilmesini sağlar
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          centerTitle: true, // Başlık tüm sayfalarda ortalı dursun diye burada global olarak ayarladık
          elevation: 0,      // AppBar'ın altındaki gölge çizgisini sıfırladık
        ),
      ),
      // home: Uygulama ilk açıldığında doğrudan ürün listesi ekranı açılsın diye verildi
      home: const UrunListesiEkrani(),
    );
  }
}

