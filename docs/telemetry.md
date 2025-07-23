<!-- order: 10 -->

# Полное отключение телеметрии

Эта страница объясняет, как Researcherry обрабатывает телеметрию и как обеспечить вашу приватность.

## Содержание

- [Телеметрия в Researcherry](#telemetry)
- [Замена онлайн-сервисов Microsoft](#replacements)
- [Проверка телеметрии](#checking)
- [Дополнительные настройки приватности](#additional-settings)
- [Объявления Researcherry](#announcements)
- [Вредоносные и устаревшие расширения](#malicious-extensions)

## <a id="telemetry"></a>Телеметрия в Researcherry

Несмотря на то, что мы не передаем флаги сборки телеметрии (и делаем все возможное, чтобы отключить встроенную телеметрию), Microsoft все равно может отслеживать использование по умолчанию.

Однако мы устанавливаем значения по умолчанию `telemetry.enableTelemetry` и `telemetry.enableCrashReporter` в `false`. Вы можете увидеть их, просмотрев ваш файл `settings.json` в Researcherry и найдя `telemetry`.

Также настоятельно рекомендуется просмотреть все настройки, которые "используют онлайн-сервисы", следуя [этим инструкциям](https://code.visualstudio.com/docs/getstarted/telemetry#_managing-online-services). Фильтр `@tag:usesOnlineServices` на странице настроек покажет, что по умолчанию:

- Расширения автоматически проверяют обновления и автоматически устанавливают их
- Поиск в приложении отправляется в онлайн-сервис для "обработки естественного языка"
- Обновления приложения загружаются в фоновом режиме

Все это можно отключить.

__Обратите внимание, что некоторые расширения также отправляют данные телеметрии в Microsoft. Мы не можем это контролировать и можем только рекомендовать удалить такое расширение.__ _(Например, расширение C# `ms-vscode.csharp` отправляет данные отслеживания в Microsoft.)_

## <a id="replacements"></a>Замена онлайн-сервисов Microsoft

При поиске с фильтром `@tag:usesOnlineServices` обратите внимание, что хотя описание настройки "Update: Mode" все еще говорит "Обновления загружаются из онлайн-сервиса Microsoft", скрипт сборки Researcherry [устанавливает поле `updateUrl`](https://github.com/KonstantinRogozhkin/researcherry/blob/master/prepare_vscode.sh#L135) в `product.json` напрямую на страницу GitHub, поэтому включение этой настройки фактически не приведет к вызовам онлайн-сервиса Microsoft.

Аналогично, хотя описания для "Extensions: Auto Check Updates" и "Extensions: Auto Update" включают ту же фразу, Researcherry [заменяет](https://github.com/KonstantinRogozhkin/researcherry/blob/master/prepare_vscode.sh#L121) Visual Studio Marketplace на Open VSX, поэтому эти настройки также не будут обращаться к Microsoft.

## <a id="checking"></a>Проверка телеметрии

Если вы хотите убедиться, что телеметрия не отправляется, вы можете использовать инструменты мониторинга сети, такие как:

- Wireshark
- Little Snitch (macOS)
- GlassWire (Windows)

Ищите соединения с доменами Microsoft и конечными точками телеметрии.

## <a id="additional-settings"></a>Дополнительные настройки приватности

Для максимальной приватности вы можете добавить эти настройки в ваш `settings.json`:

```json
{
  "telemetry.enableTelemetry": false,
  "telemetry.enableCrashReporter": false,
  "telemetry.feedback.enabled": false,
  "update.enableWindowsBackgroundUpdates": false,
  "update.mode": "manual",
  "workbench.enableExperiments": false,
  "workbench.settings.enableNaturalLanguageSearch": false
}
```

Эти настройки отключат различные функции телеметрии и отслеживания.

## <a id="announcements"></a>Объявления Researcherry

Страница приветствия в Researcherry отображает объявления, которые загружаются из GitHub-репозитория проекта.

Если вы предпочитаете отключить эту функцию, вы можете установить настройку `workbench.welcomePage.extraAnnouncements` в `false` в вашем `settings.json`.

## <a id="malicious-extensions"></a>Вредоносные и устаревшие расширения

Определения вредоносных и устаревших расширений динамически загружаются по следующему URL:
https://raw.githubusercontent.com/EclipseFdn/publish-extensions/refs/heads/master/extension-control/extensions.json.

Если вы предпочитаете избежать любых внешних соединений, вы можете установить настройку `extensions.excludeUnsafes` в `false` в вашем `settings.json`.
Однако это не рекомендуется, так как это может снизить безопасность вашей среды.
