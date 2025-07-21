<!-- order: 35 -->

# Как собрать Researcherry

## Содержание

- [Зависимости](#dependencies)
  - [Linux](#dependencies-linux)
  - [MacOS](#dependencies-macos)
  - [Windows](#dependencies-windows)
- [Сборка для разработки](#build-dev)
- [Сборка для CI/Downstream](#build-ci)
- [Сборка Snap](#build-snap)
- [Процесс обновления патчей](#patch-update-process)
  - [Полуавтоматический](#patch-update-process-semiauto)
  - [Ручной](#patch-update-process-manual)

## <a id="dependencies"></a>Зависимости

- node 22.15.1 (критически важно для Researcherry)
- jq
- git
- python3 3.11
- rustup

### <a id="dependencies-linux"></a>Linux

- gcc
- g++
- make
- pkg-config
- libx11-dev
- libxkbfile-dev
- libsecret-1-dev
- libkrb5-dev
- fakeroot
- rpm
- rpmbuild
- dpkg
- imagemagick (для AppImage и генерации иконок)
- snapcraft
- png2icns (для генерации иконок macOS)
- librsvg (для работы с SVG)

### <a id="dependencies-macos"></a>MacOS

См. [общие зависимости](#dependencies), плюс:
- Xcode Command Line Tools
- png2icns (`npm install png2icns -g`)

### <a id="dependencies-windows"></a>Windows

- powershell
- sed
- 7z
- [WiX Toolset](http://wixtoolset.org/releases/)
- 'Tools for Native Modules' из официального установщика Node.js
- icotool (для генерации иконок Windows)

## <a id="build-dev"></a>Сборка для разработки

### Быстрый старт

```bash
# Инициализация проекта (только при первом запуске)
./init_project.sh

# Генерация иконок из PNG
./icons/generate_icons.sh --source icons/icon.png

# Сборка проекта
./dev/build.sh
```

### Подробная сборка

Вспомогательный скрипт сборки находится в `dev/build.sh`.

- Linux: `./dev/build.sh`
- MacOS: `./dev/build.sh`
- Windows: `powershell -ExecutionPolicy ByPass -File .\dev\build.ps1` или `"C:\Program Files\Git\bin\bash.exe" ./dev/build.sh`

### Insider версия

Версия `insider` может быть собрана с помощью `./dev/build.sh -i` на ветке `insider`.

Вы можете попробовать последнюю версию с командой `./dev/build.sh -il`, но патчи могут быть не актуальными.

### Флаги

Скрипт `dev/build.sh` предоставляет несколько флагов:

- `-i`: собрать Insiders версию
- `-l`: собрать с последней версией Visual Studio Code
- `-o`: пропустить этап сборки
- `-p`: генерировать пакеты/ресурсы/установщики
- `-s`: не получать исходный код Visual Studio Code, не удалять существующую сборку

## <a id="build-ci"></a>Сборка для CI/Downstream

Базовый скрипт для сборки Researcherry:

```bash
# Экспорт необходимых переменных окружения
export SHOULD_BUILD="yes"
export SHOULD_BUILD_REH="no"
export CI_BUILD="no"
export OS_NAME="linux"
export VSCODE_ARCH="${vscode_arch}"
export VSCODE_QUALITY="stable"
export RELEASE_VERSION="${version}"

. get_repo.sh
. build.sh
```

Для более подробной информации посмотрите, как мы собираем проект:
- Linux: https://github.com/KonstantinRogozhkin/researcherry/blob/master/.github/workflows/stable-linux.yml
- macOS: https://github.com/KonstantinRogozhkin/researcherry/blob/master/.github/workflows/stable-macos.yml
- Windows: https://github.com/KonstantinRogozhkin/researcherry/blob/master/.github/workflows/stable-windows.yml

Скрипт `./dev/build.sh` предназначен для разработки и должен быть исключен из процесса упаковки.

## <a id="build-snap"></a>Сборка Snap

```bash
# для стабильной версии
cd ./stores/snapcraft/stable

# для insider версии
cd ./stores/snapcraft/insider

# создать snap
snapcraft --use-lxd

# проверить snap
review-tools.snap-review --allow-classic researcherry*.snap
```

## <a id="patch-update-process"></a>Процесс обновления патчей

## <a id="patch-update-process-semiauto"></a>Полуавтоматический

- запустите `./dev/build.sh`, если патч не применяется, то:
- запустите `./dev/update_patches.sh`
- когда скрипт остановится на `Press any key when the conflict have been resolved...`, откройте директорию `vscode` в **Researcherry**
- исправьте все файлы `*.rej`
- запустите `npm run watch`
- запустите `./script/code.sh` пока все не будет работать
- нажмите любую клавишу для продолжения скрипта `update_patches.sh`

## <a id="patch-update-process-manual"></a>Ручной

- запустите `./dev/build.sh`, если патч не применяется, то:
- запустите `./dev/patch.sh <name>.patch`, где `<name>.patch` — неудачный патч
- откройте директорию `vscode` в новом окне **Researcherry**
- исправьте все файлы `*.rej`
- запустите `npm run watch`
- запустите `./script/code.sh` пока все не будет работать
- вернитесь к командной строке, запускающей `./dev/patch.sh`, нажмите `enter` для подтверждения изменений, и патч будет обновлен

### Исправление проблем с патчами

Если у вас возникают проблемы с патчами, используйте наши вспомогательные скрипты:

```bash
# Исправление проблемных патчей
./fix_patches.sh

# Полный сброс проекта
./reset_project.sh

# Повторная инициализация
./init_project.sh
```

### <a id="icons"></a>Генерация иконок

Для генерации иконок используйте унифицированный скрипт:

```bash
# Генерация всех иконок из PNG
./icons/generate_icons.sh --source icons/icon.png

# Генерация с пользовательскими параметрами
./icons/generate_icons.sh --source my-logo.png --quality insider
```

Для работы скрипта генерации иконок необходимо:

- imagemagick (команда `magick`)
- png2icns (`npm install png2icns -g`)
- icotool (для Windows иконок)
- librsvg (для работы с SVG, если используется)

## Решение проблем

### Проблемы с Node.js версией

Researcherry требует точно Node.js v22.15.1. Другие версии могут вызвать ошибки сборки:

```bash
# Проверить версию
node --version

# Установить правильную версию через nvm
nvm install 22.15.1
nvm use 22.15.1
```

### Проблемы с патчами

Если патчи не применяются:

1. Убедитесь, что директория `vscode` чистая
2. Запустите `./fix_patches.sh`
3. При необходимости используйте `./reset_project.sh` для полного сброса

### Проблемы с иконками

Если возникают ошибки при генерации иконок:

1. Убедитесь, что установлены все зависимости для генерации иконок
2. Проверьте, что исходный PNG файл существует и доступен для чтения
3. Используйте флаг `--help` для получения справки по скрипту

## Дополнительные ресурсы

- [Руководство по решению проблем сборки](../BUILD_TROUBLESHOOTING.md)
- [Документация для разработчиков](./documentation.md)
- [Объяснение патчей](./patch-explanation.md)
