#!/bin/bash

# Путь к исходному изображению
SOURCE_ICON="/Users/konstantin/Projects/researcherry/icons/researcherry-high-resolution-logo (2).png"
OUTPUT_DIR="/Users/konstantin/Projects/researcherry/icons/output-v2"

# Создаем выходную директорию
mkdir -p "$OUTPUT_DIR"

# Создаем круглую маску
echo "Создаем круглую маску..."
magick -size 1024x1024 xc:none -fill white -draw "roundrectangle 0,0 1024,1024 200,200" "$OUTPUT_DIR/round_mask.png"

# Изменяем размер исходного изображения до 1024x1024
echo "Изменяем размер исходного изображения..."
magick "$SOURCE_ICON" -resize 1024x1024 "$OUTPUT_DIR/resized.png"

# Применяем маску к изображению
echo "Применяем маску к изображению..."
magick "$OUTPUT_DIR/resized.png" "$OUTPUT_DIR/round_mask.png" -compose CopyOpacity -composite "$OUTPUT_DIR/icon.png"

# Создаем набор иконок с помощью electron-icon-builder
echo "Создаем набор иконок..."
electron-icon-builder --input="$OUTPUT_DIR/icon.png" --output="$OUTPUT_DIR"

# Обновляем скрипт update_icon.sh для использования новых иконок
echo "Обновляем скрипт update_icon.sh..."
sed -i '' "s|ICONS_DIR=.*|ICONS_DIR=\"$OUTPUT_DIR/icons\"|" update_icon.sh

# Запускаем скрипт update_icon.sh для применения новых иконок
echo "Применяем новые иконки..."
./update_icon.sh

echo "Готово! Новая иконка создана и применена к приложению."
echo "Теперь перезапустите приложение и Dock для обновления иконки."
echo "killall Dock"
