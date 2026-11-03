import 'package:flutter/material.dart';
import 'package:_3_kasim_veri/models/ogrenci_model.dart';
import 'package:_3_kasim_veri/services/firestore_ogrenci_servisi.dart';
import 'package:_3_kasim_veri/widgets/ogrenci_ekle_formu.dart';
import 'package:_3_kasim_veri/widgets/ogrenci_karti.dart';

/// Firestore üzerinden öğrenci ve proje yönetimi yapılan ana ekran.
/// Katmanlı mimari gereği UI mantığı, servis katmanından izole edilmiştir.
class FirestoreYonetimEkrani extends StatefulWidget {
  const FirestoreYonetimEkrani({super.key});

  @override
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  // Bağımlılığı soyut arayüz (IOgrenciServisi) üzerinden bağlıyoruz.
  final IOgrenciServisi _ogrenciServisi = FirestoreOgrenciServisi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Canlı Firestore Ekranı",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // 1. Üst Kısım: Öğrenci ve Proje Ekleme Formu
          OgrenciEkleFormu(ogrenciServisi: _ogrenciServisi),

          const Divider(thickness: 1.5, height: 1),

          // 2. Alt Kısım: Firestore Real-Time Stream Dinleyicisi ve Liste
          Expanded(
            child: StreamBuilder<List<OgrenciModel>>(
              stream: _ogrenciServisi.ogrencileriCanliDinle(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<OgrenciModel>> snapshot,
              ) {
                // Hata durumu
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(
                            "Bulut Bağlantı Hatası:\n${snapshot.error}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Yüklenme durumu
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Veri yok veya liste boş
                final List<OgrenciModel> ogrenciler = snapshot.data ?? [];
                if (ogrenciler.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "Henüz bulutta kayıtlı öğrenci bulunmuyor.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Canlı liste
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: ogrenciler.length,
                  itemBuilder: (context, index) {
                    final ogrenci = ogrenciler[index];
                    return OgrenciKarti(
                      ogrenci: ogrenci,
                      ogrenciServisi: _ogrenciServisi,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
