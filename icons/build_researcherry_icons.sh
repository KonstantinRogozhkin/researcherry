#!/usr/bin/env bash
# Скрипт для создания иконок Researcherry из PNG-логотипа

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
PNG_LOGO="icons/re-high-resolution-logo.png"
PNG_LOGO_TRANSPARENT="icons/re-high-resolution-logo-transparent.png"
QUALITY="stable"
SRC_PREFIX=""

echo "Создание иконок для Researcherry из PNG-логотипа..."

# Создаем иконки для macOS
build_darwin_icons() {
  echo "Создание иконок для macOS..."
  
  # Создаем временные файлы разных размеров
  convert "$PNG_LOGO" -resize 1024x1024 "icons/temp_code_1024.png"
  convert "$PNG_LOGO" -resize 512x512 "icons/temp_code_512.png"
  convert "$PNG_LOGO" -resize 256x256 "icons/temp_code_256.png"
  convert "$PNG_LOGO" -resize 128x128 "icons/temp_code_128.png"

  # Создаем .icns файл
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/darwin"
  png2icns "${SRC_PREFIX}src/${QUALITY}/resources/darwin/code.icns" \
    icons/temp_code_512.png icons/temp_code_256.png icons/temp_code_128.png

  # Удаляем временные файлы
  rm icons/temp_code_*.png
  
  echo "Иконки для macOS созданы успешно!"
}

# Создаем иконки для Linux
build_linux_icons() {
  echo "Создание иконок для Linux..."
  
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/linux"
  
  # Создаем иконки разных размеров
  for size in 16 24 32 48 64 128 256 512 1024; do
    convert "$PNG_LOGO" -resize ${size}x${size} \
      "${SRC_PREFIX}src/${QUALITY}/resources/linux/code.png"
  done
  
  echo "Иконки для Linux созданы успешно!"
}

# Создаем иконки для Windows
build_windows_icons() {
  echo "Создание иконок для Windows..."
  
  mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/win32"
  
  # Создаем временные файлы разных размеров
  convert "$PNG_LOGO" -resize 16x16 "icons/temp_code_16.png"
  convert "$PNG_LOGO" -resize 24x24 "icons/temp_code_24.png"
  convert "$PNG_LOGO" -resize 32x32 "icons/temp_code_32.png"
  convert "$PNG_LOGO" -resize 48x48 "icons/temp_code_48.png"
  convert "$PNG_LOGO" -resize 64x64 "icons/temp_code_64.png"
  convert "$PNG_LOGO" -resize 128x128 "icons/temp_code_128.png"
  convert "$PNG_LOGO" -resize 256x256 "icons/temp_code_256.png"
  
  # Создаем .ico файл
  icotool -c -o "${SRC_PREFIX}src/${QUALITY}/resources/win32/code.ico" \
    icons/temp_code_16.png icons/temp_code_24.png icons/temp_code_32.png \
    icons/temp_code_48.png icons/temp_code_64.png icons/temp_code_128.png \
    icons/temp_code_256.png
  
  # Удаляем временные файлы
  rm icons/temp_code_*.png
  
  echo "Иконки для Windows созданы успешно!"
}

# Запускаем создание иконок
build_darwin_icons
build_linux_icons
build_windows_icons

echo "Все иконки для Researcherry успешно созданы!"
