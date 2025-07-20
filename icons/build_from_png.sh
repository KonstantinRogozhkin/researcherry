#!/usr/bin/env bash
# Скрипт для создания иконок Researcherry из PNG-логотипа

set -e

# Включаем отладку
set -x

# Определяем текущую директорию скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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

# Загружаем утилиты и переменные
. ../utils.sh

# Пути к файлам
PNG_LOGO="$SCRIPT_DIR/researcherry-high-resolution-logo (2).png"
QUALITY="stable"
ROOT_DIR="$SCRIPT_DIR/.."
TEMP_DIR="$SCRIPT_DIR/temp"

# Создаем временную директорию
mkdir -p "$TEMP_DIR"

echo "Создание иконок для ${APP_NAME} из PNG-логотипа..."

# Создаем необходимые директории
mkdir -p "$ROOT_DIR/src/$QUALITY/resources/darwin"
mkdir -p "$ROOT_DIR/src/$QUALITY/resources/linux/rpm"
mkdir -p "$ROOT_DIR/src/$QUALITY/resources/win32"
mkdir -p "$ROOT_DIR/src/$QUALITY/resources/server"
mkdir -p "$ROOT_DIR/src/$QUALITY/src/vs/workbench/browser/media"
mkdir -p "$ROOT_DIR/build/windows/msi/resources/$QUALITY"

# Создаем иконки для macOS
build_darwin_icons() {
  echo "Создание иконок для macOS..."
  
  # Создаем временные файлы разных размеров
  convert "$PNG_LOGO" -resize 1024x1024 "$TEMP_DIR/temp_code_1024.png"
  convert "$PNG_LOGO" -resize 512x512 "$TEMP_DIR/temp_code_512.png"
  convert "$PNG_LOGO" -resize 256x256 "$TEMP_DIR/temp_code_256.png"
  convert "$PNG_LOGO" -resize 128x128 "$TEMP_DIR/temp_code_128.png"

  # Создаем .icns файл
  png2icns "$ROOT_DIR/src/$QUALITY/resources/darwin/code.icns" \
    "$TEMP_DIR/temp_code_512.png" "$TEMP_DIR/temp_code_256.png" "$TEMP_DIR/temp_code_128.png"
  
  echo "Иконки для macOS созданы успешно!"
}

# Создаем иконки для Linux
build_linux_icons() {
  echo "Создание иконок для Linux..."
  
  # Создаем основную иконку
  convert "$PNG_LOGO" -resize 512x512 "$ROOT_DIR/src/$QUALITY/resources/linux/code.png"
  
  # Создаем XPM для RPM
  mkdir -p "$ROOT_DIR/src/$QUALITY/resources/linux/rpm"
  convert "$ROOT_DIR/src/$QUALITY/resources/linux/code.png" "$ROOT_DIR/src/$QUALITY/resources/linux/rpm/code.xpm"
  
  echo "Иконки для Linux созданы успешно!"
}

