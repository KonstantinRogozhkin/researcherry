#!/usr/bin/env bash

# Скрипт для исправления проблемы с ES модулями в @vscode/gulp-electron

set -e

DOWNLOAD_FILE="vscode/node_modules/@vscode/gulp-electron/src/download.js"

if [[ ! -f "$DOWNLOAD_FILE" ]]; then
    echo "Файл $DOWNLOAD_FILE не найден. Убедитесь, что npm install завершен."
    exit 1
fi

echo "Исправляем проблему с ES модулями в $DOWNLOAD_FILE..."

# Создаем резервную копию
cp "$DOWNLOAD_FILE" "$DOWNLOAD_FILE.backup"

# Применяем исправления
sed -i '' 's/const { downloadArtifact } = require("@electron\/get");/\/\/ Fix for ES module compatibility\
let downloadArtifact;\
(async () => {\
  try {\
    const electronGet = await import("@electron\/get");\
    downloadArtifact = electronGet.downloadArtifact;\
  } catch (err) {\
    \/\/ Fallback for older versions\
    downloadArtifact = require("@electron\/get").downloadArtifact;\
  }\
})();/' "$DOWNLOAD_FILE"

# Добавляем проверку в функцию download
sed -i '' '/async function download(opts) {/,/if (!opts.version) {/ {
    /let bar;/a\
\
  \/\/ Wait for downloadArtifact to be ready\
  while (!downloadArtifact) {\
    await new Promise(resolve => setTimeout(resolve, 100));\
  }\

}' "$DOWNLOAD_FILE"

echo "✅ Исправление применено успешно!"
echo "📁 Резервная копия сохранена как $DOWNLOAD_FILE.backup"

# Проверяем, что файл содержит наши исправления
if grep -q "Wait for downloadArtifact to be ready" "$DOWNLOAD_FILE"; then
    echo "✅ Проверка: исправления найдены в файле"
else
    echo "❌ Ошибка: исправления не найдены, восстанавливаем из резервной копии"
    cp "$DOWNLOAD_FILE.backup" "$DOWNLOAD_FILE"
    exit 1
fi
