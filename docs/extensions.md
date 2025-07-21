<!-- order: 15 -->

# Расширения + Магазин

## Содержание

- [Магазин расширений](#marketplace)
- [Как использовать OpenVSX Marketplace](#howto-openvsx-marketplace)
- [Как использовать другой магазин расширений](#howto-switch-marketplace)
- [Как разместить собственный магазин расширений](#howto-selfhost-marketplace)
- [Visual Studio Marketplace](#visual-studio-marketplace)
- [Проприетарные инструменты отладки](#proprietary-debugging-tools)
- [Проприетарные расширения](#proprietary-extensions)
- [Использование расширения "VSIX Manager"](#vsix-manager)


## <a id="marketplace"></a>Магазин расширений

Являясь редактором на основе VSCode, Researcherry получает дополнительные функции путем установки расширений Visual Studio Code.
К сожалению, поскольку Microsoft [запрещает использование Microsoft marketplace любыми другими продуктами](https://github.com/microsoft/vscode/issues/31168) или распространение `.vsix` файлов из него, для использования расширений Visual Studio Code в продуктах не от Microsoft их нужно устанавливать по-другому.

По умолчанию файл `product.json` настроен на использование [open-vsx.org](https://open-vsx.org/) в качестве галереи расширений, которая имеет [адаптер](https://github.com/eclipse/openvsx/wiki/Using-Open-VSX-in-VS-Code) к Marketplace API, используемому Visual Studio Code. Поскольку это довольно новый проект, вам, вероятно, будет не хватать некоторых расширений, которые вы знаете из Visual Studio Marketplace. У вас есть следующие варианты получения таких недостающих расширений:

* Попросите разработчиков расширений опубликовать их на [open-vsx.org](https://open-vsx.org/) в дополнение к Visual Studio Marketplace. Процесс публикации документирован в [Open VSX Wiki](https://github.com/eclipse/openvsx/wiki/Publishing-Extensions).
* Создайте pull request в [этот репозиторий](https://github.com/open-vsx/publish-extensions), чтобы сервисный аккаунт [@open-vsx](https://github.com/open-vsx) опубликовал расширения за вас.
* Скачайте и [установите vsix файлы](https://code.visualstudio.com/docs/editor/extension-gallery#_install-from-a-vsix), например, со страницы релизов в их исходном репозитории.

## <a id="howto-openvsx-marketplace"></a>Как использовать Open VSX Registry

Как отмечено выше, [Open VSX Registry](https://open-vsx.org/) является предустановленной галереей расширений в Researcherry. Использование представления расширений в Researcherry будет поэтому по умолчанию использовать его.
См. [эту статью](https://www.gitpod.io/blog/open-vsx/) для получения дополнительной информации о мотивации Open VSX.

## <a id="howto-switch-marketplace"></a>Как использовать другой магазин расширений

Вы можете переключиться с предустановленного Open VSX Registry, настроив конечные точки, используя следующие решения.

Вы можете использовать следующие переменные окружения:
- `VSCODE_GALLERY_SERVICE_URL` ***(обязательно)***
- `VSCODE_GALLERY_ITEM_URL` ***(обязательно)***
- `VSCODE_GALLERY_CACHE_URL`
- `VSCODE_GALLERY_CONTROL_URL`
- `VSCODE_GALLERY_EXTENSION_URL_TEMPLATE` ***(обязательно)***
- `VSCODE_GALLERY_RESOURCE_URL_TEMPLATE`

Или создав пользовательский `product.json` в следующем расположении (замените `Researcherry` на `Researcherry - Insiders`, если используете эту версию):
- Windows: `%APPDATA%\Researcherry` или `%USERPROFILE%\AppData\Roaming\Researcherry`
- macOS: `~/Library/Application Support/Researcherry`
- Linux: `$XDG_CONFIG_HOME/Researcherry` или `~/.config/Researcherry`

с содержимым типа:

```jsonc
{
  "extensionsGallery": {
    "serviceUrl": "", // обязательно
    "itemUrl": "", // обязательно
    "cacheUrl": "",
    "controlUrl": "",
    "extensionUrlTemplate": "", // обязательно
    "resourceUrlTemplate": "",
  }
}
```

## <a id="howto-selfhost-marketplace"></a>Как разместить собственный магазин расширений

Индивидуальные разработчики и корпоративные компании в регулируемых или заботящихся о безопасности отраслях могут размещать собственную галерею расширений.

Вероятно, есть и другие варианты, но следующие, как сообщается, работают:

* [Open VSX](https://github.com/eclipse/openvsx) — проект с открытым исходным кодом Eclipse
  Хотя публичный экземпляр, который управляется Eclipse Foundation, является предустановленной конечной точкой в Researcherry, вы можете разместить собственный экземпляр.

    > Open VSX — это [vendor-neutral](https://projects.eclipse.org/projects/ecd.openvsx) альтернатива с открытым исходным кодом [Visual Studio Marketplace](https://marketplace.visualstudio.com/vscode). Он предоставляет серверное приложение, которое управляет [расширениями Visual Studio Code](https://code.visualstudio.com/api) в базе данных, веб-приложение, похожее на Visual Studio Marketplace, и инструмент командной строки для публикации расширений, похожий на [vsce](https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce).

* [code-marketplace](https://coder.com/blog/running-a-private-vs-code-extension-marketplace) — проект с открытым исходным кодом

    > `code-marketplace` — это автономный go-бинарник, который не имеет фронтенда или каких-либо механизмов для авторов расширений для добавления или обновления расширений в marketplace. Он просто читает расширения из файлового хранилища и предоставляет API для редакторов, совместимых с VSCode.

## <a id="visual-studio-marketplace"></a>Visual Studio Marketplace

Как и с любым онлайн-сервисом, убедитесь, что вы понимаете [его условия использования](https://aka.ms/vsmarketplace-ToU), которые включают:
> Предложения Marketplace предназначены для использования только с продуктами и сервисами Visual Studio, и вы можете устанавливать и использовать предложения Marketplace только с продуктами и сервисами Visual Studio.

Поэтому мы не можем предоставить никакой помощи, если вы намерены нарушить их условия использования.

Также обратите внимание, что эта галерея расширений размещает множество расширений, которые являются несвободными и имеют лицензионные соглашения, которые явно запрещают их использование в продуктах не от Microsoft, наряду с использованием телеметрии.

## <a id="proprietary-debugging-tools"></a>Проприетарные инструменты отладки

Отладчик, предоставляемый с [расширением C#](https://github.com/OmniSharp/omnisharp-vscode) от Microsoft, а также отладчик (Windows), предоставляемый с их [расширением C++](https://github.com/Microsoft/vscode-cpptools), имеют очень ограничительные лицензии для работы только с официальной сборкой Visual Studio Code. См. [этот комментарий в репозитории расширения C#](https://github.com/OmniSharp/omnisharp-vscode/issues/2491#issuecomment-418811364) и [этот комментарий в репозитории расширения C++](https://github.com/Microsoft/vscode-cpptools/issues/21#issuecomment-248349017).

Существует обходной путь для работы отладки в проектах C#, используя пакет [netcoredbg](https://github.com/Samsung/netcoredbg) с открытым исходным кодом от Samsung. См. [этот комментарий](https://github.com/VSCodium/vscodium/issues/82#issue-409806641) для инструкций по его настройке.

## <a id="proprietary-extensions"></a>Проприетарные расширения

Как и отладчики, упомянутые выше, некоторые расширения, которые вы можете найти в marketplace (например, [расширения удаленной разработки](https://code.visualstudio.com/docs/remote/remote-overview)), функционируют только с официальной сборкой Visual Studio Code. Вы можете обойти это, добавив внутренний ID расширения (найденный на странице расширения) в свойство `extensionAllowedProposedApi` файла product.json в вашей установке Researcherry. Например:

```jsonc
  "extensionAllowedProposedApi": [
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode.remote-explorer"
  ]
```

## <a id="vsix-manager"></a>Использование расширения "VSIX Manager"

Для упрощения управления расширениями в Researcherry рекомендуется использовать расширение [VSIX Manager](https://open-vsx.org/extension/zokugun/vsix-manager).

Это расширение позволяет:
- Устанавливать расширения из `.vsix` файлов
- Управлять расширениями из разных источников
- Создавать локальные репозитории расширений
- Синхронизировать расширения между установками

### Установка VSIX Manager

1. Откройте Researcherry
2. Перейдите в раздел расширений (`Ctrl+Shift+X`)
3. Найдите "VSIX Manager" от zokugun
4. Установите расширение

### Использование

После установки вы можете:
- Использовать команду "VSIX Manager: Install from VSIX" для установки `.vsix` файлов
- Настроить дополнительные источники расширений
- Управлять установленными расширениями

## Рекомендуемые расширения для Researcherry

### Для исследователей клиентов

- **Markdown All in One** - для создания отчетов и документации
- **Excel Viewer** - для просмотра данных в табличном формате
- **JSON Tools** - для работы с данными интервью в JSON формате
- **REST Client** - для тестирования API интеграций
- **GitLens** - для отслеживания изменений в исследовательских проектах

### Для разработчиков AI-агентов

- **Python** - основной язык для AI/ML разработки
- **Jupyter** - для работы с ноутбуками и анализа данных
- **Docker** - для контейнеризации AI-агентов
- **Thunder Client** - альтернатива Postman для тестирования API
- **YAML** - для конфигурационных файлов

### Общие полезные расширения

- **Russian Language Pack** - русская локализация интерфейса
- **Auto Rename Tag** - автоматическое переименование HTML/XML тегов
- **Bracket Pair Colorizer** - цветовое выделение скобок
- **Path Intellisense** - автодополнение путей к файлам
- **TODO Highlight** - выделение TODO комментариев

## Решение проблем с расширениями

### Расширение не устанавливается

1. Проверьте, что используете Open VSX Registry
2. Попробуйте найти альтернативное расширение
3. Скачайте `.vsix` файл и установите вручную
4. Используйте VSIX Manager для управления

### Расширение не работает корректно

1. Проверьте совместимость с VSCodium/Researcherry
2. Обновите расширение до последней версии
3. Перезапустите Researcherry
4. Проверьте логи расширения в Developer Tools

### Отсутствуют функции расширения

Некоторые расширения могут требовать дополнительной настройки для работы с Researcherry:

1. Добавьте ID расширения в `extensionAllowedProposedApi`
2. Настройте переменные окружения
3. Используйте альтернативные расширения с открытым исходным кодом

## Создание собственных расширений

Для создания расширений для Researcherry:

1. Используйте [Yeoman Generator](https://code.visualstudio.com/api/get-started/your-first-extension)
2. Тестируйте расширение в Researcherry
3. Публикуйте в Open VSX Registry
4. Документируйте особенности для пользователей Researcherry

## Полезные ссылки

- [Open VSX Registry](https://open-vsx.org/)
- [Документация по API расширений](https://code.visualstudio.com/api)
- [Руководство по публикации в Open VSX](https://github.com/eclipse/openvsx/wiki/Publishing-Extensions)

