#!/bin/bash

# Используем готовые иконки, созданные с помощью electron-icon-builder
ICONS_DIR="/Users/konstantin/Projects/researcherry/icons/output-padded/icons"
ICNS_FILE="$ICONS_DIR/mac/icon.icns"
ICO_FILE="$ICONS_DIR/win/icon.ico"

# Проверяем наличие файлов иконок
if [ ! -f "$ICNS_FILE" ]; then
  echo "Ошибка: Файл иконки $ICNS_FILE не найден!"
  exit 1
fi

# Копируем иконку в приложение
echo "Копируем иконку в приложение..."
cp "$ICNS_FILE" "VSCode-darwin-arm64/Researcherry.app/Contents/Resources/Researcherry.icns"

# Копируем иконку для Windows (на будущее)
if [ -d "vscode/resources/win32" ]; then
  echo "Копируем иконку для Windows..."
  cp "$ICO_FILE" "vscode/resources/win32/Researcherry.ico"
fi

# Копируем иконку для Linux (на будущее)
if [ -d "vscode/resources/linux" ]; then
  echo "Копируем иконку для Linux..."
  cp "$ICONS_DIR/png/1024x1024.png" "vscode/resources/linux/Researcherry.png"
fi

# Очищаем кеш иконок
echo "Очищаем кеш иконок..."
touch "VSCode-darwin-arm64/Researcherry.app"

# Обновляем информацию о приложении
echo "Обновляем информацию о приложении..."
/usr/libexec/PlistBuddy -c "Set :CFBundleIconFile Researcherry.icns" "VSCode-darwin-arm64/Researcherry.app/Contents/Info.plist"

echo "Готово! Теперь перезапустите приложение."
