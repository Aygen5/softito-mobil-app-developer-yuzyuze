#!/usr/bin/env bash

# ==============================================================================
# Yörünge Girişimcilik Platformu — Feature İskelet Üretici Betiği
# ==============================================================================
# Bu betik, project.md ve SKILL.md (yorunge-feature-scaffold) standartlarına uygun
# olarak yeni bir ekran/modül için feature-first klasör ve şablon dosyalarını üretir.
#
# Kullanım:
#   ./generate_feature.sh <feature_adi>
# Örnek:
#   ./generate_feature.sh etkinlik
# ==============================================================================

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "HATA: Lütfen bir özellik (feature) adı belirtin."
    echo "Kullanım: $0 <feature_adi>"
    exit 1
fi

FEATURE_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# PascalCase dönüşümü
pascal_case() {
    echo "$1" | awk -F_ '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS=''
}

PASCAL_NAME=$(pascal_case "$FEATURE_NAME")

echo "🚀 Yörünge: '$FEATURE_NAME' ($PASCAL_NAME) özelliği için iskelet üretiliyor..."
echo "📂 Proje Dizini: $PROJECT_ROOT"

FEATURE_DIR="$PROJECT_ROOT/lib/features/$FEATURE_NAME"
TEST_DIR="$PROJECT_ROOT/test/features/$FEATURE_NAME"

mkdir -p "$FEATURE_DIR/controller"
mkdir -p "$FEATURE_DIR/models"
mkdir -p "$FEATURE_DIR/data"
mkdir -p "$FEATURE_DIR/view"
mkdir -p "$FEATURE_DIR/widget"
mkdir -p "$TEST_DIR"

# 1. MODEL DOSYASI
cat <<EOF > "$FEATURE_DIR/models/${FEATURE_NAME}_model.dart"
import 'package:flutter/foundation.dart';

@immutable
class ${PASCAL_NAME}Item {
  final String id;
  final String baslik;
  final String aciklama;
  final DateTime tarih;

  const ${PASCAL_NAME}Item({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.tarih,
  });

  ${PASCAL_NAME}Item copyWith({
    String? id,
    String? baslik,
    String? aciklama,
    DateTime? tarih,
  }) {
    return ${PASCAL_NAME}Item(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      tarih: tarih ?? this.tarih,
    );
  }

  factory ${PASCAL_NAME}Item.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Item(
      id: json['id'] as String? ?? '',
      baslik: json['baslik'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      tarih: json['tarih'] != null
          ? DateTime.tryParse(json['tarih'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'aciklama': aciklama,
      'tarih': tarih.toIso8601String(),
    };
  }
}
EOF

# 2. MOCK VERİ DOSYASI
cat <<EOF > "$FEATURE_DIR/data/mock_${FEATURE_NAME}_data.dart"
import '../models/${FEATURE_NAME}_model.dart';

final List<${PASCAL_NAME}Item> mock${PASCAL_NAME}Listesi = [
  ${PASCAL_NAME}Item(
    id: '1',
    baslik: 'Örnek ${PASCAL_NAME} 1',
    aciklama: 'Yörünge platformu için örnek mock veri kaydı.',
    tarih: DateTime.now(),
  ),
  ${PASCAL_NAME}Item(
    id: '2',
    baslik: 'Örnek ${PASCAL_NAME} 2',
    aciklama: 'Derin uzay temalı girişimcilik verisi.',
    tarih: DateTime.now().add(const Duration(days: 1)),
  ),
];
EOF

# 3. CONTROLLER DOSYASI
cat <<EOF > "$FEATURE_DIR/controller/${FEATURE_NAME}_controller.dart"
import 'package:flutter/foundation.dart';

import '../data/mock_${FEATURE_NAME}_data.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${PASCAL_NAME}Controller {
  final ValueNotifier<List<${PASCAL_NAME}Item>> liste =
      ValueNotifier<List<${PASCAL_NAME}Item>>(mock${PASCAL_NAME}Listesi);
  final ValueNotifier<bool> yukleniyor = ValueNotifier<bool>(false);

  void ogeEkle(${PASCAL_NAME}Item item) {
    liste.value = [...liste.value, item];
  }

  void ogeSil(String id) {
    liste.value = liste.value.where((e) => e.id != id).toList();
  }

  void dispose() {
    liste.dispose();
    yukleniyor.dispose();
  }
}
EOF

# 4. KART WIDGET DOSYASI
cat <<EOF > "$FEATURE_DIR/widget/${FEATURE_NAME}_card.dart"
import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Item item;
  final VoidCallback? onTap;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.spaceColors;

