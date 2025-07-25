#!/usr/bin/env bash
# Скрипт для валидации всех патчей

set -e

echo "🔍 Проверка всех патчей..."

# Убеждаемся, что мы в корневой директории проекта
if [[ ! -d "patches" ]]; then
    echo "❌ Директория patches не найдена. Запустите скрипт из корня проекта."
    exit 1
fi

# Убеждаемся, что vscode директория существует
if [[ ! -d "vscode" ]]; then
    echo "❌ Директория vscode не найдена. Сначала запустите ./prepare_vscode.sh"
    exit 1
fi

cd vscode

# Сбрасываем все изменения
git reset --hard HEAD
git clean -fd

echo "Проверяем патчи по одному..."

failed_patches=()
successful_patches=()

# Проверяем каждый патч
for patch_file in ../patches/*.patch; do
    if [[ -f "$patch_file" ]]; then
        patch_name=$(basename "$patch_file")
        echo -n "Проверяем $patch_name... "
        
        if git apply --check "$patch_file" 2>/dev/null; then
            echo "✅"
            successful_patches+=("$patch_name")
            # Применяем патч для проверки следующих
            git apply "$patch_file" 2>/dev/null || true
        else
            echo "❌"
            failed_patches+=("$patch_name")
        fi
    fi
done

cd ..

echo ""
echo "📊 Результаты проверки:"
echo "✅ Успешных патчей: ${#successful_patches[@]}"
echo "❌ Поврежденных патчей: ${#failed_patches[@]}"

if [[ ${#failed_patches[@]} -gt 0 ]]; then
    echo ""
    echo "🚨 Поврежденные патчи:"
    for patch in "${failed_patches[@]}"; do
        echo "  - $patch"
    done
    echo ""
    echo "Для исправления запустите: ./dev/fix_patches.sh"
    exit 1
else
    echo ""
    echo "🎉 Все патчи корректны!"
fi
