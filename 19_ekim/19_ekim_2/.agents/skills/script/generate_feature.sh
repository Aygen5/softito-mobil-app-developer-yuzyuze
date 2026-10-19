#!/usr/bin/env bash
# Yeni bir feature klasör yapısını otomatik oluşturan betik
set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "Hata: Lütfen bir feature adı girin (Örn: ./generate_feature.sh sleep_tracker)"
  exit 1
fi

BASE_DIR="../../lib/features/$FEATURE_NAME"

mkdir -p "$BASE_DIR/controller"
mkdir -p "$BASE_DIR/models"
mkdir -p "$BASE_DIR/view"
mkdir -p "$BASE_DIR/widget"

echo "✅ Feature yapısı oluşturuldu: $BASE_DIR"