    return GlowCard(
      onTap: onTap,
      glowColor: colors.nebulaCyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.baslik,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.aciklama,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
EOF

# 5. VIEW DOSYASI
cat <<EOF > "$FEATURE_DIR/view/${FEATURE_NAME}.dart"
import 'package:flutter/material.dart';

import '../../../core/widgets/section_header.dart';
import '../controller/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widget/${FEATURE_NAME}_card.dart';

class ${PASCAL_NAME}View extends StatefulWidget {
  const ${PASCAL_NAME}View({super.key});

  @override
  State<${PASCAL_NAME}View> createState() => _${PASCAL_NAME}ViewState();
}

class _${PASCAL_NAME}ViewState extends State<${PASCAL_NAME}View> {
  late final ${PASCAL_NAME}Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = ${PASCAL_NAME}Controller();
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
        title: Text('${PASCAL_NAME}'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SectionHeader(
              title: '${PASCAL_NAME} Modülü',
              subtitle: 'Yörünge platformu reaktif içerik listesi',
            ),
          ),
          ValueListenableBuilder<List<${PASCAL_NAME}Item>>(
            valueListenable: _controller.liste,
            builder: (context, items, _) {
              if (items.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Kayıt bulunamadı.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = items[index];
                    return ${PASCAL_NAME}Card(item: item);
                  },
                  childCount: items.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
EOF

# 6. BİRİM TEST DOSYASI
cat <<EOF > "$TEST_DIR/${FEATURE_NAME}_controller_test.dart"
import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/${FEATURE_NAME}/controller/${FEATURE_NAME}_controller.dart';
import 'package:yorunge/features/${FEATURE_NAME}/models/${FEATURE_NAME}_model.dart';

void main() {
  group('${PASCAL_NAME}Controller Tests', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta mock veriler yüklenir', () {
      expect(controller.liste.value.isNotEmpty, isTrue);
    });

    test('Yeni öge ekleme ve silme işlemi reaktif olarak çalışır', () {
      final yeniItem = ${PASCAL_NAME}Item(
        id: 'test_99',
        baslik: 'Test Başlığı',
        aciklama: 'Test Açıklaması',
        tarih: DateTime.now(),
      );

      final oncekiSayi = controller.liste.value.length;
      controller.ogeEkle(yeniItem);
      expect(controller.liste.value.length, equals(oncekiSayi + 1));

      controller.ogeSil('test_99');
      expect(controller.liste.value.length, equals(oncekiSayi));
    });
  });
}
EOF

echo "✅ '$FEATURE_NAME' modülü başarıyla oluşturuldu:"
echo "   - $FEATURE_DIR/models/${FEATURE_NAME}_model.dart"
echo "   - $FEATURE_DIR/data/mock_${FEATURE_NAME}_data.dart"
echo "   - $FEATURE_DIR/controller/${FEATURE_NAME}_controller.dart"
echo "   - $FEATURE_DIR/widget/${FEATURE_NAME}_card.dart"
echo "   - $FEATURE_DIR/view/${FEATURE_NAME}.dart"
echo "   - $TEST_DIR/${FEATURE_NAME}_controller_test.dart"
EOF
