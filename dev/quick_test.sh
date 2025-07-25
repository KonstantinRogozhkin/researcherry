#!/usr/bin/env bash

# Быстрый скрипт для тестирования изменений Welcome Screen
# Основан на процессе из dev.md - быстрая пересборка без полного билда

set -e

echo "🚀 Быстрое тестирование изменений Welcome Screen..."

# Переходим в папку с кодом VSCode
cd vscode

echo "📦 Запуск быстрой компиляции (без полной сборки)..."
# Самая быстрая команда для проверки компиляции
npm run gulp compile-build-without-mangling

if [ $? -eq 0 ]; then
    echo "✅ Компиляция прошла успешно!"
    
    echo "🔨 Запуск сборки для текущей платформы..."
    
    # Определяем платформу и запускаем соответствующую сборку
    case "$(uname -s)" in
        Darwin*)
            if [[ "$(uname -m)" == "arm64" ]]; then
                echo "🍎 Сборка для macOS ARM64..."
                npm run gulp "vscode-darwin-arm64-min-ci"
            else
                echo "🍎 Сборка для macOS x64..."
                npm run gulp "vscode-darwin-x64-min-ci"
            fi
            ;;
        Linux*)
            echo "🐧 Сборка для Linux..."
            npm run gulp "vscode-linux-x64-min-ci"
            ;;
        *)
            echo "❌ Неподдерживаемая платформа: $(uname -s)"
            exit 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo "✅ Сборка завершена успешно!"
        echo ""
        echo "🎉 Готово! Теперь можно тестировать изменения:"
        
        # Возвращаемся в корневую папку
        cd ..
        
        # Показываем путь к собранному приложению
        case "$(uname -s)" in
            Darwin*)
                if [[ "$(uname -m)" == "arm64" ]]; then
                    APP_PATH="VSCode-darwin-arm64/Researcherry.app"
                else
                    APP_PATH="VSCode-darwin-x64/Researcherry.app"
                fi
                echo "📱 Запустить приложение: open \"$APP_PATH\""
                ;;
            Linux*)
                APP_PATH="VSCode-linux-x64/bin/researcherry"
                echo "📱 Запустить приложение: ./$APP_PATH"
                ;;
        esac
        
        echo ""
        echo "💡 Для следующих изменений просто запустите этот скрипт снова!"
        
    else
        echo "❌ Ошибка при сборке!"
        exit 1
    fi
else
    echo "❌ Ошибка компиляции!"
    echo "🔍 Проверьте синтаксис в измененных файлах"
    exit 1
fi
