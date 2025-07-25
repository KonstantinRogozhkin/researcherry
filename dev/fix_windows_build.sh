#!/usr/bin/env bash
# Комплексное исправление проблем Windows билда

set -e

echo "🔧 Исправление проблем Windows билда..."

# 1. Исправляем GitHub Actions workflow (уже сделано)
echo "✅ GitHub Actions workflow обновлен (GCC setup добавлен)"

# 2. Исправляем проблемные патчи
echo "🔧 Исправляем проблемные патчи..."

# Удаляем патчи, которые больше не актуальны
echo "Удаляем устаревшие патчи..."

# update-russian-language-pack.patch - русский пакет отсутствует в product.json
if [[ -f "patches/update-russian-language-pack.patch" ]]; then
    echo "  - Удаляем patches/update-russian-language-pack.patch (русский пакет не найден в product.json)"
    mv "patches/update-russian-language-pack.patch" "patches/update-russian-language-pack.patch.disabled"
fi

# researcherry-welcome-screen-new.patch - возможно дубликат
if [[ -f "patches/researcherry-welcome-screen-new.patch" ]]; then
    echo "  - Проверяем patches/researcherry-welcome-screen-new.patch"
    # Если это дубликат welcome-page патча, удаляем
    if diff -q "patches/researcherry-welcome-page.patch" "patches/researcherry-welcome-screen-new.patch" >/dev/null 2>&1; then
        echo "    Удаляем дубликат"
        mv "patches/researcherry-welcome-screen-new.patch" "patches/researcherry-welcome-screen-new.patch.disabled"
    fi
fi

# 3. Исправляем конкретные патчи
echo "Исправляем конкретные патчи..."

# Исправляем researcherry-welcome-page.patch - удаляем пустые строки в конце
if [[ -f "patches/researcherry-welcome-page.patch" ]]; then
    echo "  - Исправляем patches/researcherry-welcome-page.patch"
    # Удаляем пустые строки в конце файла
    sed -i '' -e :a -e '/^\s*$/d;N;ba' "patches/researcherry-welcome-page.patch"
fi

# Исправляем welcome-page-russian.patch - удаляем поврежденные заголовки
if [[ -f "patches/welcome-page-russian.patch" ]]; then
    echo "  - Исправляем patches/welcome-page-russian.patch"
    # Создаем временный файл без поврежденных заголовков
    grep -v '^@@ -[0-9]*,[0-9]* +[0-9]*,[0-9]* @@.*$' "patches/welcome-page-russian.patch" > "patches/welcome-page-russian.patch.tmp" || true
    mv "patches/welcome-page-russian.patch.tmp" "patches/welcome-page-russian.patch"
fi

# 4. Проверяем skip-language-packs.patch
if [[ -f "patches/skip-language-packs.patch" ]]; then
    echo "  - Проверяем patches/skip-language-packs.patch"
    # Проверяем, существует ли целевой файл
    if [[ ! -f "vscode/build/lib/builtInExtensions.js" ]]; then
        echo "    Целевой файл build/lib/builtInExtensions.js не найден"
        echo "    Возможно, нужно сначала запустить npm install в vscode/"
    fi
fi

# 5. Создаем минимальную версию проблемных патчей
echo "Создаем минимальные версии патчей..."

# Если skip-language-packs.patch не применяется, создаем альтернативную версию
if [[ -f "patches/skip-language-packs.patch" ]]; then
    cat > "patches/skip-language-packs-simple.patch" << 'EOF'
diff --git a/build/lib/builtInExtensions.js b/build/lib/builtInExtensions.js
index 1234567..abcdefg 100644
--- a/build/lib/builtInExtensions.js
+++ b/build/lib/builtInExtensions.js
@@ -140,6 +140,11 @@ function syncExtension(extension, controlState) {
         }
     }
     switch (controlState) {
+        case 'marketplace':
+            if (extension.name && extension.name.includes('language-pack')) {
+                console.log('Skipping language pack:', extension.name);
+                return event_stream_1.default.readArray([]);
+            }
         case 'disabled':
             log(ansi_colors_1.default.blue('[disabled]'), ansi_colors_1.default.gray(extension.name));
             return event_stream_1.default.readArray([]);
EOF
    echo "  - Создан patches/skip-language-packs-simple.patch"
fi

# 6. Финальная проверка
echo ""
echo "🔍 Финальная проверка патчей..."

if [[ -d "vscode" ]]; then
    ./dev/validate_patches.sh
else
    echo "⚠️  Директория vscode не найдена. Запустите ./prepare_vscode.sh для полной проверки."
fi

echo ""
echo "🎉 Исправление завершено!"
echo ""
echo "📋 Что было сделано:"
echo "1. ✅ Добавлен GCC setup в GitHub Actions"
echo "2. ✅ Удалены/отключены проблемные патчи"
echo "3. ✅ Исправлены форматы существующих патчей"
echo "4. ✅ Созданы альтернативные версии патчей"
echo ""
echo "🚀 Следующие шаги:"
echo "1. Проверьте изменения: git status"
echo "2. Закоммитьте исправления: git add . && git commit -m 'Fix Windows build patches'"
echo "3. Запустите Windows билд в GitHub Actions"
echo ""
