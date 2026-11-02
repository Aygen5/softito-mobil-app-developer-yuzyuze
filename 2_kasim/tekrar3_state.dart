// setState() bulunduğu State nesnesinin build() metodunu baştan aşağı tekrar tetikler.
// Scaffold appbar topbar ve eğer varsa 20 tane container baştan hesaplanır.
// Bu yüzden sadece değişen widget'ı güncellemek için ValueNotifier gibi hafif çözümler kullanılır.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// SepetKontrolu: Singleton deseni kullanılmış sepet yöneticisi.
// Amacı: Uygulamanın her yerinden aynı sepete ulaşıp ürün sayısını yönetebilmek.
class SepetKontrolu{
  // Singleton: Tek bir nesne oluşturup dışarıya sunuyoruz
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  // Private constructor: Dışarıdan yeni bir SepetKontrolu nesnesi türetilmesini engeller
  SepetKontrolu._dahili();

  // ValueNotifier: Sayfa baştan çizilmeden sadece bu sayıyı dinleyen widget güncellensin diye kullandık
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  // Sepete ürün eklendiğinde değeri 1 artırır
  void sepeteEkle(){
    urunSayisi.value++;
  }

  // Sepeti sıfırlamak için kullanılır
  void sepetSifirla(){
    urunSayisi.value=0;
  }
}

// Sayfa yönlendirmeleri ve sekmeler arası geçiş için go_router kullanıldı
final GoRouter uygulamaRotalari = GoRouter(
   initialLocation: '/anasayfa',
   routes:[
      // ShellRoute: Alt bar (NavigationBar) sabit kalsın, sekmeye tıklayınca
      // sadece ortadaki ekran değişsin diye bu yapıyı kullandık.
      ShellRouter(
        builder(BuildContext context, GoRouterState state, Widget child){
          return AnaKasaEkrani(ekranGovdesi:child);
        },
        routes:[
          GoRoute(
            path:'/vitrin',
            builder:(context,state)=>const VitrinEkrani(),
          ),
          GoRoute(
            path:'/profil',
            builder:(context,state)=>const ProfilEkrani(),
          ),
        ],
      ),
   ],

);


// Ana Kasa Ekranı: Alt gezinme barını ve seçili ekranı tutan iskelet widget
class AnaKasaEkrani extends StatefullWidget{
   final Widget ekranGovdesi;
   const AnaKasaEkrani({super.key, required this.ekranGovdesi});

   @override
   Widget build(BuildContext context){
      return Scaffold(
          body: ekranGovdesi,
          bottomNavigationBar: NavigationBar(
               selectedIndex: _aktifIndexiBul(context),
                onDestinationSelected:(yeniIndeks){
                  if(yeniIndeks==0)context.go('/vitrin');
                  if(yeniIndeks==1)context.go('/profil');
                }, 

                destinations: [
                  const NavigationDestination(icon: Icon(Icons.store), label:'Vitrin'),
                       NavigationDestination(
                           // ValueListenableBuilder: urunSayisi değiştikçe sadece bu ikonu yeniler,
                           // bütün sayfanın gereksiz rebuild olmasını engeller
                           icon: ValueListenableBuilder<int>(
                                valueListenable: SepetKontrolu.ornek.urunSayisi,
                                builder:(context, urunSayisi, child){
                                    return Badge(
                                      label: Text('$sayi'),
                                      isLabelVisible: urunSayisi>0,
                                      child: const Icon(Icons.person),
                                    );
                                },
                           ),
                            label:'Profil',
                       ),
                ],
      ),
   };

}


int _aktifIndexiBul(BuildContext context){
  final String konum = GoRouterState.of(context).uri.toString();
  if(konum.startsWith('/profil')) return 1;
  return 0;
}

// Vitrin Ekranı: Kullanıcının sepete ürün eklediği ekran
class VitrinEkrani extends StatelessWidget{
  const VitrinEkrani({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Vitrin (ValueNotifier)')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed:(){
            // Singleton sepet nesnesindeki urunSayisi değerini 1 artırır
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ürün Ekle(+1)'),
        ),
      ),
    );
  }
}

// Profil Ekranı: Kullanıcı profilini ve sepet sıfırlama butonunu barındıran ekran
 class ProfilEkrani extends StatelessWidget{
  const ProfilEkrani({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: Center(
        child: TextButton(
          // Sepetteki ValueNotifier değerini 0 yapar
          onPressed:()=>SepetKontrolu.ornek.sepetSifirla(),
          child: const Text('Sepeti Temizle(0 Yap)'),
        ),
      ),
    );
 }

 }



