#!/usr/bin/env bash

# Специальный скрипт для разработки Welcome Screen
# Автоматизирует весь цикл: изменение → компиляция → тестирование

set -e

WELCOME_FILE="vscode/src/vs/workbench/contrib/welcomeGettingStarted/common/gettingStartedContent.ts"
PATCH_FILE="patches/researcherry-welcome-page.patch"

echo "🎯 Welcome Screen Development Helper"
echo "=================================="

# Функция для быстрой компиляции и сборки
quick_build() {
    echo "📦 Быстрая пересборка..."
    cd vscode
    
    # Компиляция
    echo "   ⚡ Компиляция TypeScript..."
    npm run gulp compile-build-without-mangling
    
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка компиляции!"
        cd ..
        return 1
    fi
    
    # Сборка для текущей платформы
    echo "   🔨 Сборка приложения..."
    case "$(uname -s)" in
        Darwin*)
            if [[ "$(uname -m)" == "arm64" ]]; then
                npm run gulp "vscode-darwin-arm64-min-ci" > /dev/null 2>&1
                APP_PATH="../VSCode-darwin-arm64/Researcherry.app"
            else
                npm run gulp "vscode-darwin-x64-min-ci" > /dev/null 2>&1
                APP_PATH="../VSCode-darwin-x64/Researcherry.app"
            fi
            ;;
        Linux*)
            npm run gulp "vscode-linux-x64-min-ci" > /dev/null 2>&1
            APP_PATH="../VSCode-linux-x64/bin/researcherry"
            ;;
    esac
    
    cd ..
    
    if [ $? -eq 0 ]; then
        echo "✅ Сборка завершена!"
        return 0
    else
        echo "❌ Ошибка сборки!"
        return 1
    fi
}

# Функция для запуска приложения
launch_app() {
    case "$(uname -s)" in
        Darwin*)
            if [[ "$(uname -m)" == "arm64" ]]; then
                APP_PATH="VSCode-darwin-arm64/Researcherry.app"
            else
                APP_PATH="VSCode-darwin-x64/Researcherry.app"
            fi
            echo "🚀 Запуск приложения..."
            open "$APP_PATH"
            ;;
        Linux*)
            APP_PATH="VSCode-linux-x64/bin/researcherry"
            echo "🚀 Запуск приложения..."
            ./$APP_PATH &
            ;;
    esac
}

# Функция для мониторинга изменений файла
watch_file() {
    echo "👀 Мониторинг изменений в $WELCOME_FILE"
    echo "   💡 Сохраните файл для автоматической пересборки"
    echo "   ⏹️  Нажмите Ctrl+C для остановки"
    echo ""
    
    # Получаем время последнего изменения
    if [[ "$OSTYPE" == "darwin"* ]]; then
        last_modified=$(stat -f %m "$WELCOME_FILE" 2>/dev/null || echo "0")
    else
        last_modified=$(stat -c %Y "$WELCOME_FILE" 2>/dev/null || echo "0")
    fi
    
    while true; do
        sleep 2
        
        # Проверяем время изменения файла
        if [[ "$OSTYPE" == "darwin"* ]]; then
            current_modified=$(stat -f %m "$WELCOME_FILE" 2>/dev/null || echo "0")
        else
            current_modified=$(stat -c %Y "$WELCOME_FILE" 2>/dev/null || echo "0")
        fi
        
        if [ "$current_modified" -gt "$last_modified" ]; then
            echo "📝 Обнаружены изменения! Пересборка..."
            last_modified=$current_modified
            
            if quick_build; then
                echo "✨ Готово! Приложение обновлено."
                echo "   💡 Перезапустите Researcherry чтобы увидеть изменения"
                echo ""
            else
                echo "❌ Ошибка при пересборке"
                echo ""
            fi
        fi
    done
}

# Основное меню
case "${1:-menu}" in
    "build"|"b")
        quick_build
        ;;
    "launch"|"l")
        launch_app
        ;;
    "test"|"t")
        if quick_build; then
            launch_app
        fi
        ;;
    "watch"|"w")
        watch_file
        ;;
    "edit"|"e")
        echo "📝 Открытие файла Welcome Screen для редактирования..."
        if command -v code >/dev/null 2>&1; then
            code "$WELCOME_FILE"
        elif command -v vim >/dev/null 2>&1; then
            vim "$WELCOME_FILE"
        else
            echo "   📁 Файл: $WELCOME_FILE"
        fi
        ;;
    "patch"|"p")
        echo "📋 Информация о патче:"
        echo "   📁 Файл патча: $PATCH_FILE"
        echo "   📏 Размер: $(wc -c < "$PATCH_FILE") байт"
        echo "   📊 Строк: $(wc -l < "$PATCH_FILE")"
        ;;
    *)
        echo "Доступные команды:"
        echo "  build, b    - Быстрая пересборка"
        echo "  launch, l   - Запуск приложения"
        echo "  test, t     - Пересборка + запуск"
        echo "  watch, w    - Автоматическая пересборка при изменениях"
        echo "  edit, e     - Открыть файл для редактирования"
        echo "  patch, p    - Информация о патче"
        echo ""
        echo "Примеры использования:"
        echo "  ./dev/welcome_dev.sh test     # Быстрый тест изменений"
        echo "  ./dev/welcome_dev.sh watch    # Автоматическая пересборка"
        ;;
esac
