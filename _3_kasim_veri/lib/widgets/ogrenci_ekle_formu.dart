import 'package:flutter/material.dart';
import 'package:_3_kasim_veri/services/firestore_ogrenci_servisi.dart';

/// Öğrenci ekleme formunu barındıran widget.
/// Hocanın belirttiği: Row içinde Expanded ile Proje Adı inputu ve Not inputu burada yer alır.
class OgrenciEkleFormu extends StatefulWidget {
  final IOgrenciServisi ogrenciServisi;

  const OgrenciEkleFormu({
    super.key,
    required this.ogrenciServisi,
  });

  @override
  State<OgrenciEkleFormu> createState() => _OgrenciEkleFormuState();
}

class _OgrenciEkleFormuState extends State<OgrenciEkleFormu> {
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  bool _yukleniyor = false;

  @override
  void dispose() {
    _adSoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    super.dispose();
  }

  Future<void> _yeniOgrenciKaydet() async {
    final String adSoyad = _adSoyadKontrolcusu.text.trim();
    final String projeAdi = _projeKontrolcusu.text.trim();
    final int? notu = int.tryParse(_notKontrolcusu.text.trim());

    if (adSoyad.isEmpty) {
      _snackBarGoster('Lütfen öğrenci adını ve soyadını girin.');
      return;
    }

    if (projeAdi.isEmpty) {
      _snackBarGoster('Lütfen proje adını girin.');
      return;
    }

    if (notu == null || notu < 0 || notu > 100) {
      _snackBarGoster('Lütfen 0 ile 100 arasında geçerli bir not girin.');
      return;
    }

    setState(() => _yukleniyor = true);

    try {
      await widget.ogrenciServisi.ogrenciEkle(
        adSoyad: adSoyad,
        projeAdi: projeAdi,
        notu: notu,
      );

      if (!mounted) return;
      _adSoyadKontrolcusu.clear();
      _projeKontrolcusu.clear();
      _notKontrolcusu.clear();
      FocusScope.of(context).unfocus();

      _snackBarGoster('$adSoyad başarıyla buluta eklendi.');
    } catch (error) {
      if (!mounted) return;
      _snackBarGoster('Kayıt başarısız: $error');
    } finally {
      if (mounted) {
        setState(() => _yukleniyor = false);
      }
    }
  }

  void _snackBarGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _adSoyadKontrolcusu,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Öğrenci Adı Soyadı",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            // HOCANIN İSTEDİĞİ KISIM:
            // Proje adı inputu Expanded içinde yer alarak kalan alanı doldurur,
            // yanında ise sabit genişlikli Not inputu bulunur.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _projeKontrolcusu,
                    decoration: const InputDecoration(
                      labelText: "Proje Adı",
                      prefixIcon: Icon(Icons.assignment),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 105,
                  child: TextField(
                    controller: _notKontrolcusu,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Not (0-100)",
                      prefixIcon: Icon(Icons.grade),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _yukleniyor ? null : _yeniOgrenciKaydet,
              icon: _yukleniyor
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_yukleniyor ? "Kaydediliyor..." : "Buluta Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
