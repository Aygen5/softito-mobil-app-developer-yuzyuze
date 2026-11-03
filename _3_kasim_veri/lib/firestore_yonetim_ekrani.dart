import 'package:_3_kasim_veri/models/ogrenci_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreYonetimEkrani extends StatefulWidget {
  const FirestoreYonetimEkrani({super.key});

  @override
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  @override
  void dispose() {
    _adSoyadKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    super.dispose();
  }

  Future<void> _yeniOgrenciKaydet() async {
    final String adSoyad = _adSoyadKontrolcusu.text.trim();
    final int? notu = int.tryParse(_notKontrolcusu.text.trim());

    if (adSoyad.isEmpty || notu == null || notu < 0 || notu > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad soyad ve 0-100 arasında bir not girin.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('ogrenciler').add({
        'adSoyad': adSoyad,
        'notu': notu,
      });
      if (!mounted) return;
      _adSoyadKontrolcusu.clear();
      _notKontrolcusu.clear();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt başarısız: $error')),
      );
    }
  }

  Future<void> _notGuncelleDialog(OgrenciModel ogrenci) async {
    final TextEditingController notKontrolcusu =
        TextEditingController(text: ogrenci.notu.toString());

    try {
      final String? girilenNot = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text('${ogrenci.adSoyad} için notu güncelle'),
          content: TextField(
            controller: notKontrolcusu,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Not (0-100)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                dialogContext,
                notKontrolcusu.text.trim(),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      );

      if (girilenNot == null) return;
      final int? yeniNot = int.tryParse(girilenNot);
      if (yeniNot == null || yeniNot < 0 || yeniNot > 100) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('0-100 arasında geçerli bir not girin.')),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('ogrenciler')
          .doc(ogrenci.id)
          .update({'notu': yeniNot});
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not güncellenemedi: $error')),
      );
    } finally {
      notKontrolcusu.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Firestore ekranı"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _adSoyadKontrolcusu,
                    decoration: const InputDecoration(
                      labelText: "Öğrenci Adı Soyadı",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _notKontrolcusu,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Not (0-100)",
                        prefixIcon: Icon(Icons.grade),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.brown,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: _yeniOgrenciKaydet,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text("Buluta kaydet"),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ogrenciler')
                  .orderBy('notu', descending: true)
                  .snapshots(),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Bulut hatası: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("Henüz bulutta kayıtlı öğrenci yoktur."),
                      );
                    }
                    final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: dokumanlar.length,
                      itemBuilder: (context, index) {
                        final doc = dokumanlar [index];
                        final ogrenci = OgrenciModel.fromFireStore(doc);
                        return  Dismissible(
                          key: Key(ogrenci.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right:20),
                            color: Colors.red,
                            child: const Icon(Icons.delete_forever, color: Colors.white),
                          ),
                          onDismissed: (direction){
                            FirebaseFirestore.instance
                                .collection('ogrenciler')
                                .doc(ogrenci.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar( 
                              SnackBar(content: Text('${ogrenci.adSoyad} buluttan silindi')),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: ogrenci.notu>=80 ? Colors.green : (ogrenci.notu >= 50 ? Colors.orange:Colors.red),
                              child: Text(
                                '${ogrenci.notu}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ), 
                              ),
                              title: Text(
                                ogrenci.adSoyad,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                              trailing: IconButton(
                                onPressed:()=> _notGuncelleDialog(ogrenci),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.amberAccent,
                                  ),
                                ),
                            ),
                          
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
