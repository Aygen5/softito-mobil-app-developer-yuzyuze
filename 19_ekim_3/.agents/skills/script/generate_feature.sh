#!/usr/bin/env bash
# ==============================================================================
# generate_feature.sh
# Flutter Feature Scaffold Otomasyon Betiği
#
# Standartlar: project.md ve SKILLS.md kurallarına tam uyumlu özellik (feature)
# klasör ve şablon dosyalarını otomatik üretir.
# ==============================================================================

set -e

# Kullanım kontrolü
if [ -z "$1" ]; then
  echo "❌ Hata: Lütfen bir feature adı belirtin."
  echo "Kullanım: ./generate_feature.sh <feature_name> [--no-files]"
  echo "Örnek:   ./generate_feature.sh sleep_tracker"
  echo "         ./generate_feature.sh beverage_tracker"
  exit 1
fi

FEATURE_NAME="$1"
CREATE_FILES=true

if [ "$2" == "--no-files" ]; then
  CREATE_FILES=false
fi

# snake_case -> PascalCase dönüştürücü
to_pascal_case() {
  echo "$1" | awk -F '_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS=''
}

CLASS_NAME=$(to_pascal_case "$FEATURE_NAME")

# Hedef dizini tespit et (Betiğin çalıştırıldığı konuma göre dinamik ayar)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# lib/features yolunu bul
if [ -d "$SCRIPT_DIR/../../../../lib" ]; then
  BASE_DIR="$SCRIPT_DIR/../../../../lib/features/$FEATURE_NAME"
elif [ -d "$SCRIPT_DIR/../../../lib" ]; then
  BASE_DIR="$SCRIPT_DIR/../../../lib/features/$FEATURE_NAME"
elif [ -d "./lib" ]; then
  BASE_DIR="./lib/features/$FEATURE_NAME"
else
  # Varsayılan bağıl konum
  BASE_DIR="../../lib/features/$FEATURE_NAME"
fi

echo "🚀 Feature oluşturuluyor: $FEATURE_NAME ($CLASS_NAME)"
echo "📂 Hedef Dizin: $BASE_DIR"

# 1. Klasör yapısını oluştur
mkdir -p "$BASE_DIR/controller"
mkdir -p "$BASE_DIR/models"
mkdir -p "$BASE_DIR/view"
mkdir -p "$BASE_DIR/widget"

echo "  📁 controller/"
echo "  📁 models/"
echo "  📁 view/"
echo "  📁 widget/"

# 2. Şablon dosyaları üret
if [ "$CREATE_FILES" = true ]; then

  # CONTROLLER DOSYASI
  CONTROLLER_FILE="$BASE_DIR/controller/${FEATURE_NAME}_controller.dart"
  if [ ! -f "$CONTROLLER_FILE" ]; then
    cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

/// [$CLASS_NAME Controller]
///
/// Reaktif durum yönetimi: ValueNotifier & ChangeNotifier
class ${CLASS_NAME}Controller extends ChangeNotifier {
  final ValueNotifier<int> counterNotifier = ValueNotifier<int>(0);
  final List<${CLASS_NAME}Model> _items = [];

  List<${CLASS_NAME}Model> get items => List.unmodifiable(_items);
  int get count => counterNotifier.value;

  void increment() {
    counterNotifier.value++;
    notifyListeners();
  }

  void reset() {
    counterNotifier.value = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    counterNotifier.dispose();
    super.dispose();
  }
}
EOF
    echo "  📄 $CONTROLLER_FILE (Oluşturuldu)"
  fi

  # MODEL DOSYASI
  MODEL_FILE="$BASE_DIR/models/${FEATURE_NAME}_model.dart"
  if [ ! -f "$MODEL_FILE" ]; then
    cat <<EOF > "$MODEL_FILE"
/// [$CLASS_NAME Model]
///
/// Immutable veri modeli: copyWith, fromJson ve toJson desteği
class ${CLASS_NAME}Model {
  final String id;
  final String title;
  final DateTime createdAt;

  const ${CLASS_NAME}Model({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  ${CLASS_NAME}Model copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return ${CLASS_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ${CLASS_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${CLASS_NAME}Model(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
EOF
    echo "  📄 $MODEL_FILE (Oluşturuldu)"
  fi

  # VIEW DOSYASI
  VIEW_FILE="$BASE_DIR/view/${FEATURE_NAME}_view.dart"
  if [ ! -f "$VIEW_FILE" ]; then
    cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controller/${FEATURE_NAME}_controller.dart';
import '../widget/${FEATURE_NAME}_card.dart';

/// [$CLASS_NAME View]
///
/// StatelessWidget + ListenableBuilder (Sayfa düzeyinde setState KULLANILMAZ)
/// Build metodu 40 satır kuralına uygundur.
class ${CLASS_NAME}View extends StatelessWidget {
  final ${CLASS_NAME}Controller controller;

  const ${CLASS_NAME}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$CLASS_NAME'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ${CLASS_NAME}Card(
                    title: '$CLASS_NAME Durumu',
                    count: controller.count,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.increment,
                    child: const Text('Artır'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
EOF
    echo "  📄 $VIEW_FILE (Oluşturuldu)"
  fi

  # WIDGET DOSYASI
  WIDGET_FILE="$BASE_DIR/widget/${FEATURE_NAME}_card.dart"
  if [ ! -f "$WIDGET_FILE" ]; then
    cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';

/// [${CLASS_NAME}Card]
///
/// Modüler UI bileşeni (Build metodu 40 satırın altındadır)
class ${CLASS_NAME}Card extends StatelessWidget {
  final String title;
  final int count;

  const ${CLASS_NAME}Card({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '\$count',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF
    echo "  📄 $WIDGET_FILE (Oluşturuldu)"
  fi

fi

echo ""
echo "✅ Feature başarıyla oluşturuldu: $BASE_DIR"
echo "📌 Şimdi 'flutter analyze' ile statik kod analizini kontrol edebilirsin."
