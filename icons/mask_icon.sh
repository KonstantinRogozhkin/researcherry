#!/bin/bash

# Путь к исходному изображению и шаблону
SOURCE_ICON="/Users/konstantin/Projects/researcherry/icons/researcherry-high-resolution-logo (1).png"
TEMPLATE="/Users/konstantin/Projects/researcherry/icons/template_macos.png"
OUTPUT_DIR="/Users/konstantin/Projects/researcherry/icons/masked_new"

# Создаем выходную директорию
mkdir -p "$OUTPUT_DIR"

# Изменяем размер исходного изображения до 1024x1024
echo "Изменяем размер исходного изображения..."
magick "$SOURCE_ICON" -resize 1024x1024 "$OUTPUT_DIR/resized.png"

# Создаем маску из шаблона macOS
echo "Создаем маску из шаблона macOS..."
magick "$TEMPLATE" -alpha extract "$OUTPUT_DIR/mask.png"

# Применяем маску к изображению
echo "Применяем маску к изображению..."
magick "$OUTPUT_DIR/resized.png" "$OUTPUT_DIR/mask.png" -compose CopyOpacity -composite "$OUTPUT_DIR/icon.png"

echo "Готово! Маскированная иконка создана в $OUTPUT_DIR/icon.png"
