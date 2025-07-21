<!-- order: 25 -->

# Устранение неполадок Researcherry

## Содержание

- [Linux](#linux)
  - [Шрифты отображаются как прямоугольники](#linux-fonts-rectangle)
  - [Текст и/или весь интерфейс не отображается](#linux-rendering-glitches)
  - [Обходной путь для глобального меню KDE](#linux-kde-global-menu)
  - [Наиболее частые проблемы Flatpak](#linux-flatpak-most-common-issues)
  - [Remote SSH не работает](#linux-remote-ssh)
- [macOS](#macos)
  - [Проблемы с правами доступа](#macos-permissions)
  - [Проблемы с Gatekeeper](#macos-gatekeeper)
- [Windows](#windows)
  - [Проблемы с установщиком](#windows-installer)
  - [Проблемы с антивирусом](#windows-antivirus)
- [Общие проблемы](#general)
  - [Проблемы с расширениями](#general-extensions)
  - [Проблемы с производительностью](#general-performance)
  - [Проблемы с AI-агентами](#general-ai-agents)

## <a id="linux"></a>Linux

### <a id="linux-fonts-rectangle"></a>*Шрифты отображаются как прямоугольники*

Следующая команда должна помочь:

```bash
rm -rf ~/.cache/fontconfig
rm -rf ~/snap/researcherry/common/.cache
fc-cache -r
```

### <a id="linux-rendering-glitches"></a>*Текст и/или весь интерфейс не отображается*

Вы, вероятно, столкнулись с [ошибкой в Chromium и Electron](https://github.com/microsoft/vscode/issues/190437) при компиляции шейдеров Mesa, которая затронула все версии Visual Studio Code и VSCodium для дистрибутивов Linux начиная с версии 1.82. Текущий обходной путь (см. microsoft/vscode#190437) — удалить кэш GPU следующим образом:

```bash
rm -rf ~/.config/Researcherry/GPUCache
```

### <a id="linux-kde-global-menu"></a>*Обходной путь для глобального меню KDE*

Установите эти пакеты на Fedora:

* libdbusmenu-devel
* dbus-glib-devel
* libdbusmenu

На Ubuntu этот пакет называется `libdbusmenu-glib4`.

Благодарности: [Gerson](https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/issues/91)

### <a id="linux-flatpak-most-common-issues"></a>*Наиболее частые проблемы Flatpak*

- Размытый экран с HiDPI на wayland, выполните:
  ```bash
  flatpak override --user --nosocket=wayland com.vscodium.codium
  ```
- Для выполнения команд в хост-системе, запустите внутри песочницы:
  ```bash
  flatpak-spawn --host <КОМАНДА>
  # или
  host-spawn <КОМАНДА>
  ```
- Где мое расширение X? Изменение product.json
  Краткий ответ: используйте https://open-vsx.org/extension/zokugun/vsix-manager

- SDK
  см. [это](https://github.com/flathub/com.vscodium.codium?tab=readme-ov-file#sdks)

- Если у вас есть другие проблемы с flatpak пакетом, попробуйте посмотреть в [FAQ](https://github.com/flathub/com.vscodium.codium?tab=readme-ov-file#faq), возможно, решение уже есть там, или откройте [issue](https://github.com/flathub/com.vscodium.codium/issues).

### <a id="linux-remote-ssh"></a>*Remote SSH не работает*

Используйте совместимое с Researcherry расширение [Open Remote - SSH](https://open-vsx.org/extension/jeanp413/open-remote-ssh).

На сервере в конфигурации `sshd` параметр `AllowTcpForwarding` должен быть установлен в `yes`.

Могут потребоваться дополнительные зависимости в зависимости от ОС/дистрибутива (alpine).

## <a id="macos"></a>macOS

### <a id="macos-permissions"></a>*Проблемы с правами доступа*

Если Researcherry не может получить доступ к файлам или папкам:

1. Откройте **Системные настройки** > **Безопасность и конфиденциальность** > **Конфиденциальность**
2. Выберите **Полный доступ к диску** в левом меню
3. Нажмите на замок и введите пароль администратора
4. Добавьте Researcherry в список приложений

### <a id="macos-gatekeeper"></a>*Проблемы с Gatekeeper*

Если macOS блокирует запуск Researcherry:

```bash
# Снять карантин с приложения
xattr -dr com.apple.quarantine /Applications/Researcherry.app

# Или разрешить запуск через командную строку
sudo spctl --master-disable
```

**Внимание:** Отключение Gatekeeper снижает безопасность системы. Используйте с осторожностью.

## <a id="windows"></a>Windows

### <a id="windows-installer"></a>*Проблемы с установщиком*

Если установщик не запускается или выдает ошибки:

1. Запустите установщик от имени администратора
2. Временно отключите антивирус
3. Убедитесь, что у вас достаточно места на диске
4. Проверьте, что Windows Installer работает корректно

### <a id="windows-antivirus"></a>*Проблемы с антивирусом*

Некоторые антивирусы могут блокировать Researcherry:

1. Добавьте папку установки Researcherry в исключения антивируса
2. Добавьте процесс `researcherry.exe` в исключения
3. Временно отключите реальную защиту при установке

## <a id="general"></a>Общие проблемы

### <a id="general-extensions"></a>*Проблемы с расширениями*

**Расширение не устанавливается:**
- Убедитесь, что используете Open VSX Registry вместо Microsoft Marketplace
- Проверьте совместимость расширения с VSCodium
- Попробуйте установить расширение вручную из .vsix файла

**Расширение не работает:**
```bash
# Очистить кэш расширений
rm -rf ~/.config/Researcherry/CachedExtensions
rm -rf ~/.config/Researcherry/logs
```

### <a id="general-performance"></a>*Проблемы с производительностью*

**Медленный запуск:**
1. Отключите ненужные расширения
2. Очистите кэш:
   ```bash
   rm -rf ~/.config/Researcherry/CachedData
   rm -rf ~/.config/Researcherry/logs
   ```
3. Увеличьте лимит памяти для Node.js:
   ```bash
   export NODE_OPTIONS="--max-old-space-size=8192"
   ```

**Высокое потребление CPU:**
- Проверьте, какие расширения потребляют ресурсы в **Help** > **Process Explorer**
- Отключите TypeScript/JavaScript language features для больших проектов
- Используйте `.gitignore` для исключения больших папок из индексации

### <a id="general-ai-agents"></a>*Проблемы с AI-агентами*

**AI-агент не отвечает:**
1. Проверьте подключение к интернету
2. Убедитесь, что API ключи настроены корректно
3. Проверьте лимиты API
4. Перезапустите Researcherry

**Ошибки анализа интервью:**
1. Убедитесь, что файл интервью в поддерживаемом формате
2. Проверьте размер файла (не должен превышать лимиты API)
3. Убедитесь, что текст читаемый и структурированный

**Профили не переключаются:**
1. Используйте Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
2. Найдите команды "Переключить на профиль..."
3. Если команды не найдены, переустановите Researcherry

## Сбор диагностической информации

Для получения помощи соберите следующую информацию:

```bash
# Версия Researcherry
researcherry --version

# Информация о системе
researcherry --status

# Логи (последние 50 строк)
tail -n 50 ~/.config/Researcherry/logs/main.log
```

## Получение помощи

Если проблема не решена:

1. Проверьте [известные проблемы](https://github.com/KonstantinRogozhkin/researcherry/issues)
2. Создайте новый [issue](https://github.com/KonstantinRogozhkin/researcherry/issues/new) с подробным описанием
3. Приложите диагностическую информацию
4. Присоединитесь к [обсуждениям](https://github.com/KonstantinRogozhkin/researcherry/discussions)

## Полезные ссылки

- [Документация для разработчиков](./documentation.md)
- [Руководство по сборке](./howto-build.md)
- [Генерация иконок](./ICON_DOCUMENTATION.md)
- [Объяснение патчей](./patch-explanation.md)
