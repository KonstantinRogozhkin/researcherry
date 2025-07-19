#!/bin/bash

# Скрипт для применения патчей локализации Researcherry

# Проверка наличия директории vscode
if [ ! -d "vscode" ]; then
  echo "Ошибка: директория vscode не найдена. Запустите скрипт из корневой директории проекта Researcherry."
  exit 1
fi

echo "Применение патчей локализации для Researcherry..."

# Применение патча для принудительной установки русского языка
echo "Применение патча для принудительной установки русского языка..."
cd vscode || exit 1
patch -p1 < ../patches/force-russian-locale.patch
if [ $? -ne 0 ]; then
  echo "Ошибка при применении патча force-russian-locale.patch"
  cd ..
  exit 1
fi
cd ..

# Применение патча для добавления русского языкового пакета
echo "Применение патча для добавления русского языкового пакета..."
patch -p1 < patches/add-russian-pack.patch
if [ $? -ne 0 ]; then
  echo "Ошибка при применении патча add-russian-pack.patch"
  exit 1
fi

# Применение патча для русификации страницы приветствия
echo "Применение патча для русификации страницы приветствия..."
cd vscode || exit 1
patch -p1 < ../patches/welcome-page-russian.patch
if [ $? -ne 0 ]; then
  echo "Ошибка при применении патча welcome-page-russian.patch"
  cd ..
  exit 1
fi
cd ..

echo "Все патчи успешно применены!"
echo "Теперь вы можете собрать Researcherry с русской локализацией."
