#!/bin/bash

# Путь к исходному изображению
SOURCE_ICON="/Users/konstantin/Projects/researcherry/icons/researcherry-high-resolution-logo (2).png"
OUTPUT_DIR="/Users/konstantin/Projects/researcherry/icons/output-padded"

# Создаем выходную директорию
mkdir -p "$OUTPUT_DIR"

# Создаем изображение с отступами
echo "Создаем изображение с отступами..."
# Сначала создаем пустое изображение 1024x1024
magick -size 1024x1024 xc:none "$OUTPUT_DIR/background.png"

# Изменяем размер исходного изображения до 820x820 (примерно 80% от 1024)
# Это создаст отступ примерно 10% с каждой стороны
echo "Изменяем размер исходного изображения..."
magick "$SOURCE_ICON" -resize 820x820 "$OUTPUT_DIR/resized.png"

# Объединяем изображения, размещая уменьшенное изображение по центру
echo "Размещаем изображение по центру с отступами..."
magick "$OUTPUT_DIR/background.png" "$OUTPUT_DIR/resized.png" -gravity center -composite "$OUTPUT_DIR/padded.png"

# Создаем круглую маску
echo "Создаем круглую маску..."
magick -size 1024x1024 xc:none -fill white -draw "roundrectangle 0,0 1024,1024 200,200" "$OUTPUT_DIR/round_mask.png"

# Применяем маску к изображению с отступами
echo "Применяем маску к изображению..."
magick "$OUTPUT_DIR/padded.png" "$OUTPUT_DIR/round_mask.png" -compose CopyOpacity -composite "$OUTPUT_DIR/icon.png"

# Создаем набор иконок с помощью electron-icon-builder
echo "Создаем набор иконок..."
electron-icon-builder --input="$OUTPUT_DIR/icon.png" --output="$OUTPUT_DIR"

# Обновляем скрипт update_icon.sh для использования новых иконок
echo "Обновляем скрипт update_icon.sh..."
sed -i '' "s|ICONS_DIR=.*|ICONS_DIR=\"$OUTPUT_DIR/icons\"|" update_icon.sh

# Запускаем скрипт update_icon.sh для применения новых иконок
echo "Применяем новые иконки..."
./update_icon.sh

echo "Готово! Новая иконка с отступами создана и применена к приложению."
echo "Теперь перезапустите приложение и Dock для обновления иконки."
echo "killall Dock"
