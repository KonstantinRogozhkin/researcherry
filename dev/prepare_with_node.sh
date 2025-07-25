#!/usr/bin/env bash

# Скрипт для подготовки VSCode с правильным PATH для Node.js

set -e

echo "🔧 Подготовка VSCode с настройкой Node.js..."

# Настройка PATH для Node.js
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
    echo "✅ Настроен PATH для Node.js: $(node --version)"
elif [ -d "/usr/local/opt/node@22/bin" ]; then
    export PATH="/usr/local/opt/node@22/bin:$PATH"
    echo "✅ Настроен PATH для Node.js: $(node --version)"
else
    echo "⚠️  Node.js не найден в стандартных путях Homebrew"
fi

# Запуск оригинального скрипта подготовки
echo "🚀 Запуск prepare_vscode.sh..."
./prepare_vscode.sh
