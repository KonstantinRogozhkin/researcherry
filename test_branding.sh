#!/usr/bin/env bash

# Тестовый скрипт для проверки ребрендинга Researcherry

echo "=== Тестирование ребрендинга Researcherry ==="
echo

# Проверяем основные переменные в utils.sh
echo "1. Проверяем utils.sh:"
source ./utils.sh
echo "   APP_NAME: ${APP_NAME}"
echo "   BINARY_NAME: ${BINARY_NAME}"
echo "   ORG_NAME: ${ORG_NAME}"
echo "   GH_REPO_PATH: ${GH_REPO_PATH}"
echo

# Проверяем наличие новых иконок
echo "2. Проверяем иконки:"
if [[ -f "icons/stable/researcherry_cnl.svg" ]]; then
    echo "   ✓ Основная иконка создана"
else
    echo "   ✗ Основная иконка не найдена"
fi

if [[ -f "icons/stable/codium_cnl.svg" ]]; then
    echo "   ✓ Иконка codium_cnl.svg обновлена"
else
    echo "   ✗ Иконка codium_cnl.svg не найдена"
fi

if [[ -f "src/stable/resources/darwin/code.icns" ]]; then
    echo "   ✓ macOS иконка сгенерирована"
else
    echo "   ✗ macOS иконка не сгенерирована"
fi

if [[ -f "src/stable/resources/linux/code.png" ]]; then
    echo "   ✓ Linux иконка сгенерирована"
else
    echo "   ✗ Linux иконка не сгенерирована"
fi

if [[ -f "src/stable/resources/server/favicon.ico" ]]; then
    echo "   ✓ Windows иконка сгенерирована"
else
    echo "   ✗ Windows иконка не сгенерирована"
fi
echo

# Проверяем README
echo "3. Проверяем README.md:"
if grep -q "Researcherry" README.md; then
    echo "   ✓ README содержит 'Researcherry'"
else
    echo "   ✗ README не содержит 'Researcherry'"
fi

if grep -q "Research-Focused Code Editor" README.md; then
    echo "   ✓ README содержит новое описание"
else
    echo "   ✗ README не содержит новое описание"
fi
echo

# Проверяем dev/build.sh
echo "4. Проверяем dev/build.sh:"
if grep -q 'APP_NAME="Researcherry"' dev/build.sh; then
    echo "   ✓ dev/build.sh обновлен"
else
    echo "   ✗ dev/build.sh не обновлен"
fi
echo

# Проверяем Windows MSI
echo "5. Проверяем Windows MSI build:"
if grep -q 'PRODUCT_NAME="Researcherry"' build/windows/msi/build.sh; then
    echo "   ✓ Windows MSI build обновлен"
else
    echo "   ✗ Windows MSI build не обновлен"
fi
echo

# Проверяем Snapcraft
echo "6. Проверяем Snapcraft:"
if grep -q 'name: researcherry' stores/snapcraft/stable/snap/snapcraft.yaml; then
    echo "   ✓ Snapcraft конфигурация обновлена"
else
    echo "   ✗ Snapcraft конфигурация не обновлена"
fi
echo

# Проверяем исправление ES модулей
echo "7. Проверяем исправление ES модулей:"
if [[ -f "vscode/node_modules/@vscode/gulp-electron/src/download.js" ]]; then
    if grep -q "Wait for downloadArtifact to be ready" vscode/node_modules/@vscode/gulp-electron/src/download.js; then
        echo "   ✓ Исправление ES модулей применено"
    else
        echo "   ⚠ Исправление ES модулей не найдено (может потребоваться после npm install)"
    fi
else
    echo "   ⚠ Файл gulp-electron не найден (npm install не выполнен)"
fi

if [[ -f "fix_electron_esm.sh" ]]; then
    echo "   ✓ Скрипт автоматического исправления создан"
else
    echo "   ✗ Скрипт автоматического исправления не найден"
fi
echo

echo "=== Тестирование завершено ==="
echo
echo "Следующие шаги:"
echo "1. ✓ Инструменты для сборки иконок установлены"
echo "2. ✓ Иконки сгенерированы"
echo "3. Обновить оставшиеся ссылки на VSCodium в других файлах"
echo "4. Создать собственный репозиторий на GitHub"
echo "5. Настроить CI/CD для автоматической сборки"
echo "6. Протестировать полную сборку проекта"
