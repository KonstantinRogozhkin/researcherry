# 🚨 Решение проблемы: Изменения не применяются

## Проблема
При тестировании изменений Welcome Screen они не отображаются в приложении, даже после пересборки.

## 🔍 Диагностика проблемы

### Выявленные причины:
1. **Node.js не настроен** - команда `npm` не найдена
2. **Патчи не применены** - файл `gettingStartedContent.ts` содержит стандартный VS Code контент
3. **Конфликты патчей** - многие патчи не применяются из-за изменений в базовом коде

### Проверка проблемы:
```bash
# Проверить окружение
./dev/welcome_dev_fixed.sh check

# Проверить применение патчей
./dev/welcome_dev_fixed.sh verify
```

---

## ✅ Пошаговое решение

### Шаг 1: Настройка Node.js
```bash
# Установка Node.js через Homebrew (если не установлен)
brew install node@22

# Проверка установки
/opt/homebrew/opt/node@22/bin/node --version  # Должно показать v22.x.x
```

### Шаг 2: Применение патчей с правильным окружением
```bash
# Запуск подготовки с настроенным Node.js
./dev/prepare_with_node.sh
```

### Шаг 3: Проверка применения изменений
```bash
# Проверить, что патчи применились
./dev/welcome_dev_fixed.sh verify

# Должно показать:
# ✅ Патч Welcome Screen применен
# 📝 Найденные изменения:
# 133:		title: localize('gettingStarted.researcherry.title', "Добро пожаловать в ResearcherryAI"),
```

### Шаг 4: Быстрое тестирование
```bash
# Полный тест (проверка + сборка + запуск)
./dev/welcome_dev_fixed.sh test
```

---

## 🛠️ Инструменты для диагностики

### Скрипт диагностики: `./dev/welcome_dev_fixed.sh`

**Команды:**
- `check` - Проверка окружения (Node.js, npm)
- `verify` - Проверка применения патчей
- `patch` - Попытка применить патч вручную
- `test` - Полный тест (проверка + сборка + запуск)
- `build` - Только пересборка
- `launch` - Только запуск приложения

### Скрипт подготовки: `./dev/prepare_with_node.sh`
- Настраивает PATH для Node.js
- Запускает `prepare_vscode.sh` с правильным окружением

---

## 🔄 Правильный workflow разработки

### 1. Первоначальная настройка (один раз)
```bash
# Установка Node.js
brew install node@22

# Подготовка кода с патчами
./dev/prepare_with_node.sh

# Проверка готовности
./dev/welcome_dev_fixed.sh verify
```

### 2. Разработка и тестирование
```bash
# Редактирование файла
./dev/welcome_dev_fixed.sh edit

# Быстрое тестирование изменений
./dev/welcome_dev_fixed.sh test

# Или только пересборка
./dev/welcome_dev_fixed.sh build
```

### 3. Проверка результата
- Приложение запустится автоматически
- Откройте Welcome Screen: `Cmd+Shift+P` → "Welcome"
- Проверьте наличие изменений ResearcherryAI

---

## ⚠️ Частые ошибки и решения

### "npm: command not found"
**Причина:** Node.js не в PATH  
**Решение:** Используйте `./dev/prepare_with_node.sh` вместо `./prepare_vscode.sh`

### "Патч Welcome Screen НЕ применен"
**Причина:** Конфликты патчей или неправильная подготовка  
**Решение:** 
1. Удалите папку `vscode`
2. Запустите `./dev/prepare_with_node.sh`
3. Проверьте `./dev/welcome_dev_fixed.sh verify`

### "Изменения не видны в приложении"
**Причина:** Нужен перезапуск приложения  
**Решение:** 
1. Закройте Researcherry
2. Запустите `./dev/welcome_dev_fixed.sh launch`
3. Откройте Welcome Screen заново

### "Ошибки компиляции TypeScript"
**Причина:** Синтаксические ошибки в коде  
**Решение:** 
1. Проверьте файл `./dev/welcome_dev_fixed.sh edit`
2. Исправьте ошибки
3. Повторите `./dev/welcome_dev_fixed.sh build`

---

## 📊 Проверочный чек-лист

Перед началом разработки убедитесь:

- [ ] ✅ Node.js v22.x установлен (`node --version`)
- [ ] ✅ npm доступен (`npm --version`)
- [ ] ✅ Патчи применены (`./dev/welcome_dev_fixed.sh verify`)
- [ ] ✅ Файл содержит "ResearcherryAI" (`grep ResearcherryAI vscode/src/vs/workbench/contrib/welcomeGettingStarted/common/gettingStartedContent.ts`)
- [ ] ✅ Приложение собирается (`./dev/welcome_dev_fixed.sh build`)
- [ ] ✅ Welcome Screen показывает изменения

---

## 🎯 Быстрый старт (для нового окружения)

```bash
# 1. Установка зависимостей
brew install node@22

# 2. Подготовка кода
./dev/prepare_with_node.sh

# 3. Проверка готовности
./dev/welcome_dev_fixed.sh verify

# 4. Тестирование
./dev/welcome_dev_fixed.sh test

# ✅ Готово! Изменения должны быть видны в Welcome Screen
```

**Время выполнения:** ~10-15 минут (включая загрузку зависимостей)  
**Результат:** Полностью рабочее окружение для разработки Welcome Screen
