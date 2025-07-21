#!/usr/bin/env bash
# Единый скрипт для генерации всех иконок Researcherry из PNG-логотипа
# Автоматически создает иконки для всех платформ: macOS, Linux, Windows

set -e

# Определяем текущую директорию скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Загружаем утилиты и переменные
. ../utils.sh

# Настройки по умолчанию
SOURCE_PNG="researcherry-high-resolution-logo (2).png"
QUALITY="stable"
TEMP_DIR="$SCRIPT_DIR/temp"
OUTPUT_DIR="$SCRIPT_DIR/output"

# Функция для вывода справки
show_help() {
  echo "Использование: $0 [опции]"
  echo ""
  echo "Опции:"
  echo "  -s, --source FILE   Путь к исходному PNG-файлу (по умолчанию: $SOURCE_PNG)"
  echo "  -o, --output DIR    Директория для временных файлов (по умолчанию: $OUTPUT_DIR)"
  echo "  -q, --quality TYPE  Тип качества: stable или insider (по умолчанию: $QUALITY)"
  echo "  -h, --help          Показать эту справку"
  echo ""
  echo "Пример: $0 --source my-logo.png --quality insider"
}

# Обработка аргументов командной строки
while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--source)
      SOURCE_PNG="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -q|--quality)
      QUALITY="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Неизвестная опция: $1"
      show_help
      exit 1
      ;;
  esac
done

# Проверка наличия исходного файла
if [ ! -f "$SOURCE_PNG" ]; then
  echo "Ошибка: Исходный файл '$SOURCE_PNG' не найден!"
  exit 1
fi

# Проверка наличия необходимых программ
check_programs() {
  for arg in "$@"; do
    if ! command -v "${arg}" &> /dev/null; then
      echo "Ошибка: Программа '${arg}' не найдена!"
      echo "Установите необходимые зависимости и повторите попытку."
      exit 1
    fi
  done
}

check_programs "convert" "png2icns" "icotool"

# Создаем необходимые директории
mkdir -p "$TEMP_DIR"
mkdir -p "$OUTPUT_DIR"

# Определяем пути для выходных файлов
SRC_PREFIX="../"
ROOT_DIR="$SCRIPT_DIR/.."

# Создаем директории для всех платформ
mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/darwin"
mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/linux/rpm"
mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/win32"
mkdir -p "${SRC_PREFIX}src/${QUALITY}/resources/server"
mkdir -p "${SRC_PREFIX}src/${QUALITY}/src/vs/workbench/browser/media"
mkdir -p "${SRC_PREFIX}build/windows/msi/resources/${QUALITY}"

echo "🚀 Начинаем создание иконок для ${APP_NAME} из PNG-логотипа..."
echo "📁 Исходный файл: $SOURCE_PNG"
echo "📁 Тип качества: $QUALITY"

# Функция для создания иконок macOS
build_darwin_icons() {
  echo "🍎 Создание иконок для macOS..."
  
  # Создаем временные файлы разных размеров
  magick "$SOURCE_PNG" -resize 1024x1024 "$TEMP_DIR/code_1024.png"
  magick "$SOURCE_PNG" -resize 512x512 "$TEMP_DIR/code_512.png"
  magick "$SOURCE_PNG" -resize 256x256 "$TEMP_DIR/code_256.png"
  magick "$SOURCE_PNG" -resize 128x128 "$TEMP_DIR/code_128.png"

  # Создаем .icns файл
  png2icns "${SRC_PREFIX}src/${QUALITY}/resources/darwin/code.icns" \
    "$TEMP_DIR/code_512.png" "$TEMP_DIR/code_256.png" "$TEMP_DIR/code_128.png"
  
  # Копируем в выходную директорию для проверки
  cp "${SRC_PREFIX}src/${QUALITY}/resources/darwin/code.icns" "$OUTPUT_DIR/"
  
  echo "✅ Иконки для macOS созданы успешно!"
}

