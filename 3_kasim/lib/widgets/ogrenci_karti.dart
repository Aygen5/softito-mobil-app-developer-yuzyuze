import 'package:flutter/material.dart';
import 'package:_3_kasim_veri/models/ogrenci_model.dart';
import 'package:_3_kasim_veri/services/firestore_ogrenci_servisi.dart';
import 'package:_3_kasim_veri/widgets/not_guncelle_dialog.dart';

/// Listede her bir öğrenciyi gösteren, sağa/sola kaydırarak silme ve düzenleme
/// özelliklerini barındıran kart widget'ı.
class OgrenciKarti extends StatelessWidget {
  final OgrenciModel ogrenci;
  final IOgrenciServisi ogrenciServisi;

  const OgrenciKarti({
    super.key,
    required this.ogrenci,
    required this.ogrenciServisi,
  });

  Color _notRengiBelirle(int notu) {
    if (notu >= 80) return Colors.green.shade600;
    if (notu >= 50) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(ogrenci.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade600,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Sil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_forever, color: Colors.white),
          ],
        ),
      ),
      onDismissed: (direction) async {
        try {
          await ogrenciServisi.ogrenciSil(ogrenci.id);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${ogrenci.adSoyad} buluttan silindi')),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Silme işlemi başarısız: $e')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _notRengiBelirle(ogrenci.notu),
            child: Text(
              '${ogrenci.notu}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            ogrenci.adSoyad,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Proje: ${ogrenci.projeAdi}'),
            ],
          ),
          trailing: IconButton(
            tooltip: 'Notu Düzenle',
            onPressed: () => NotGuncelleDialog.goster(
              context: context,
              ogrenci: ogrenci,
              ogrenciServisi: ogrenciServisi,
            ),
            icon: const Icon(
              Icons.edit,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
