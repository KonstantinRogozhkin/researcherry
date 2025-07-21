#!/usr/bin/env bash
# Скрипт для полного сброса и пересоздания проекта

set -e

echo "🔄 Полный сброс проекта Researcherry..."

# Переходим в директорию проекта
cd "$(dirname "$0")"

# Удаляем директорию vscode, если она существует
if [ -d "vscode" ]; then
    echo "🗑️  Удаляем старую директорию vscode..."
    rm -rf vscode
fi

# Удаляем директории сборки, если они существуют
echo "🧹 Очищаем директории сборки..."
rm -rf VSCode-*
rm -rf .build

# Проверяем поврежденные патчи
echo "🔍 Проверяем патчи на повреждения..."

PATCHES_DIR="patches"
CORRUPTED_PATCHES=()

for patch_file in "$PATCHES_DIR"/*.patch; do
    if [ -f "$patch_file" ]; then
        # Проверяем, не поврежден ли патч
        if ! git apply --check --ignore-whitespace "$patch_file" 2>/dev/null; then
            # Дополнительная проверка на корректность формата
            if grep -q "^diff --git" "$patch_file" && grep -q "^@@" "$patch_file"; then
                echo "⚠️  Патч может иметь конфликты: $(basename "$patch_file")"
            else
                echo "❌ Поврежденный патч: $(basename "$patch_file")"
                CORRUPTED_PATCHES+=("$patch_file")
            fi
        else
            echo "✅ Патч корректен: $(basename "$patch_file")"
        fi
    fi
done

# Создаем резервные копии поврежденных патчей
if [ ${#CORRUPTED_PATCHES[@]} -gt 0 ]; then
    echo "💾 Создаем резервные копии поврежденных патчей..."
    mkdir -p patches/backup
    for patch in "${CORRUPTED_PATCHES[@]}"; do
        cp "$patch" "patches/backup/$(basename "$patch").backup"
        echo "   Резервная копия: patches/backup/$(basename "$patch").backup"
    done
fi

echo ""
echo "✅ Сброс завершен!"
echo ""
echo "Теперь запустите:"
echo "  ./prepare_vscode.sh  # для загрузки чистого VSCode и применения патчей"
echo ""
echo "Если проблемы с патчами остаются, проверьте директорию patches/backup/"
