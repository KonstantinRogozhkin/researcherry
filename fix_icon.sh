#!/bin/bash

# Путь к исходному изображению
SOURCE_ICON="/Users/konstantin/Projects/researcherry/icons/icon.png"

# Создаем временную директорию для иконок
TEMP_DIR="/tmp/researcherry_icons_fix"
mkdir -p "$TEMP_DIR"

# Создаем набор иконок с помощью sips (встроенный инструмент macOS)
echo "Создаем набор иконок разных размеров..."
SIZES=(16 32 64 128 256 512 1024)
for SIZE in "${SIZES[@]}"; do
  sips -z $SIZE $SIZE "$SOURCE_ICON" --out "$TEMP_DIR/icon_${SIZE}x${SIZE}.png"
done

# Создаем .icns файл с помощью iconutil
echo "Создаем .icns файл..."
mkdir -p "$TEMP_DIR/Researcherry.iconset"
cp "$TEMP_DIR/icon_16x16.png" "$TEMP_DIR/Researcherry.iconset/icon_16x16.png"
cp "$TEMP_DIR/icon_32x32.png" "$TEMP_DIR/Researcherry.iconset/icon_16x16@2x.png"
cp "$TEMP_DIR/icon_32x32.png" "$TEMP_DIR/Researcherry.iconset/icon_32x32.png"
cp "$TEMP_DIR/icon_64x64.png" "$TEMP_DIR/Researcherry.iconset/icon_32x32@2x.png"
cp "$TEMP_DIR/icon_128x128.png" "$TEMP_DIR/Researcherry.iconset/icon_128x128.png"
cp "$TEMP_DIR/icon_256x256.png" "$TEMP_DIR/Researcherry.iconset/icon_128x128@2x.png"
cp "$TEMP_DIR/icon_256x256.png" "$TEMP_DIR/Researcherry.iconset/icon_256x256.png"
cp "$TEMP_DIR/icon_512x512.png" "$TEMP_DIR/Researcherry.iconset/icon_256x256@2x.png"
cp "$TEMP_DIR/icon_512x512.png" "$TEMP_DIR/Researcherry.iconset/icon_512x512.png"
cp "$TEMP_DIR/icon_1024x1024.png" "$TEMP_DIR/Researcherry.iconset/icon_512x512@2x.png"

iconutil -c icns "$TEMP_DIR/Researcherry.iconset" -o "$TEMP_DIR/Researcherry.icns"

# Копируем иконку в приложение
echo "Копируем иконку в приложение..."
cp "$TEMP_DIR/Researcherry.icns" "VSCode-darwin-arm64/Researcherry.app/Contents/Resources/Researcherry.icns"

# Очищаем кеш иконок
echo "Очищаем кеш иконок..."
touch "VSCode-darwin-arm64/Researcherry.app"
touch "VSCode-darwin-arm64/Researcherry.app/Contents/Info.plist"

# Обновляем информацию о приложении
echo "Обновляем информацию о приложении..."
/usr/libexec/PlistBuddy -c "Set :CFBundleIconFile Researcherry.icns" "VSCode-darwin-arm64/Researcherry.app/Contents/Info.plist"

# Перезапускаем Dock для обновления иконок
echo "Перезапускаем Dock..."
killall Dock

echo "Готово! Теперь перезапустите приложение."
