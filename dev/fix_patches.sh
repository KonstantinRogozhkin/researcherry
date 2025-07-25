#!/usr/bin/env bash
# Скрипт для исправления поврежденных патчей

set -e

echo "🔧 Исправление поврежденных патчей..."

# Функция для проверки и исправления патча
fix_patch() {
    local patch_file="$1"
    local patch_name=$(basename "$patch_file")
    
    echo "Проверяем патч: $patch_name"
    
    # Проверяем, что патч применяется без ошибок
    cd vscode
    if git apply --check "../$patch_file" 2>/dev/null; then
        echo "  ✅ Патч $patch_name корректен"
        cd ..
        return 0
    else
        echo "  ❌ Патч $patch_name поврежден"
        cd ..
        return 1
    fi
}

# Функция для пересоздания патча из текущих изменений
regenerate_patch() {
    local patch_file="$1"
    local patch_name=$(basename "$patch_file")
    
    echo "Пересоздаем патч: $patch_name"
    
    cd vscode
    
    # Создаем бэкап старого патча
    cp "../$patch_file" "../$patch_file.backup"
    
    # Генерируем новый патч из текущих изменений
    git diff > "../$patch_file.new"
    
    if [[ -s "../$patch_file.new" ]]; then
        mv "../$patch_file.new" "../$patch_file"
        echo "  ✅ Патч $patch_name пересоздан"
    else
        echo "  ⚠️  Нет изменений для патча $patch_name"
        mv "../$patch_file.backup" "../$patch_file"
        rm -f "../$patch_file.new"
    fi
    
    cd ..
}

# Основная логика
main() {
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
    
    # Список проблемных патчей из ошибки
    local problematic_patches=(
        "patches/researcherry-welcome-page.patch"
        "patches/skip-language-packs.patch"
        "patches/update-russian-language-pack.patch"
        "patches/welcome-page-russian.patch"
    )
    
    echo "Проверяем проблемные патчи..."
    
    for patch_file in "${problematic_patches[@]}"; do
        if [[ -f "$patch_file" ]]; then
            if ! fix_patch "$patch_file"; then
                echo "Исправляем патч: $patch_file"
                
                # Специальные исправления для известных проблем
                case "$patch_file" in
                    "patches/researcherry-welcome-page.patch")
                        # Удаляем пустую строку в конце
                        sed -i '' '/^$/d' "$patch_file"
                        ;;
                    "patches/welcome-page-russian.patch")
                        # Удаляем поврежденные заголовки патчей из середины файла
                        sed -i '' '/^@@ -[0-9]*,[0-9]* +[0-9]*,[0-9]* @@.*$/d' "$patch_file"
                        ;;
                esac
                
                # Проверяем еще раз после исправления
                if fix_patch "$patch_file"; then
                    echo "  ✅ Патч $patch_file исправлен"
                else
                    echo "  ⚠️  Патч $patch_file требует ручного исправления"
                fi
            fi
        else
            echo "  ⚠️  Файл $patch_file не найден"
        fi
    done
    
    echo ""
    echo "🎉 Проверка патчей завершена!"
    echo ""
    echo "Следующие шаги:"
    echo "1. Проверьте исправленные патчи: git diff patches/"
    echo "2. Если нужно, запустите: ./dev/build.sh"
    echo "3. Или протестируйте в GitHub Actions"
}

main "$@"
