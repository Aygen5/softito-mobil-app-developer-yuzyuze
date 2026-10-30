class Degerlendirme{
    final double puan;
    final int oySayisi;

    const Degerlendirme({
      required this.puan,
      required this.oySayisi,
    });

    factory Degerlendirme.fromJson(Map<String, dynamic>? json){
      if (json == null) {
        return const Degerlendirme(puan: 0.0, oySayisi: 0);
      }
      return Degerlendirme(
        puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
        oySayisi: (json['count'] as num?)?.toInt() ?? 0,
      );
    }

    
}