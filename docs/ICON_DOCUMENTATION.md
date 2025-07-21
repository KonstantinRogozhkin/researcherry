# Генерация иконок Researcherry

## 🎯 Обзор

Этот документ описывает унифицированный процесс генерации иконок для Researcherry из PNG-файла. Новый подход заменяет множественные скрипты одним универсальным решением.

## 📁 Структура файлов

```
icons/
├── generate_icons.sh           # 🆕 Унифицированный скрипт генерации
├── README_ICONS.md            # Подробная документация
├── researcherry-logo.png      # Исходный PNG логотип
├── output/                    # Сгенерированные иконки
│   ├── mac/
│   │   ├── icon.icns         # macOS иконка
│   │   └── *.png             # PNG размеры для macOS
│   ├── win/
│   │   ├── icon.ico          # Windows иконка
│   │   └── *.png             # PNG размеры для Windows
│   └── linux/
│       └── *.png             # PNG размеры для Linux
└── deprecated/                # Устаревшие скрипты
    ├── build_icons.sh        # ❌ Устарел
    ├── build_from_png.sh     # ❌ Устарел
    ├── update_icon.sh        # ❌ Устарел
    └── create_icon_with_padding.sh  # ❌ Устарел
```

## 🛠️ Требования

Для генерации иконок необходимы следующие инструменты:

### Обязательные зависимости:
- **ImageMagick v7+** (`magick` команда)
- **png2icns** (для создания .icns файлов)
- **icotool** (для создания .ico файлов)

### Установка зависимостей:

```bash
# macOS (через Homebrew)
brew install imagemagick
npm install -g png2icns
brew install libicns  # содержит icotool

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install imagemagick icoutils
npm install -g png2icns

# Проверка установки
magick --version
png2icns --help
icotool --version
```

## 🚀 Быстрый старт

### Простая генерация иконок

Весь процесс генерации иконок теперь выполняется одной командой:

```bash
cd icons
./generate_icons.sh
```

### Использование с параметрами

```bash
# Указать исходный PNG файл
./generate_icons.sh -s /path/to/your/logo.png

# Указать директорию вывода
./generate_icons.sh -o /path/to/output

# Указать качество (stable или insider)
./generate_icons.sh -q insider

# Комбинирование параметров
./generate_icons.sh -s logo.png -o custom_output -q stable
```

## 📋 Подробный процесс

### 1. Подготовка исходного изображения

**Требования к исходному PNG:**
- ✅ Квадратное соотношение сторон (1:1)
- ✅ Высокое разрешение (минимум 512x512, рекомендуется 1024x1024+)
- ✅ Формат PNG с поддержкой прозрачности
- ✅ Четкие края и контрастные цвета

**Рекомендации:**
- Используйте векторные элементы для лучшего масштабирования
- Избегайте мелких деталей, которые могут потеряться при уменьшении
- Тестируйте читаемость на размере 16x16 пикселей

### 2. Автоматическая генерация

Скрипт `generate_icons.sh` автоматически:

1. **Проверяет зависимости** - убеждается, что все необходимые инструменты установлены
2. **Создает структуру папок** - организует выходные директории
3. **Генерирует PNG размеры:**
   - macOS: 16, 32, 64, 128, 256, 512, 1024px
   - Windows: 16, 24, 32, 48, 64, 96, 128, 256px
   - Linux: 16, 22, 24, 32, 48, 64, 96, 128, 256, 512px
4. **Создает платформенные форматы:**
   - `.icns` для macOS (используя png2icns)
   - `.ico` для Windows (используя icotool)
5. **Копирует медиа-иконки** для интеграции с приложением
6. **Очищает временные файлы**

### 3. Интеграция с приложением

После генерации иконки автоматически копируются в соответствующие места:

```bash
# Структура интеграции
vscode/resources/
├── darwin/           # macOS ресурсы
│   └── icon.icns
├── win32/            # Windows ресурсы
│   └── icon.ico
└── linux/            # Linux ресурсы
    └── icon.png
```

### 4. Обновление кеша системы

**macOS:**
```bash
# Перезапуск Dock для обновления иконок
killall Dock

# Полная очистка кеша иконок (при необходимости)
sudo rm -rf /Library/Caches/com.apple.iconservices.store
sudo find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \;
```

**Linux:**
```bash
# Обновление кеша иконок
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor
update-desktop-database ~/.local/share/applications
```

**Windows:**
```bash
# Очистка кеша иконок (PowerShell)
Remove-Item -Path "$env:LOCALAPPDATA\IconCache.db" -Force
Stop-Process -Name explorer -Force
Start-Process explorer
```

## 🔧 Расширенные возможности

### Кастомизация размеров

Вы можете изменить генерируемые размеры, отредактировав массивы в скрипте:

```bash
# В generate_icons.sh
MACOS_SIZES=(16 32 64 128 256 512 1024)
WINDOWS_SIZES=(16 24 32 48 64 96 128 256)
LINUX_SIZES=(16 22 24 32 48 64 96 128 256 512)
```

### Добавление водяных знаков

Для версий insider можно добавить водяной знак:

```bash
./generate_icons.sh -q insider
# Автоматически добавит полупрозрачный текст "INSIDER"
```

### Пакетная обработка

Для обработки нескольких логотипов:

```bash
#!/bin/bash
for logo in logos/*.png; do
    ./generate_icons.sh -s "$logo" -o "output/$(basename "$logo" .png)"
done
```

## ❌ Устаревшие скрипты

Следующие скрипты больше не используются и перенесены в `deprecated/`:

- `build_icons.sh` - заменен на `generate_icons.sh`
- `build_from_png.sh` - функциональность интегрирована
- `update_icon.sh` - автоматизирован в основном скрипте
- `create_icon_with_padding.sh` - логика включена в новый скрипт

## 🐛 Устранение неполадок

### Ошибка "magick: command not found"
```bash
# Установите ImageMagick v7+
brew install imagemagick
# или
sudo apt-get install imagemagick
```

### Ошибка "png2icns: command not found"
```bash
npm install -g png2icns
```

### Ошибка "icotool: command not found"
```bash
# macOS
brew install libicns
# Linux
sudo apt-get install icoutils
```

### Проблемы с правами доступа
```bash
chmod +x generate_icons.sh
```

### Некорректные размеры иконок
- Проверьте, что исходный PNG имеет квадратное соотношение сторон
- Убедитесь, что разрешение достаточно высокое (минимум 512x512)

## 📚 Дополнительные ресурсы

- [Руководство по дизайну иконок Apple](https://developer.apple.com/design/human-interface-guidelines/icons)
- [Спецификации иконок Windows](https://docs.microsoft.com/en-us/windows/apps/design/style/iconography/app-icons)
- [Стандарты иконок Linux](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html)
- [ImageMagick документация](https://imagemagick.org/script/command-line-processing.php)
```

---

*Документация обновлена для версии Researcherry с унифицированным скриптом генерации иконок. Для получения актуальной информации посетите [наш репозиторий](https://github.com/KonstantinRogozhkin/researcherry).*
