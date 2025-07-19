#!/bin/bash

# Закрываем приложение
killall Researcherry 2>/dev/null || true

# Удаляем файлы кеша иконок
rm -rf ~/Library/Caches/com.apple.iconservices.store 2>/dev/null || true
rm -rf ~/Library/Caches/com.apple.dock.iconcache 2>/dev/null || true
find ~/Library/Caches -name "*.iconcache" -delete 2>/dev/null || true

# Удаляем приложение из дока
defaults delete com.apple.dock persistent-apps 2>/dev/null || true

# Перезапускаем Dock
killall Dock

# Ждем перезапуска Dock
sleep 2

# Изменяем время модификации приложения и его Info.plist
touch VSCode-darwin-arm64/Researcherry.app
touch VSCode-darwin-arm64/Researcherry.app/Contents/Info.plist

# Проверяем, что иконка указана правильно в Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleIconFile" VSCode-darwin-arm64/Researcherry.app/Contents/Info.plist

echo "Кеш иконок очищен. Теперь запустите приложение заново."
