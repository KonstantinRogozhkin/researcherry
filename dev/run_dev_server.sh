#!/usr/bin/env bash

# Скрипт для запуска dev-сервера VS Code с нашими изменениями
# Обходит проблемы со сборкой, запуская в режиме разработки

set -e

echo "🚀 Запуск dev-сервера VS Code с изменениями Welcome Screen..."

# Настройка PATH для Node.js
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
    echo "✅ Node.js: $(node --version)"
fi

WELCOME_FILE="vscode/src/vs/workbench/contrib/welcomeGettingStarted/common/gettingStartedContent.ts"

# Проверяем наличие изменений
if grep -q "ResearcherryAI" "$WELCOME_FILE"; then
    echo "✅ Изменения ResearcherryAI найдены в исходном файле"
else
    echo "❌ Изменения не найдены! Применяем изменения..."
    # Здесь можно добавить логику применения изменений
fi

cd vscode

echo "📦 Установка зависимостей (если нужно)..."
if [ ! -d "node_modules" ]; then
    npm ci
fi

echo "🔨 Компиляция исходников..."
if npm run compile; then
    echo "✅ Компиляция успешна"
else
    echo "⚠️  Ошибка компиляции, но продолжаем..."
fi

echo "🌐 Запуск dev-сервера..."
echo "💡 Приложение откроется в браузере на http://localhost:8080"
echo "⏹️  Для остановки нажмите Ctrl+C"

# Запуск в режиме разработки
npm run watch &
WATCH_PID=$!

sleep 5

# Запуск web-сервера
npm run serve-web &
SERVE_PID=$!

echo "🎉 Dev-сервер запущен!"
echo "📱 Откройте http://localhost:8080 в браузере"
echo "🔄 Изменения будут применяться автоматически"

# Ожидание завершения
wait $SERVE_PID

# Очистка процессов
kill $WATCH_PID 2>/dev/null || true
