# Руководство по решению проблем сборки Researcherry

## 🚨 Распространенные проблемы

### 1. Ошибка ES модулей (`ERR_REQUIRE_ESM`)

**Проблема**: 
```
Error [ERR_REQUIRE_ESM]: require() of ES Module @electron/get not supported
```

**Причина**: Новые версии `@electron/get` используют ES модули, но VSCode пытается загрузить их через `require()`.

**Решения**:

#### А. Использовать правильную версию Node.js (рекомендуется)
```bash
# Проверить требуемую версию
cat .nvmrc

# Установить и использовать правильную версию
nvm install 22.15.1
nvm use 22.15.1

# Переустановить зависимости
cd vscode
rm -rf node_modules
npm cache clean --force
npm install
```

#### Б. Применить патч для совместимости
```bash
# Применить созданный патч
git apply patches/fix-electron-esm.patch
```

### 2. Проблемы с зависимостями

**Проблема**: Ошибки при установке npm пакетов

**Решение**:
```bash
# Очистить все кэши
npm cache clean --force
rm -rf vscode/node_modules
rm -rf ~/.npm

# Переустановить
cd vscode
npm install
```

### 3. Проблемы с правами доступа

**Проблема**: Permission denied при сборке

**Решение**:
```bash
# Убедиться, что скрипты исполняемые
chmod +x build.sh
chmod +x dev/build.sh
chmod +x prepare_vscode.sh
```

## ✅ Проверка готовности к сборке

Запустите этот чеклист перед сборкой:

```bash
# 1. Проверить версию Node.js
node --version  # Должно быть v22.15.1

# 2. Проверить версию npm
npm --version   # Должно быть v10.9.2 или новее

# 3. Проверить наличие зависимостей
ls vscode/node_modules | wc -l  # Должно быть > 100

# 4. Проверить инструменты сборки иконок
which convert rsvg-convert icns2png png2icns icotool

# 5. Запустить тест ребрендинга
./test_branding.sh
```

## 🔧 Пошаговая сборка

### 1. Подготовка окружения
```bash
# Убедиться в правильной версии Node.js
nvm use 22.15.1

# Установить инструменты (если не установлены)
brew install imagemagick libicns icoutils librsvg
```

### 2. Подготовка исходного кода
```bash
# Запустить подготовку (если еще не запускалась)
./prepare_vscode.sh
```

### 3. Установка зависимостей
```bash
cd vscode
npm install
```

### 4. Сборка
```bash
# Из корня проекта
./dev/build.sh

# Или для полной сборки
./build.sh
```

## 📊 Мониторинг сборки

### Проверка прогресса
```bash
# Проверить процессы Node.js
ps aux | grep node

# Проверить использование памяти
top -pid $(pgrep node)

# Проверить логи npm
tail -f ~/.npm/_logs/*-debug-*.log
```

### Типичное время сборки
- **Установка зависимостей**: 5-15 минут
- **Компиляция TypeScript**: 2-5 минут  
- **Сборка расширений**: 3-10 минут
- **Упаковка**: 1-3 минуты

**Общее время**: 15-45 минут (в зависимости от машины)

## 🆘 Если ничего не помогает

1. **Полная очистка**:
```bash
# Удалить все временные файлы
rm -rf vscode
rm -rf node_modules
git clean -fdx

# Начать сначала
./prepare_vscode.sh
```

2. **Проверить системные требования**:
- macOS 10.15+ / Linux / Windows 10+
- Node.js v22.15.1
- npm v10.9.2+
- 8GB+ RAM
- 10GB+ свободного места

3. **Обратиться за помощью**:
- Проверить issues в оригинальном репозитории VSCodium
- Создать issue с полным логом ошибки
- Указать версию ОС и Node.js
