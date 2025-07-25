#!/usr/bin/env bash

# Исправленный скрипт для разработки Welcome Screen
# Учитывает проблемы с патчами и Node.js

set -e

# Настройка PATH для Node.js (если установлен через Homebrew)
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
elif [ -d "/usr/local/opt/node@22/bin" ]; then
    export PATH="/usr/local/opt/node@22/bin:$PATH"
fi

WELCOME_FILE="vscode/src/vs/workbench/contrib/welcomeGettingStarted/common/gettingStartedContent.ts"
PATCH_FILE="patches/researcherry-welcome-page.patch"

echo "🎯 Welcome Screen Development Helper (Fixed)"
echo "============================================="

# Функция для проверки и настройки окружения
check_environment() {
    echo "🔍 Проверка окружения..."
    
    # Проверяем Node.js
    if ! command -v node >/dev/null 2>&1; then
        echo "❌ Node.js не найден!"
        echo "💡 Попробуйте:"
        echo "   brew install node@22"
        echo "   или установите nvm и выполните: nvm install 22.15.1"
        return 1
    fi
    
    NODE_VERSION=$(node --version)
    echo "✅ Node.js: $NODE_VERSION"
    
    # Проверяем npm
    if ! command -v npm >/dev/null 2>&1; then
        echo "❌ npm не найден!"
        return 1
    fi
    
    NPM_VERSION=$(npm --version)
    echo "✅ npm: $NPM_VERSION"
    
    # Проверяем, применены ли патчи
    if ! grep -q "ResearcherryAI" "$WELCOME_FILE" 2>/dev/null; then
        echo "⚠️  Патчи не применены к Welcome Screen!"
        echo "💡 Нужно запустить: ./prepare_vscode.sh"
        return 2
    fi
    
    echo "✅ Патчи применены"
    return 0
}

# Функция для принудительного применения патча Welcome Screen
apply_welcome_patch() {
    echo "🔧 Применение патча Welcome Screen..."
    
    if [ ! -f "$PATCH_FILE" ]; then
        echo "❌ Файл патча не найден: $PATCH_FILE"
        return 1
    fi
    
    cd vscode
    
    # Пытаемся применить патч
    if git apply "../$PATCH_FILE" 2>/dev/null; then
        echo "✅ Патч применен успешно"
    else
        echo "⚠️  Патч не применился автоматически"
        echo "💡 Возможно, нужно обновить патч или применить вручную"
    fi
    
    cd ..
}

# Функция для быстрой компиляции и сборки
quick_build() {
    echo "📦 Быстрая пересборка..."
    
    # Проверяем окружение
    ENV_CHECK=$(check_environment)
    ENV_CODE=$?
    
    if [ $ENV_CODE -eq 1 ]; then
        echo "$ENV_CHECK"
        return 1
    elif [ $ENV_CODE -eq 2 ]; then
        echo "$ENV_CHECK"
        echo "🔧 Попытка применить патч Welcome Screen..."
        apply_welcome_patch
    fi
    
    cd vscode
    
    # Компиляция
    echo "   ⚡ Компиляция TypeScript..."
    if ! npm run gulp compile-build-without-mangling; then
        echo "❌ Ошибка компиляции!"
        echo "🔍 Проверьте синтаксис в файлах:"
        echo "   - $WELCOME_FILE"
        cd ..
        return 1
    fi
    
    # Сборка для текущей платформы
    echo "   🔨 Сборка приложения..."
    case "$(uname -s)" in
        Darwin*)
            if [[ "$(uname -m)" == "arm64" ]]; then
                if npm run gulp "vscode-darwin-arm64-min-ci"; then
                    APP_PATH="../VSCode-darwin-arm64/Researcherry.app"
                else
                    echo "❌ Ошибка сборки для macOS ARM64"
                    cd ..
                    return 1
                fi
            else
                if npm run gulp "vscode-darwin-x64-min-ci"; then
                    APP_PATH="../VSCode-darwin-x64/Researcherry.app"
                else
                    echo "❌ Ошибка сборки для macOS x64"
                    cd ..
                    return 1
                fi
            fi
            ;;
        Linux*)
            if npm run gulp "vscode-linux-x64-min-ci"; then
                APP_PATH="../VSCode-linux-x64/bin/researcherry"
            else
                echo "❌ Ошибка сборки для Linux"
                cd ..
                return 1
            fi
            ;;
    esac
    
    cd ..
    
    echo "✅ Сборка завершена!"
    return 0
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
            
            if [ -d "$APP_PATH" ]; then
                echo "🚀 Запуск приложения..."
                open "$APP_PATH"
            else
                echo "❌ Приложение не найдено: $APP_PATH"
                echo "💡 Сначала выполните сборку: $0 build"
                return 1
            fi
            ;;
        Linux*)
            APP_PATH="VSCode-linux-x64/bin/researcherry"
            if [ -f "$APP_PATH" ]; then
                echo "🚀 Запуск приложения..."
                ./$APP_PATH &
            else
                echo "❌ Приложение не найдено: $APP_PATH"
                echo "💡 Сначала выполните сборку: $0 build"
                return 1
            fi
            ;;
    esac
}

# Функция для проверки изменений в Welcome Screen
verify_changes() {
    echo "🔍 Проверка применения изменений..."
    
    if grep -q "ResearcherryAI" "$WELCOME_FILE"; then
        echo "✅ Патч Welcome Screen применен"
        
        # Показываем несколько строк с нашими изменениями
        echo "📝 Найденные изменения:"
        grep -n "ResearcherryAI\|Researcherry" "$WELCOME_FILE" | head -3
        
        return 0
    else
        echo "❌ Патч Welcome Screen НЕ применен!"
        echo "💡 Возможные причины:"
        echo "   1. Не запущен ./prepare_vscode.sh"
        echo "   2. Патч не применился из-за конфликтов"
        echo "   3. Файл был перезаписан"
        
        return 1
    fi
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
        if verify_changes && quick_build; then
            launch_app
        else
            echo "❌ Тест не прошел"
            exit 1
        fi
        ;;
    "verify"|"v")
        verify_changes
        ;;
    "check"|"c")
        check_environment
        ;;
    "patch"|"p")
        apply_welcome_patch
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
    *)
        echo "Доступные команды:"
        echo "  build, b    - Быстрая пересборка"
        echo "  launch, l   - Запуск приложения"
        echo "  test, t     - Полный тест (проверка + сборка + запуск)"
        echo "  verify, v   - Проверка применения патчей"
        echo "  check, c    - Проверка окружения"
        echo "  patch, p    - Применить патч Welcome Screen"
        echo "  edit, e     - Открыть файл для редактирования"
        echo ""
        echo "Рекомендуемая последовательность:"
        echo "  1. $0 check     # Проверить окружение"
        echo "  2. $0 verify    # Проверить патчи"
        echo "  3. $0 test      # Полный тест"
        ;;
esac
