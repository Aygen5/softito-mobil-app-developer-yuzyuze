import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

class MockUrunServisi implements IUrunServisi {

  final List<Urun> _urunDeposu= [
    Urun(
      id: 1,
      baslik: 'Mackbook M5 Pro Laptop',
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Mackbook Pro",
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 2,
      baslik: "Apple İphone 18 Pro Max",
      aciklama: "İphone 18 Pro Max. Tıpkı İphone 17 gibi, hem İphone'larda hem de akıllı saatlerde kullanılan daha dayanıklı titanyumdan üretildi.",
      fiyat: 199999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 3,
      baslik: "Erkek Deri Ceket",
      aciklama: "Kış ayları için özel olarak tasarlanmış, kaliteli deri malzemeden üretilmiş erkek ceket.",
      fiyat: 1299.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 34,
    ),
    Urun(
      id: 4,
      baslik: "Kadın Spor Ayakkabı",
      aciklama: "Günlük kullanım için rahat ve şık bir kadın spor ayakkabı.",
      fiyat: 3999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 5,
    ),
    Urun(
      id: 5,
      baslik: "Kadın Şık Elbise",
      aciklama: "Özel davetler ve gece etkinlikleri için tasarlanmış şık bir kadın elbise.",
      fiyat: 799.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 7,
    ),
    Urun(
        id: 6,
        baslik:"Altın Kolye",
        aciklama:"Altın kaplama, zarif tasarımlı bir kolye. Özel günler ve davetler için ideal.",
        fiyat:1299.99,
        resimUrl:'"https://picsum.photos/400/400',
        kategori:Kategori.aksesuar,
        stokAdedi:10,
    ),
    ];

    @override
    Future<List<Urun>> tumUrunleriGetir() async {
      await Future.delayed(const Duration(milliseconds:1500));
      return List.from(_urunDeposu);
  }

    @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds:400));
    if(kategori==Kategori.hepsi){
      return List.from(_urunDeposu);
   }
   return _urunDeposu.where((urun) => urun.kategori==kategori).toList();
   }

    @override
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    await Future.delayed(const Duration(milliseconds:300));
    if(aramaMetni.trim().isEmpty){
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun){
      final baslikKucuk=urun.baslik.toLowerCase();
      final arananKucuk=aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk);
    }).toList();
 
  }
 }

  