# Документация по обновлению иконок Researcherry

## Обзор

Этот документ описывает процесс обновления иконок для приложения Researcherry (ребрендинг VSCodium). Документация включает инструкции по созданию и применению новых иконок для macOS, Windows и Linux.

## Структура файлов

- `/icons/` - директория с исходными изображениями и сгенерированными иконками
  - `researcherry-high-resolution-logo (1).png` - исходный логотип (2000x2000)
  - `researcherry-high-resolution-logo (2).png` - альтернативный логотип (2000x2000)
  - `template_macos.png` - шаблон иконки macOS с закругленными углами
  - `/output-padded/icons/` - директория с готовыми иконками с отступами
    - `/mac/icon.icns` - иконка для macOS
    - `/win/icon.ico` - иконка для Windows
    - `/png/` - PNG-версии иконок разных размеров

- `update_icon.sh` - скрипт для применения готовых иконок к приложению
- `create_icon_with_padding.sh` - скрипт для создания иконок с отступами
- `mask_icon_simple.sh` - скрипт для создания иконок с закругленными углами

## Требования

Для работы с иконками требуются следующие инструменты:

- ImageMagick (`magick` или `convert`)
- electron-icon-builder (для генерации набора иконок)
- iconutil (встроенный в macOS)
- sips (встроенный в macOS)

Установка зависимостей:

```bash
# Установка ImageMagick
brew install imagemagick

# Установка electron-icon-builder
npm install -g electron-icon-builder
```

## Процесс создания иконок

### 1. Подготовка исходного изображения

Исходное изображение должно быть квадратным, высокого разрешения (рекомендуется 1024x1024 или больше). Формат PNG с прозрачностью.

### 2. Создание иконок с отступами

Для создания иконок с правильными отступами используйте скрипт `create_icon_with_padding.sh`:

```bash
./create_icon_with_padding.sh
```

Этот скрипт выполняет следующие действия:
1. Создает пустое изображение 1024x1024
2. Изменяет размер исходного логотипа до 820x820 (80% от общего размера)
3. Размещает уменьшенный логотип по центру с отступами
4. Применяет маску с закругленными углами
5. Генерирует набор иконок для всех платформ
6. Обновляет `update_icon.sh` для использования новых иконок
7. Применяет новые иконки к приложению

### 3. Применение иконок к приложению

Для применения готовых иконок к приложению используйте скрипт `update_icon.sh`:

```bash
./update_icon.sh
```

Этот скрипт выполняет следующие действия:
1. Копирует `.icns` файл в ресурсы приложения macOS
2. Копирует `.ico` файл для Windows
3. Копирует PNG-файлы для Linux
4. Обновляет `Info.plist` для указания на новую иконку
5. Очищает кеш иконок

### 4. Обновление кеша иконок в macOS

После применения новых иконок может потребоваться обновление кеша иконок в macOS:

```bash
# Перезапуск Dock
killall Dock

# Или более радикальная очистка кеша (может потребовать прав администратора)
sudo rm -rf /Library/Caches/com.apple.iconservices.store
```

## Создание DMG-образа с новой иконкой

Для создания DMG-образа приложения с новой иконкой:

```bash
# Создание простого DMG-образа
hdiutil create -volname "Researcherry" -srcfolder VSCode-darwin-arm64/Researcherry.app -ov -format UDZO Researcherry.dmg

# Или с использованием create-dmg для более красивого оформления
create-dmg VSCode-darwin-arm64/Researcherry.app
```

## Решение проблем

### Иконка не обновляется в доке macOS

1. Перезапустите Dock: `killall Dock`
2. Удалите приложение из дока и добавьте его заново
3. Создайте копию приложения с другим именем:
   ```bash
   cp -R VSCode-darwin-arm64/Researcherry.app VSCode-darwin-arm64/ResearcherryNew.app
   /usr/libexec/PlistBuddy -c "Set :CFBundleName ResearcherryNew" VSCode-darwin-arm64/ResearcherryNew.app/Contents/Info.plist
   ```
4. Перезагрузите компьютер

### Иконка выглядит слишком большой или маленькой

Отрегулируйте размер логотипа в скрипте `create_icon_with_padding.sh`. Для уменьшения размера иконки уменьшите значение в строке:
```bash
magick "$SOURCE_ICON" -resize 820x820 "$OUTPUT_DIR/resized.png"
```
Например, измените на `720x720` для большего отступа.

## Рекомендации по дизайну иконок

1. **Отступы**: Профессиональные иконки macOS обычно имеют отступы 10-15% от края
2. **Закругленные углы**: Используйте закругленные углы для соответствия стилю macOS
3. **Размеры**: Генерируйте все необходимые размеры (16x16 до 1024x1024)
4. **Прозрачность**: Сохраняйте прозрачность в PNG-файлах
5. **Формат**: Используйте `.icns` для macOS, `.ico` для Windows и PNG для Linux

## Автоматизация в CI/CD

Для автоматизации обновления иконок в процессе сборки добавьте в скрипт сборки:

```bash
# В build.sh или аналогичном скрипте
./create_icon_with_padding.sh
```

## Дополнительные ресурсы

- [Руководство по дизайну иконок Apple](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Документация ImageMagick](https://imagemagick.org/script/command-line-processing.php)
- [Документация electron-icon-builder](https://www.npmjs.com/package/electron-icon-builder)
