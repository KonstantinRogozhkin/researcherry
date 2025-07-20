#!/usr/bin/env bash
# Скрипт для обновления иконки Researcherry

set -e

# Проверяем наличие необходимых программ
check_programs() {
  for arg in "$@"; do
    if ! command -v "${arg}" &> /dev/null; then
      echo "${arg} не найден"
      exit 1
    fi
  done
}

check_programs "convert" "png2icns" "icotool"

# Пути к файлам
SOURCE_ICON="icons/researcherry-high-resolution-logo (2).png"
OUTPUT_DIR="icons/output-v2"
QUALITY="stable"
SRC_PREFIX=""

echo "Обновление иконок для Researcherry из исходного PNG-логотипа..."

# Создаем директорию, если она не существует
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/icons"

# Копируем и обрабатываем основную иконку
echo "Создание основной иконки..."
convert "$SOURCE_ICON" -resize 512x512 "$OUTPUT_DIR/icon.png"
convert "$SOURCE_ICON" -resize 256x256 "$OUTPUT_DIR/icons/256x256.png"
convert "$SOURCE_ICON" -resize 128x128 "$OUTPUT_DIR/icons/128x128.png"

# Создаем иконки для macOS
build_darwin_icons() {
  echo "Создание иконок для macOS..."
  
  # Создаем временные файлы разных размеров
  convert "$SOURCE_ICON" -resize 1024x1024 "$OUTPUT_DIR/temp_code_1024.png"
  convert "$SOURCE_ICON" -resize 512x512 "$OUTPUT_DIR/temp_code_512.png"
  convert "$SOURCE_ICON" -resize 256x256 "$OUTPUT_DIR/temp_code_256.png"
  convert "$SOURCE_ICON" -resize 128x128 "$OUTPUT_DIR/temp_code_128.png"

  # Создаем .icns файл
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/darwin"
  png2icns "${SRC_PREFIX}src/${QUALITY}/resources/darwin/code.icns" \
    "$OUTPUT_DIR/temp_code_512.png" "$OUTPUT_DIR/temp_code_256.png" "$OUTPUT_DIR/temp_code_128.png"

  # Удаляем временные файлы
  rm "$OUTPUT_DIR/temp_code_"*.png
  
  echo "Иконки для macOS созданы успешно!"
}

# Создаем иконки для Linux
build_linux_icons() {
  echo "Создание иконок для Linux..."
  
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/linux"
  
  # Создаем иконку для Linux
  convert "$SOURCE_ICON" -resize 512x512 \
    "${SRC_PREFIX}src/${QUALITY}/resources/linux/code.png"
  
  echo "Иконки для Linux созданы успешно!"
}

# Создаем иконки для Windows
build_windows_icons() {
  echo "Создание иконок для Windows..."
  
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/win32"
  
  # Создаем временные файлы разных размеров
  convert "$SOURCE_ICON" -resize 16x16 "$OUTPUT_DIR/temp_code_16.png"
  convert "$SOURCE_ICON" -resize 24x24 "$OUTPUT_DIR/temp_code_24.png"
  convert "$SOURCE_ICON" -resize 32x32 "$OUTPUT_DIR/temp_code_32.png"
  convert "$SOURCE_ICON" -resize 48x48 "$OUTPUT_DIR/temp_code_48.png"
  convert "$SOURCE_ICON" -resize 64x64 "$OUTPUT_DIR/temp_code_64.png"
  convert "$SOURCE_ICON" -resize 128x128 "$OUTPUT_DIR/temp_code_128.png"
  convert "$SOURCE_ICON" -resize 256x256 "$OUTPUT_DIR/temp_code_256.png"
  
  # Создаем .ico файл
  icotool -c -o "${SRC_PREFIX}src/${QUALITY}/resources/win32/code.ico" \
    "$OUTPUT_DIR/temp_code_16.png" "$OUTPUT_DIR/temp_code_24.png" "$OUTPUT_DIR/temp_code_32.png" \
    "$OUTPUT_DIR/temp_code_48.png" "$OUTPUT_DIR/temp_code_64.png" "$OUTPUT_DIR/temp_code_128.png" \
    "$OUTPUT_DIR/temp_code_256.png"
  
  # Удаляем временные файлы
  rm "$OUTPUT_DIR/temp_code_"*.png
  
  echo "Иконки для Windows созданы успешно!"
}

# Запускаем создание иконок
build_darwin_icons
build_linux_icons
build_windows_icons

echo "Все иконки для Researcherry успешно обновлены!"
