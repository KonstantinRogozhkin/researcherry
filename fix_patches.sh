#!/usr/bin/env bash
# Скрипт для исправления проблемных патчей

set -e

echo "🔧 Исправление проблемных патчей..."

# Переходим в директорию проекта
cd "$(dirname "$0")"

# Удаляем проблемные или несуществующие патчи
PROBLEMATIC_PATCHES=(
    "patches/add-russian-pack.patch"
    "patches/force-russian-locale.patch" 
    "patches/profiles-feature.patch"
    "patches/profiles.patch"
)

for patch in "${PROBLEMATIC_PATCHES[@]}"; do
    if [ -f "$patch" ]; then
        echo "🗑️  Удаляем проблемный патч: $patch"
        rm "$patch"
    else
        echo "ℹ️  Патч не найден (это нормально): $patch"
    fi
done

# Проверяем и исправляем поврежденные патчи
echo "🔍 Проверяем существующие патчи..."

# Создаем резервные копии важных патчей
IMPORTANT_PATCHES=(
    "patches/brand.patch"
    "patches/researcherry-welcome-page.patch"
    "patches/welcome-page-russian.patch"
)

for patch in "${IMPORTANT_PATCHES[@]}"; do
    if [ -f "$patch" ]; then
        echo "💾 Создаем резервную копию: $patch"
        cp "$patch" "$patch.backup"
    fi
done

# Очищаем директорию vscode от конфликтов
if [ -d "vscode" ]; then
    echo "🧹 Очищаем директорию vscode от конфликтов..."
    cd vscode
    
    # Удаляем файлы с расширением .rej (отклоненные изменения)
    find . -name "*.rej" -delete 2>/dev/null || true
    find . -name "*.orig" -delete 2>/dev/null || true
    
    # Сбрасываем все изменения
    git add . 2>/dev/null || true
    git reset --hard HEAD 2>/dev/null || true
    
    cd ..
fi

echo "✅ Исправление патчей завершено!"
echo ""
echo "Теперь можно попробовать запустить:"
echo "  ./dev/update_patches.sh"
echo ""
echo "Если проблемы остаются, попробуйте:"
echo "  ./prepare_vscode.sh  # для полной переустановки"
