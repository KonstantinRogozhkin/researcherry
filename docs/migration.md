<!-- order: 20 -->

# Миграция

## Содержание

- [Ручная миграция с Visual Studio Code на Researcherry](#manual-migration)
- [Полуавтоматическая миграция с расширением "Sync Settings"](#semi-automatic-migration)

## <a id="manual-migration"></a>Ручная миграция с Visual Studio Code на Researcherry

Researcherry (как и свеже склонированная копия vscode, собранная из исходного кода) хранит файлы расширений в `~/.vscode-oss`. Поэтому, если у вас установлен Visual Studio Code, ваши расширения не появятся автоматически. Вы можете скопировать папку `extensions` из `~/.vscode/extensions` в `~/.vscode-oss/extensions`.

Visual Studio Code хранит файлы `keybindings.json` и `settings.json` в следующих местах:

- __Windows__: `%APPDATA%\Code\User`
- __macOS__: `$HOME/Library/Application Support/Code/User`
- __Linux__: `$HOME/.config/Code/User`

Вы можете скопировать эти файлы в папку пользовательских настроек Researcherry:

- __Windows__: `%APPDATA%\Researcherry\User`
- __macOS__: `$HOME/Library/Application Support/Researcherry/User`
- __Linux__: `$HOME/.config/Researcherry/User`

Чтобы скопировать настройки вручную:

- В Visual Studio Code перейдите в Настройки (`Meta+,`)
- Нажмите на три точки `...` и выберите 'Открыть settings.json'
- Скопируйте содержимое settings.json в то же место в Researcherry

## <a id="semi-automatic-migration"></a>Полуавтоматическая миграция с расширением "Sync Settings"

Расширение [**Sync Settings**](https://github.com/zokugun/vscode-sync-settings) может упростить процесс миграции, позволяя синхронизировать настройки, горячие клавиши, расширения и многое другое между Visual Studio Code и Researcherry. Его автор является основным мейнтейнером VSCodium ;)

Расширение доступно в Visual Studio Marketplace, OpenVSX или напрямую в его GitHub-репозитории.

### Шаги:

1. Установите расширение **Sync Settings** в Visual Studio Code и Researcherry.
2. Настройте расширение в Visual Studio Code и Researcherry:
  - Откройте палитру команд (`Meta+Shift+P`).
  - Найдите `Sync Settings: Open the repository settings` и выполните команду.
  - Настройте репозиторий
3. Экспортируйте текущие настройки из Visual Studio Code:
  - Откройте палитру команд (`Meta+Shift+P`).
  - Найдите `Sync Settings: Upload (user -> repository)` и выполните команду.
4. Импортируйте настройки в Researcherry:
  - Рекомендую настройку `"syncSettings.openOutputOnActivity": true,`.
  - Откройте палитру команд (`Meta+Shift+P`).
  - Найдите `Sync Settings: Download (repository -> user)` и выполните команду.
  - Дождитесь загрузки и установки всех расширений (следите за логами в панели `Output`) перед перезапуском Researcherry.

Этот метод обеспечивает беспроблемную передачу всех поддерживаемых конфигураций.
