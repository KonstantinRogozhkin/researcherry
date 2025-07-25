# Участие в разработке

:+1::tada: Прежде всего, спасибо за то, что нашли время внести свой вклад! :tada::+1:

#### Содержание

- [Кодекс поведения](#кодекс-поведения)
- [Сообщение об ошибках](#сообщение-об-ошибках)
- [Внесение изменений](#внесение-изменений)

## Кодекс поведения

Этот проект и все участвующие в нем люди руководствуются [Кодексом поведения Researcherry](CODE_OF_CONDUCT.md). Участвуя в проекте, вы обязуетесь соблюдать этот кодекс.

## Сообщение об ошибках

### Перед созданием issue

Перед созданием отчетов об ошибках проверьте существующие issues и [страницу устранения неполадок](../BUILD_TROUBLESHOOTING.md), возможно, вам не нужно создавать новый.
При создании отчета об ошибке включите как можно больше деталей. Заполните [требуемый шаблон](https://github.com/KonstantinRogozhkin/researcherry/issues/new?&labels=bug&&template=bug_report.md), информация в нем помогает нам быстрее решать проблемы.

## Внесение изменений

Если вы хотите внести изменения, прочитайте [Полное руководство по сборке](РУКОВОДСТВО_ПО_СБОРКЕ.md).

### Сборка Researcherry

Для сборки Researcherry следуйте командам из раздела [Быстрый старт](РУКОВОДСТВО_ПО_СБОРКЕ.md#быстрый-старт).

### Обновление патчей

Если вы хотите обновить существующие патчи, используйте скрипт `./dev/update_patches.sh`.

### Добавление нового патча

- сначала соберите Researcherry
- затем используйте команду `./dev/patch.sh <имя_вашего_патча>` для создания нового патча
- когда скрипт остановится на `Press any key when the conflict have been resolved...`, откройте папку `vscode` в **Researcherry**
- запустите `npm run watch`
- запустите `./script/code.sh`
- внесите свои изменения
- нажмите любую клавишу для продолжения скрипта `patch.sh`
