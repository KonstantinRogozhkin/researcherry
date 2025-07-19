#!/bin/bash

# Путь к исходному изображению и шаблону
SOURCE_ICON="/Users/konstantin/Projects/researcherry/icons/researcherry-high-resolution-logo (1).png"
OUTPUT_DIR="/Users/konstantin/Projects/researcherry/icons/masked_simple"

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

echo "Готово! Маскированная иконка создана в $OUTPUT_DIR/icon.png"