# Создаем иконки для Windows
build_windows_icons() {
  echo "Создание иконок для Windows..."
  
  # Создаем временные файлы разных размеров
  convert "$PNG_LOGO" -resize 16x16 "$TEMP_DIR/temp_code_16.png"
  convert "$PNG_LOGO" -resize 24x24 "$TEMP_DIR/temp_code_24.png"
  convert "$PNG_LOGO" -resize 32x32 "$TEMP_DIR/temp_code_32.png"
  convert "$PNG_LOGO" -resize 48x48 "$TEMP_DIR/temp_code_48.png"
  convert "$PNG_LOGO" -resize 64x64 "$TEMP_DIR/temp_code_64.png"
  convert "$PNG_LOGO" -resize 128x128 "$TEMP_DIR/temp_code_128.png"
  convert "$PNG_LOGO" -resize 256x256 "$TEMP_DIR/temp_code_256.png"
  
  # Создаем .ico файл
  icotool -c -o "$ROOT_DIR/src/$QUALITY/resources/win32/code.ico" \
    "$TEMP_DIR/temp_code_16.png" "$TEMP_DIR/temp_code_24.png" "$TEMP_DIR/temp_code_32.png" \
    "$TEMP_DIR/temp_code_48.png" "$TEMP_DIR/temp_code_64.png" "$TEMP_DIR/temp_code_128.png" \
    "$TEMP_DIR/temp_code_256.png"
  
  # Создаем дополнительные иконки для Windows
  convert "$PNG_LOGO" -resize 70x70 "$ROOT_DIR/src/$QUALITY/resources/win32/code_70x70.png"
  convert "$PNG_LOGO" -resize 150x150 "$ROOT_DIR/src/$QUALITY/resources/win32/code_150x150.png"
  
  # Создаем иконки для инсталлятора
  convert "$PNG_LOGO" -resize 164x164 -background white -gravity center -extent 164x314 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-100.bmp"
  convert "$PNG_LOGO" -resize 192x192 -background white -gravity center -extent 192x386 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-125.bmp"
  convert "$PNG_LOGO" -resize 246x246 -background white -gravity center -extent 246x459 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-150.bmp"
  convert "$PNG_LOGO" -resize 273x273 -background white -gravity center -extent 273x556 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-175.bmp"
  convert "$PNG_LOGO" -resize 328x328 -background white -gravity center -extent 328x604 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-200.bmp"
  convert "$PNG_LOGO" -resize 355x355 -background white -gravity center -extent 355x700 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-225.bmp"
  convert "$PNG_LOGO" -resize 410x410 -background white -gravity center -extent 410x797 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-big-250.bmp"
  
  convert "$PNG_LOGO" -resize 55x55 -background white -gravity center -extent 55x55 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-100.bmp"
  convert "$PNG_LOGO" -resize 64x64 -background white -gravity center -extent 64x68 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-125.bmp"
  convert "$PNG_LOGO" -resize 83x83 -background white -gravity center -extent 83x80 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-150.bmp"
  convert "$PNG_LOGO" -resize 92x92 -background white -gravity center -extent 92x97 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-175.bmp"
  convert "$PNG_LOGO" -resize 110x110 -background white -gravity center -extent 110x106 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-200.bmp"
  convert "$PNG_LOGO" -resize 119x119 -background white -gravity center -extent 119x123 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-225.bmp"
  convert "$PNG_LOGO" -resize 138x138 -background white -gravity center -extent 138x140 "$ROOT_DIR/src/$QUALITY/resources/win32/inno-small-250.bmp"
  
  # Создаем иконки для MSI инсталлятора
  convert "$PNG_LOGO" -resize 50x50 -background white -gravity east -extent 493x58 "$ROOT_DIR/build/windows/msi/resources/$QUALITY/wix-banner.bmp"
  convert "$PNG_LOGO" -resize 120x120 -background white -gravity northwest -geometry +22+152 -extent 493x312 "$ROOT_DIR/build/windows/msi/resources/$QUALITY/wix-dialog.bmp"
  
  echo "Иконки для Windows созданы успешно!"
}

# Создаем иконки для медиа и сервера
build_media_and_server() {
  echo "Создание иконок для медиа и сервера..."
  
  # Создаем PNG иконку для медиа
  convert "$PNG_LOGO" -resize 1024x1024 "$ROOT_DIR/src/$QUALITY/src/vs/workbench/browser/media/code-icon.png"
  
  # Создаем иконки для сервера
  convert "$PNG_LOGO" -resize 256x256 -define icon:auto-resize=256,128,96,64,48,32,24,16 "$ROOT_DIR/src/$QUALITY/resources/server/favicon.ico"
  convert "$PNG_LOGO" -resize 192x192 "$ROOT_DIR/src/$QUALITY/resources/server/code-192.png"
  convert "$PNG_LOGO" -resize 512x512 "$ROOT_DIR/src/$QUALITY/resources/server/code-512.png"
  
  echo "Иконки для медиа и сервера созданы успешно!"
}

# Запускаем создание иконок
build_darwin_icons
build_linux_icons
build_windows_icons
build_media_and_server

# Очищаем временные файлы
rm -rf "$TEMP_DIR"

echo "Все иконки для ${APP_NAME} успешно созданы!"
