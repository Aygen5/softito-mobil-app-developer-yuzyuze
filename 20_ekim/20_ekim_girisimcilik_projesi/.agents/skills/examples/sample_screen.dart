// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ============================================================================
// 1. MODEL KATMANI (models/mentor_model.dart)
// ============================================================================

enum EslesmeDurumu { yok, beklemede, eslesti }

@immutable
class MentorSampleModel {
  final String id;
  final String ad;
  final String unvan;
  final String sektor;
  final List<String> uzmanliklar;
  final int deneyimYili;
  final double puan;
  final EslesmeDurumu durum;

  const MentorSampleModel({
    required this.id,
    required this.ad,
    required this.unvan,
    required this.sektor,
    required this.uzmanliklar,
    required this.deneyimYili,
    required this.puan,
    this.durum = EslesmeDurumu.yok,
  });

  MentorSampleModel copyWith({
    String? id,
    String? ad,
    String? unvan,
    String? sektor,
    List<String>? uzmanliklar,
    int? deneyimYili,
    double? puan,
    EslesmeDurumu? durum,
  }) {
    return MentorSampleModel(
      id: id ?? this.id,
      ad: ad ?? this.ad,
      unvan: unvan ?? this.unvan,
      sektor: sektor ?? this.sektor,
      uzmanliklar: uzmanliklar ?? this.uzmanliklar,
      deneyimYili: deneyimYili ?? this.deneyimYili,
      puan: puan ?? this.puan,
      durum: durum ?? this.durum,
    );
  }

