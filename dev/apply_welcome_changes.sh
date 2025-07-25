#!/usr/bin/env bash

# Скрипт для прямого применения изменений Welcome Screen
# Обходит проблемы с системой сборки

set -e

echo "🔧 Применение изменений Welcome Screen напрямую..."

# Настройка PATH для Node.js
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
fi

WELCOME_FILE="vscode/src/vs/workbench/contrib/welcomeGettingStarted/common/gettingStartedContent.ts"

# Проверяем, что наши изменения есть в файле
if grep -q "ResearcherryAI" "$WELCOME_FILE"; then
    echo "✅ Изменения найдены в исходном файле"
else
    echo "❌ Изменения не найдены в исходном файле!"
    exit 1
fi

# Удаляем старое приложение
echo "🗑️  Удаление старого приложения..."
rm -rf VSCode-darwin-arm64

# Пытаемся собрать новое приложение с обходом проблем
echo "🔨 Попытка сборки с обходом проблем..."

cd vscode

# Создаем временный .npmrc с нужными параметрами
echo "📝 Создание временного .npmrc..."
cp .npmrc .npmrc.backup

cat > .npmrc << EOF
build_from_source="true"
legacy-peer-deps="true"
timeout=180000
target="34.5.4"
ms_build_id="0"
EOF

# Пытаемся собрать
echo "🚀 Запуск сборки..."
if npm run gulp "vscode-darwin-arm64-min-ci"; then
    echo "✅ Сборка успешна!"
    
    # Восстанавливаем оригинальный .npmrc
    mv .npmrc.backup .npmrc
    
    cd ..
    
    # Проверяем результат
    if [ -d "VSCode-darwin-arm64/Researcherry.app" ]; then
        echo "🎉 Приложение собрано успешно!"
        echo "📱 Запуск приложения..."
        open "VSCode-darwin-arm64/Researcherry.app"
    else
        echo "❌ Приложение не найдено после сборки"
        exit 1
    fi
else
    echo "❌ Ошибка сборки"
    
    # Восстанавливаем оригинальный .npmrc
    mv .npmrc.backup .npmrc
    
    cd ..
    
    echo "💡 Попробуем альтернативный подход..."
    echo "🔄 Используем существующее приложение и попробуем горячую замену..."
    
    # Если есть старое приложение, попробуем его запустить
    if [ -d "VSCode-darwin-arm64/Researcherry.app" ]; then
        echo "📱 Запуск существующего приложения..."
        open "VSCode-darwin-arm64/Researcherry.app"
        
        echo ""
        echo "⚠️  ВНИМАНИЕ: Приложение может содержать старый контент"
        echo "💡 Для применения изменений нужно решить проблемы сборки"
        echo "🔧 Попробуйте обновить зависимости или использовать другую версию Node.js"
    else
        echo "❌ Нет рабочего приложения для запуска"
        exit 1
    fi
fi
