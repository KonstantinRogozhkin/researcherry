---
trigger: always_on
---

## 🚀 Researcherry: Шпаргалка для разработчика (старт за 5 минут)

Этот документ — ваш быстрый старт для работы с проектом.

### 1\. Что такое Researcherry?

  * **Суть проекта:** Это форк **VSCodium** (VS Code без телеметрии Microsoft), доработанный в no-code платформу AI-агентов для исследования клиентов.
  * **Цель:** Усилить экспертизу исследователей, а не заменить их. Ключевой принцип — **"human-in-the-loop"**.
  * **Текущий статус:** Активный ребрендинг и доработка VSCodium. Многие файлы и скрипты все еще содержат названия `VSCodium` или `codium`.

-----

### 2\. Ключевая архитектура: Патчи

Мы не редактируем код VSCodium напрямую. Все наши изменения — от брендинга до функциональности — реализованы через **систему патчей**.

  * **Где лежат патчи:** Все изменения находятся в директории `/patches/`.
  * **Как это работает:** Скрипт `prepare_vscode.sh` при сборке "накатывает" эти патчи на чистый исходный код VSCodium.
  * **Ваши изменения:** Любую новую доработку нужно оформлять как новый патч.

-----

### 3\. Быстрый старт: Сборка проекта

**Требования:**

  * **Node.js:** `v22.15.1` (это важно, другие версии могут вызвать ошибки).
  * **npm:** `v10.9.2+`.
  * **Скрипты:** Убедитесь, что все `.sh` скрипты имеют права на исполнение (`chmod +x *.sh`).

**Пошаговая сборка для разработки:**

1.  **Подготовка исходников VSCodium:**

    ```bash
    ./prepare_vscode.sh
    ```

    Этот скрипт скачает код VSCodium, установит зависимости и применит все патчи из папки `/patches/`.

2.  **Сборка проекта:**

    ```bash
    ./dev/build.sh
    ```

    Этот скрипт запустит основную сборку для вашей ОС. Готовое приложение появится в директории `VSCode-darwin-*`, `VSCode-linux-*` или `VSCode-win32-*`.

-----

### 4\. Как вносить изменения

#### А. Основные настройки и брендинг

Ключевые переменные, отвечающие за название приложения, репозиторий и т.д., находятся в файле `utils.sh`.

  * `APP_NAME`: "Researcherry"
  * `BINARY_NAME`: "researcherry"
  * `ORG_NAME`: "Researcherry"
  * `GH_REPO_PATH`: "KonstantinRogozhkin/researcherry"

Меняйте их здесь, и они применятся ко всему проекту во время сборки.

#### Б. Работа с патчами (основной процесс)

Если вам нужно исправить существующий патч или добавить новый:

1.  **Запустите скрипт обновления патчей:**
    ```bash
    ./dev/update_patches.sh
    ```
2.  **Решите конфликты:** Скрипт остановится, если не сможет применить какой-то патч. Откройте папку `vscode/` в другом редакторе, найдите файлы с расширением `.rej` и вручную внесите нужные изменения.
3.  **Сгенерируйте новый патч:** После решения конфликтов вернитесь в терминал и нажмите любую клавишу. Скрипт автоматически обновит файл патча.

#### В. Иконки

Все иконки генерируются из SVG-исходников в папке `/icons/`.

  * **Документация:** `ICON_DOCUMENTATION.md`.
  * **Основной скрипт для создания иконок:** `create_icon_with_padding.sh`. Он создает иконки с правильными отступами для всех ОС.
  * **Скрипт для применения иконок:** `update_icon.sh`.

-----

### 5\. Структура проекта: Ключевые файлы и папки

  * `dev/build.sh`: **Ваш главный скрипт** для локальной сборки.
  * `prepare_vscode.sh`: Подготавливает исходники VSCodium и применяет патчи.
  * `utils.sh`: Глобальные переменные для брендинга.
  * `patches/`: **Сердце проекта.** Здесь все наши кастомные изменения.
  * `icons/`: Исходники и скрипты для генерации иконок приложения.
  * `.github/workflows/`: CI/CD для автоматической сборки и релизов.
  * `BUILD_TROUBLESHOOTING.md`: Руководство по решению проблем со сборкой.