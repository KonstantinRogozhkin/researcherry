#!/usr/bin/env bash
# Скрипт для полной инициализации проекта Researcherry

set -e

# include common functions
. ./utils.sh

echo "🚀 Инициализация проекта Researcherry..."

# Проверяем, что директория vscode не существует
if [ -d "vscode" ]; then
    echo "❌ Директория vscode уже существует. Удалите её или запустите reset_project.sh"
    exit 1
fi

# Клонируем VSCode
echo "📥 Клонирование исходного кода VSCode..."
VSCODE_VERSION="1.95.3"  # Используем стабильную версию
git clone --depth 1 --branch "${VSCODE_VERSION}" https://github.com/microsoft/vscode.git vscode

if [ ! -d "vscode" ]; then
    echo "❌ Не удалось клонировать VSCode"
    exit 1
fi

echo "✅ VSCode успешно клонирован"

# Переходим в директорию vscode и устанавливаем зависимости
cd vscode

echo "📦 Установка зависимостей..."
npm install

echo "✅ Зависимости установлены"

# Возвращаемся в корневую директорию
cd ..

# Теперь запускаем prepare_vscode.sh
echo "🔧 Применение патчей и настроек Researcherry..."
./prepare_vscode.sh

echo "✅ Проект Researcherry успешно инициализирован!"
echo ""
echo "Теперь вы можете:"
echo "  ./dev/build.sh          # Собрать проект"
echo "  ./icons/generate_icons.sh  # Сгенерировать иконки"
echo ""
echo "Для разработки используйте:"
echo "  ./dev/update_patches.sh  # Обновить патчи"
