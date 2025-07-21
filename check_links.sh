#!/bin/bash

# Простая проверка внутренних ссылок в markdown файлах
echo "🔍 Проверка внутренних ссылок в документации..."

DOCS_DIR="/Users/konstantin/Projects/researcherry/docs"
BROKEN_LINKS=0

# Функция для проверки существования файла
check_file_exists() {
    local file_path="$1"
    local link_file="$2"
    local line_number="$3"
    
    if [[ ! -f "$file_path" ]]; then
        echo "❌ Битая ссылка в $link_file:$line_number -> $file_path"
        ((BROKEN_LINKS++))
        return 1
    fi
    return 0
}

# Поиск всех markdown ссылок вида [text](./file.md)
find "$DOCS_DIR" -name "*.md" | while read -r file; do
    echo "📄 Проверяем: $(basename "$file")"
    
    # Извлекаем ссылки на локальные markdown файлы
    grep -n "\]\(\./[^)]*\.md[^)]*\)" "$file" | while IFS=: read -r line_num line_content; do
        # Извлекаем путь из ссылки
        link=$(echo "$line_content" | sed -n 's/.*\](\.\([^)]*\.md[^)]*\)).*/\1/p')
        
        if [[ -n "$link" ]]; then
            # Убираем якоря (#section)
            file_path="${link%%#*}"
            full_path="$DOCS_DIR$file_path"
            
            check_file_exists "$full_path" "$file" "$line_num"
        fi
    done
done

if [[ $BROKEN_LINKS -eq 0 ]]; then
    echo "✅ Все внутренние ссылки корректны!"
else
    echo "⚠️  Найдено $BROKEN_LINKS битых ссылок"
fi
