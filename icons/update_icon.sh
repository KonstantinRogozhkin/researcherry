#!/bin/bash

# Скрипт для обновления иконок в VS Code для CI/CD
# Работает с относительными путями

set -e

echo "🎨 Обновление иконок Researcherry..."

# Определяем базовые пути
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ICONS_DIR="$SCRIPT_DIR"

echo "📁 Рабочая директория: $PROJECT_ROOT"
echo "🖼️  Папка иконок: $ICONS_DIR"

# Проверяем наличие основной иконки
MAIN_ICON="$ICONS_DIR/icon.png"
if [ ! -f "$MAIN_ICON" ]; then
  echo "❌ Ошибка: Основная иконка $MAIN_ICON не найдена!"
  exit 1
fi

echo "✅ Основная иконка найдена: $MAIN_ICON"

# Создаем папку output если её нет
mkdir -p "$ICONS_DIR/output"

# Копируем иконки в VS Code ресурсы
VSCODE_DIR="$PROJECT_ROOT/vscode"

if [ -d "$VSCODE_DIR" ]; then
  echo "📦 Обновляем иконки в VS Code..."
  
  # Windows иконки
  if [ -d "$VSCODE_DIR/resources/win32" ]; then
    echo "🪟 Копируем иконку для Windows..."
    # Используем готовую ICO иконку
    if [ -f "$ICONS_DIR/output/windows_icon.ico" ]; then
      cp "$ICONS_DIR/output/windows_icon.ico" "$VSCODE_DIR/resources/win32/code.ico"
      echo "✅ Windows ICO иконка скопирована"
    else
      echo "⚠️  ICO иконка не найдена, используем PNG"
      cp "$MAIN_ICON" "$VSCODE_DIR/resources/win32/code.png"
    fi
  fi
  
  # Linux иконки
  if [ -d "$VSCODE_DIR/resources/linux" ]; then
    echo "🐧 Копируем иконку для Linux..."
    # Используем готовую Linux иконку если есть
    if [ -f "$ICONS_DIR/output/linux_icon.png" ]; then
      cp "$ICONS_DIR/output/linux_icon.png" "$VSCODE_DIR/resources/linux/code.png"
      echo "✅ Linux PNG иконка скопирована"
    else
      cp "$MAIN_ICON" "$VSCODE_DIR/resources/linux/code.png"
    fi
  fi
  
  # macOS иконки
  if [ -d "$VSCODE_DIR/resources/darwin" ]; then
    echo "🍎 Копируем иконку для macOS..."
    # Используем готовую ICNS иконку
    if [ -f "$ICONS_DIR/output/code.icns" ]; then
      cp "$ICONS_DIR/output/code.icns" "$VSCODE_DIR/resources/darwin/code.icns"
      echo "✅ macOS ICNS иконка скопирована"
    else
      echo "⚠️  ICNS иконка не найдена, используем PNG"
      cp "$MAIN_ICON" "$VSCODE_DIR/resources/darwin/code.png"
    fi
  fi
  
  echo "✅ Иконки успешно обновлены в VS Code"
else
  echo "⚠️  Папка vscode не найдена, пропускаем обновление"
fi

echo "🎉 Обновление иконок завершено!"