  factory MentorSampleModel.fromJson(Map<String, dynamic> json) {
    return MentorSampleModel(
      id: json['id'] as String? ?? '',
      ad: json['ad'] as String? ?? '',
      unvan: json['unvan'] as String? ?? '',
      sektor: json['sektor'] as String? ?? '',
      uzmanliklar: (json['uzmanliklar'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deneyimYili: (json['deneyimYili'] as num?)?.toInt() ?? 0,
      puan: (json['puan'] as num?)?.toDouble() ?? 0.0,
      durum: EslesmeDurumu.values.firstWhere(
        (e) => e.name == json['durum'],
        orElse: () => EslesmeDurumu.yok,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'unvan': unvan,
      'sektor': sektor,
      'uzmanliklar': uzmanliklar,
      'deneyimYili': deneyimYili,
      'puan': puan,
      'durum': durum.name,
    };
  }
}

// ============================================================================
// 2. MOCK VERİ KATMANI (data/mock_mentor_data.dart)
// ============================================================================

const List<MentorSampleModel> mockMentorSampleList = [
  MentorSampleModel(
    id: 'm1',
    ad: 'Elif Arslanoğlu',
    unvan: 'Seri Girişimci, Yapay Zekâ',
    sektor: 'Yapay Zekâ',
    uzmanliklar: ['Ürün Stratejisi', 'Yatırım Hazırlığı'],
    deneyimYili: 14,
    puan: 4.9,
  ),
  MentorSampleModel(
    id: 'm2',
    ad: 'Kerem Yaltırak',
    unvan: 'Uzay ve Havacılık Teknolojileri Danışmanı',
    sektor: 'Havacılık ve Uzay',
    uzmanliklar: ['Ar-Ge Yönetimi', 'Hibe Başvuruları'],
    deneyimYili: 20,
    puan: 4.8,
  ),
  MentorSampleModel(
    id: 'm3',
    ad: 'Selin Doğan',
    unvan: 'Fintek ve Açık Bankacılık Uzmanı',
    sektor: 'Finansal Teknolojiler',
    uzmanliklar: ['Büyüme', 'Hukuki Uyum'],
    deneyimYili: 11,
    puan: 4.7,
  ),
];

// ============================================================================
// 3. CONTROLLER KATMANI (controller/mentor_controller.dart)
// ============================================================================

class MentorSampleController {
  final ValueNotifier<List<MentorSampleModel>> tumMentorlar =
      ValueNotifier<List<MentorSampleModel>>(mockMentorSampleList);
  final ValueNotifier<String?> seciliSektor = ValueNotifier<String?>(null);
  final ValueNotifier<List<MentorSampleModel>> gorunenMentorlar =
      ValueNotifier<List<MentorSampleModel>>(mockMentorSampleList);

  List<String> get sektorler =>
      tumMentorlar.value.map((m) => m.sektor).toSet().toList();

  void sektorSec(String? sektor) {
    seciliSektor.value = sektor;
    _filtrele();
  }

  void eslesmeIste(String mentorId) {
    tumMentorlar.value = [
      for (final m in tumMentorlar.value)
        if (m.id == mentorId && m.durum == EslesmeDurumu.yok)
          m.copyWith(durum: EslesmeDurumu.beklemede)
        else
          m,
    ];
    _filtrele();
  }

  void _filtrele() {
    final sektor = seciliSektor.value;
    gorunenMentorlar.value = sektor == null
        ? tumMentorlar.value
        : tumMentorlar.value.where((m) => m.sektor == sektor).toList();
  }

  void dispose() {
    tumMentorlar.dispose();
    seciliSektor.dispose();
    gorunenMentorlar.dispose();
  }
}

// ============================================================================
// 4. ALT WIDGET KATMANI (widget/mentor_card.dart)
// ============================================================================

class MentorSampleCard extends StatelessWidget {
  final MentorSampleModel mentor;
  final VoidCallback onEslesmeIste;

  const MentorSampleCard({
    super.key,
    required this.mentor,
    required this.onEslesmeIste,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C1224) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFF6B2C).withValues(alpha: 0.15),
                child: Text(
                  mentor.ad.characters.first,
                  style: const TextStyle(
                    color: Color(0xFFFF6B2C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.ad,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mentor.unvan,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              _buildRatingBadge(theme),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: mentor.uzmanliklar
                .map((u) => Chip(
                      label: Text(u, style: const TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFA3E635).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFA3E635)),
          const SizedBox(width: 4),
          Text(
            mentor.puan.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA3E635),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (mentor.durum) {
      case EslesmeDurumu.yok:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEslesmeIste,
            icon: const Icon(Icons.rocket_launch_rounded, size: 16),
            label: const Text('Eşleşme İste'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B2C),
              foregroundColor: Colors.white,
            ),
          ),
        );
      case EslesmeDurumu.beklemede:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Eşleşme İsteği Beklemede',
            style: TextStyle(
              color: Color(0xFF22D3EE),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case EslesmeDurumu.eslesti:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFA3E635).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Eşleşildi — Görüşme Planlandı',
            style: TextStyle(
              color: Color(0xFFA3E635),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }
}

// ============================================================================
// 5. VIEW KATMANI (view/mentor.dart)
// ============================================================================

class MentorSampleView extends StatefulWidget {
  const MentorSampleView({super.key});

  @override
  State<MentorSampleView> createState() => _MentorSampleViewState();
}

class _MentorSampleViewState extends State<MentorSampleView> {
  late final MentorSampleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MentorSampleController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Havuzu'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildFilterChips(),
          ),
          ValueListenableBuilder<List<MentorSampleModel>>(
            valueListenable: _controller.gorunenMentorlar,
            builder: (context, mentorlar, _) {
              if (mentorlar.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Kriterlere uygun mentor bulunamadı.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final mentor = mentorlar[index];
                    return MentorSampleCard(
                      mentor: mentor,
                      onEslesmeIste: () => _controller.eslesmeIste(mentor.id),
                    );
                  },
                  childCount: mentorlar.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return ValueListenableBuilder<String?>(
      valueListenable: _controller.seciliSektor,
      builder: (context, secili, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Tümü'),
                selected: secili == null,
                onSelected: (_) => _controller.sektorSec(null),
              ),
              const SizedBox(width: 8),
              ..._controller.sektorler.map(
                (sektor) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(sektor),
                    selected: secili == sektor,
                    onSelected: (_) => _controller.sektorSec(sektor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
