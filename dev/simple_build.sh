#!/usr/bin/env bash

# Простая сборка Researcherry для тестирования Welcome Screen
set -e

echo "🚀 Простая сборка Researcherry..."

# Настройка PATH для Node.js
if [ -d "/opt/homebrew/opt/node@22/bin" ]; then
    export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
    echo "✅ Node.js: $(node --version)"
fi

cd vscode

echo "📦 Проверка зависимостей..."
if [ ! -d "node_modules" ]; then
    echo "❌ node_modules не найден. Запустите ./prepare_vscode.sh"
    exit 1
fi

echo "🔨 Компиляция без минификации..."
npm run gulp compile-build-without-mangling

echo "📱 Создание простого приложения..."
# Создаем структуру приложения
APP_DIR="../VSCode-darwin-arm64"
APP_NAME="Researcherry.app"
APP_PATH="$APP_DIR/$APP_NAME"

mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

# Копируем скомпилированные файлы
echo "📂 Копирование файлов..."
cp -r out-build/* "$APP_PATH/Contents/Resources/"

# Создаем Info.plist
cat > "$APP_PATH/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>Researcherry</string>
    <key>CFBundleExecutable</key>
    <string>Researcherry</string>
    <key>CFBundleIdentifier</key>
    <string>com.researcherry.researcherry</string>
    <key>CFBundleName</key>
    <string>Researcherry</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

# Создаем исполняемый файл
cat > "$APP_PATH/Contents/MacOS/Researcherry" << 'EOF'
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESOURCES="$DIR/../Resources"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
cd "$RESOURCES"
node out/main.js "$@"
EOF

chmod +x "$APP_PATH/Contents/MacOS/Researcherry"

echo "✅ Простое приложение создано: $APP_PATH"
echo "🎉 Запуск: open '$APP_PATH'"

cd ..
echo "📍 Путь к приложению: $(pwd)/$APP_DIR/$APP_NAME"
