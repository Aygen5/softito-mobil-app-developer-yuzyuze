import 'package:flutter/material.dart';

// Bu widget'ta Flutter'da sıkça karşılaşılan "Row içinde metin taşması (overflow)" hatasını ve Expanded ile çözümünü inceliyoruz.
class HataliveDogruRow extends StatelessWidget {
    const HataliveDogruRow({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Row ve Layout")),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // 1. Kısım: Hatalı yapı örneği
                       // Row yatayda sınırsız genişlik verir. Eğer Row içine uzun bir Text koyarsak ekran sınırını aşar ve meşhur sarı-siyah şeritli "RenderFlex overflowed" hatası çıkar.
                       const Text(
                        'Hatalı Yapı: A overflowed by *** pixels (sarı siyah şerit)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                       ),
                       const SizedBox(height: 8),

                       Container(
                        color: Colors.amber.shade100,
                        child: Row(
                            children: const [
                                Icon(Icons.warning, color: Colors.red),
                                // Bu metin kısa kaldığı sürece patlamaz ama yarın bir gün uzarsa veya ekran daralırsa sınır olmadığı için taşma hatası verecektir.
                                Text('Kısa Metin (hata vermez ama uzarsa Render Patlar)'),
                            ],
                        ),
                       ),
                       const SizedBox(height: 32),
                       
                       // 2. Kısım: Doğru yapı örneği
                       // Expanded kullanmak demek: "Row içindeki kalan tüm boşluğu sen kapla ve çocuğunun bu sınırı aşmasına izin verme" demektir. Böylece metin alt satıra geçer.
                       const Text(
                         'Doğru Yapı: Flexible ve Expanded ile sınırlandırılmıştır.',
                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                       const SizedBox(height: 8),

                       Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                            children: const [
                                CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.check, color: Colors.white),
                                ),
                                SizedBox(width: 12),

                                // Expanded widget'ı: Row içindeki boş alanı hesaplar ve Column/Text'i bu alanla sınırlar.
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                              'Softito 4.Dönem Mobil Standartı',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 4),
                                            // Metin artık ekran genişliğini bildiği için otomatik olarak alt satıra kayar.
                                            Text(
                                              'Bu metin ne kadar uzun olursa olsun, telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez.',
                                              style: TextStyle(color: Colors.black87),
                                            )
                                        ]
                                    )
                                )
                         ]
                      )
                    )
                ],
                )            
            )
        );
    }
}

