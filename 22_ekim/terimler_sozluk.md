Const
1) Ne işe yarar: İçi girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez CPU ve pil tasarrufu sağlar.


Final
1) Ne işe yarar: Çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenkerdir.

**** const ve final farkı: const derlenirken bilinmek zorundadır (const pi=3.4)
final ise çalışma anında belirlenebilir (final saat = Datetime.now()) 
-- Model sınıflarında alanlar her zaman final olmalıdır.

Late
1) Ne işe yarar: Değişken tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlayacağı zaman kullanılır.


Required:
1) Ne işe yarar: İsimlendirilmiş parametrelerde o parametrenin (değişkenin) zorunlu olduğunu belirtir.


@override:
1) Ne işe yarar: Alt sınıfın, üst sınıftan devraldığı metodu ezdiğini belirtir.
2) Faydası: Eğer üst metod adını yanlış yazarsanız (örnek builds yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar.


Null-aware Operatörleri: (? ?? !)
?. -  place?.title -> eğer place null ise hata vermez. direk null olarak döner.
?? - if null: final id = state.userId ?? 10; -> Sol taraf null ise sağdaki (harcode olan değer) otomatik olarak atanır.
!(null / force): final id = state.userId ! -> bu kod derleyiciye "bana güven,bu değer o anda kesinlikle null değil" der. eğer null gelir ise uygulama anında çöker.(ÇOK DİKKATLİ KULLANILMALI !!!)


Spread Operatörü:
1) Ne işe yarar: Bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler. 
Column ve ListView içindeki dinamik kart dizinini kullanmak en için en temiz yöntemdir.
...listeAdi.map((p)=> _build.Card(p))


initState()
Ne zaman çalışır: Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.
Ne yapar: ScrollController başlatmaları ve ilk api istekleri burada kurulur.
Kural: İçinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.


didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek: Theme.of(context)) değiştiğinde otomatik tetikler.
Ne yapar: BuildContext güvenli bir şekilde erişerek tema veya ekran boyutu bağımlılıkları ile ilgili ilk yüklemelr burada yapılır.


build(BuildContext context)
Ne zaman çalışır: Sayfa ilk açıldığında, setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır. Sadece UI döndürmelidir.


dispose()
Ne zaman çalışır: Widget hafızadan atılmadan hemen önce son bir kez çalışır. 
Ne yapılır: _controller.dispose() stream dinleyicilerin iptalleri burada yapılır. super.dispose() un mutlaka son satırda çalıştırılması gerekir.


setState(({}))
1) Arka planda ne yapar? State'in bağlı olduğu StatefullElement nesnesine "Ben değiştim, build et." sinyali yollar
2) Nerede Kullanılır? Sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder'a sinyali gönderilebilir.


ValueNotifier<T>
1) Arka planda ne iş yapar? ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar: (T_value)
2) Tetikleme değer atandığında (set value(T value)) eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonunu çağrılır. (addListener(() {}))


InheritedWidget
1) Ne Yapar? Widget ağacında alttaki childların, aradaki onlarca widgetı bypass ederek, üst widgetın verisine (state'ine) doğrudan erişmesini sağlayan soyut bir widgettır. 




Material 3 Tasarın Dili Renk Algoritması ve Temalar:

primary: Ana marka rengi
onPrimary: Ana rengin üstüne yazılacak yazı rengi (okunabilirlik açısından)
primaryContainer: Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılacak yazı (okunabilirlik açısından)
surface: Sayfa arka plan tuvali
onSurface: Sayfa üstündeki ana metin rengi
outlineVariant: İnce sınır ve ayrım çizgilerinin rengi


ThemeMode.system
color: Colors.black.withOpacity(186) // kesinlikle 1 ila 255 sayıları arasında tam sayı olarak girilmelidir.
**Bu kullanım güncelde istenmiyor**

color: Colors.balck.withValues(alpha: 186/255) // double sayı olarak girilmelidir. 
**Güncel ve doğru yöntemdir**


Arayüz Düzen ve Liste Bileşenleri

Expanded ve Flexible
Expanded: Kalan bol alanının TAMAMINI kaplamaya zorlar.
Flexible: Kalan bol alanını paylaştırır. (flex:1, flex:2)
Flex: Yanyana iki expanded varsa birbirine felx2 diğerine flex1 verir. Bu sayede ekran boyutuna göre otomatik olarak ayarlar.


Stack ve Positioned:
Ne yapar? : Widget'ları Z ekseninde üstüste bindirir.
Positioned: Yalnızca bir Stack içinde çalışır.
top:10, right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklememizi sağlar.


ListView.builder.
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanının tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler. Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.


shrinkWrap: true
1) Bir ListView baş bir dikey kaldrıcının (singleChildScrollView) içine konulursa Vertical Viewport hatası verir.
shrinkWrap true verilerek bu çözülebilir ancak; ListView'ın sonsuz kayma (sonsuz scroll) özelliği kaybolur.
**Sadece 3 5 elemanınız varsa bunu kullanmalısınız.**


Inkwell ve GestureDetector
GestureDetector: Tıklama, çift tıklama, sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ.
Inkwell: Tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir. 

Önemli Kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi takdirde su dalgası arkadaki tuvali göremediği için hiçbir şekilde görünmez. 




Form Mimarisi

GlobalKey<FormState>
Widget içindeki Form düğümüne doğrudan dışarıdan erişilemiliyor. Bu yüzden Widgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFromField validator bloklarını sırayla çalıştırır.

validator :(String ? value)
Fonskiyonda bir hata bulursa geriye String olarak hata metni dönderir. Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir. Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir. (Null gelmesi)

Animasyon Motoru
AnimatedContainer: genişlik, yükseklik, padding, margin, border, renk ve gölge oynatır.
AnimatedOpacity: görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur.
AnimatedScale: Widget merkezinden dışarıya doğru büyütp küçültür.
AnimatedAlign: Kutunun içinde sağdan sola yukardan aşağıya karşı konumunu değiştirir.


Curves
İvmelenme Karakterleri

Curves.linear: Sabit hız (robotik hareketler)
Curves.easeInout: Yavaş başlar, ortada hızlanır, yavaşça durur.
Curves.bounceOut: Hedefe çarptığında top gibi 2-3 kez yaylanarak seker.
Curves.elasticOut Lastik gibi ileri geri titreyerek yerine oturur.




GoRouter

-- context.go('/profil): Route yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder. Sayfayı temizleyebilir.

-- context.push('/profil/5') Stack yönlendirmedir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler.

-- context.pop() sayfanın en üstteki yığınını kapatır.

-- state.pathParameters["id"]: GoRouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır.

/profil?user=berat
state.url.queyParameters["user"]: Opsiyonel filtreleme ya da arama zamanlarında kullanılır.



Cihaz İçi Yerel Depolama Mimarileri:

- SharedPreferences: 
Küçük kullanıcı ayarları
Düşük güvenilirlik.
Okuma yazma hızları: Okuma hızı orta / yazma hızı yavaş


- FlutterSecureStorage: 
Şifre, Token vb. saklama
En yüksek güvence
okuma yazma hızları: Okuma hızlı yavaş / yazma hızı yavaş

- Hive/Isar: 
Yüksek performanslı nesne depolama
Orta (isteğe bağlı şifreleme açılabilir)
Aşırı hızlı