# Функция для создания иконок Linux
build_linux_icons() {
  echo "🐧 Создание иконок для Linux..."
  
  # Создаем основную иконку
  magick "$SOURCE_PNG" -resize 512x512 "${SRC_PREFIX}src/${QUALITY}/resources/linux/code.png"
  
  # Создаем XPM для RPM
  magick "${SRC_PREFIX}src/${QUALITY}/resources/linux/code.png" \
    "${SRC_PREFIX}src/${QUALITY}/resources/linux/rpm/code.xpm"
  
  # Копируем в выходную директорию для проверки
  cp "${SRC_PREFIX}src/${QUALITY}/resources/linux/code.png" "$OUTPUT_DIR/linux_icon.png"
  
  echo "✅ Иконки для Linux созданы успешно!"
}

# Функция для создания иконок Windows
build_windows_icons() {
  echo "🪟 Создание иконок для Windows..."
  
  # Создаем временные файлы разных размеров
  magick "$SOURCE_PNG" -resize 16x16 "$TEMP_DIR/code_16.png"
  magick "$SOURCE_PNG" -resize 24x24 "$TEMP_DIR/code_24.png"
  magick "$SOURCE_PNG" -resize 32x32 "$TEMP_DIR/code_32.png"
  magick "$SOURCE_PNG" -resize 48x48 "$TEMP_DIR/code_48.png"
  magick "$SOURCE_PNG" -resize 64x64 "$TEMP_DIR/code_64.png"
  magick "$SOURCE_PNG" -resize 128x128 "$TEMP_DIR/code_128.png"
  magick "$SOURCE_PNG" -resize 256x256 "$TEMP_DIR/code_256.png"
  
  # Создаем .ico файл
  icotool -c -o "${SRC_PREFIX}src/${QUALITY}/resources/win32/code.ico" \
    "$TEMP_DIR/code_16.png" "$TEMP_DIR/code_24.png" "$TEMP_DIR/code_32.png" \
    "$TEMP_DIR/code_48.png" "$TEMP_DIR/code_64.png" "$TEMP_DIR/code_128.png" \
    "$TEMP_DIR/code_256.png"
  
  # Создаем дополнительные иконки для Windows
  magick "$SOURCE_PNG" -resize 70x70 "${SRC_PREFIX}src/${QUALITY}/resources/win32/code_70x70.png"
  magick "$SOURCE_PNG" -resize 150x150 "${SRC_PREFIX}src/${QUALITY}/resources/win32/code_150x150.png"
  
  # Копируем в выходную директорию для проверки
  cp "${SRC_PREFIX}src/${QUALITY}/resources/win32/code.ico" "$OUTPUT_DIR/windows_icon.ico"
  
  echo "✅ Иконки для Windows созданы успешно!"
}

# Функция для создания иконок для медиа и сервера
build_media_and_server() {
  echo "🌐 Создание иконок для медиа и сервера..."
  
  # Создаем иконку для медиа
  magick "$SOURCE_PNG" -resize 128x128 "$TEMP_DIR/code-icon.png"
  
  # Копируем в нужные директории
  cp "$TEMP_DIR/code-icon.png" "${SRC_PREFIX}src/${QUALITY}/src/vs/workbench/browser/media/code-icon.svg"
  
  # Создаем иконку для сервера
  magick "$SOURCE_PNG" -resize 512x512 "${SRC_PREFIX}src/${QUALITY}/resources/server/code.png"
  
  echo "✅ Иконки для медиа и сервера созданы успешно!"
}

# Запускаем создание иконок
build_darwin_icons
build_linux_icons
build_windows_icons
build_media_and_server

# Очищаем временные файлы
echo "🧹 Очистка временных файлов..."
rm -rf "$TEMP_DIR"

echo "✨ Все иконки для ${APP_NAME} успешно созданы!"
echo "📁 Проверьте результаты в директории: $OUTPUT_DIR"
