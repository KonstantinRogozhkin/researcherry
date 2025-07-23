<!-- order: 25 -->

# Использование

## Содержание

- [Вход через GitHub](#signin-github)
- [Аутентификация аккаунтов](https://github.com/KonstantinRogozhkin/researcherry/blob/master/docs/accounts-authentication.md)
- [Как запустить Researcherry в портативном режиме?](#portable)
- [Как исправить файловый менеджер по умолчанию?](#file-manager)
- [Как настроить повтор клавиш в Researcherry?](#press-and-hold)
- [Как открыть Researcherry из терминала?](#terminal-support)
  - [Из Linux .tar.gz](#from-linux-targz)

## <a id="signin-github"></a>Вход через GitHub

В Researcherry `Вход через GitHub` использует Personal Access Token.<br />
Следуйте документации https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token для создания токена.<br />
Выберите области доступа в зависимости от расширения, которому нужен доступ к GitHub. (GitLens требует область `repo`.)

### Linux

Если вы получаете ошибку `Writing login information to the keychain failed with error 'The name org.freedesktop.secrets was not provided by any .service files'.`, вам нужно установить пакет `gnome-keyring`.

## <a id="portable"></a>Как запустить Researcherry в портативном режиме?
Вы можете следовать [инструкциям по портативному режиму](https://code.visualstudio.com/docs/editor/portable) с сайта Visual Studio Code.
- **Windows** / **Linux**: инструкции можно выполнять как написано.
- **macOS**: портативный режим включается наличием специально названной папки. Для Visual Studio Code эта папка называется `code-portable-data`. Для Researcherry эта папка называется `researcherry-portable-data`. Чтобы включить портативный режим для Researcherry на Mac OS, следуйте инструкциям по [ссылке выше](https://code.visualstudio.com/docs/editor/portable), но создайте папку с именем `researcherry-portable-data` вместо `code-portable-data`.

## <a id="file-manager"></a>Как исправить файловый менеджер по умолчанию (Linux)?

В некоторых случаях Researcherry становится файловым менеджером для открытия директорий (вместо приложений типа Dolphin или Nautilus).<br />
Это происходит из-за того, что не было определено приложение по умолчанию для файлового менеджера, и система использует последнее подходящее приложение.

Чтобы установить приложение по умолчанию, создайте файл `~/.config/mimeapps.list` с содержимым:
```
[Default Applications]
inode/directory=org.gnome.Nautilus.desktop;
```

Вы можете найти ваш обычный файловый менеджер командой:
```
> grep directory /usr/share/applications/mimeinfo.cache
inode/directory=researcherry.desktop;org.gnome.Nautilus.desktop;
```

## <a id="press-and-hold"></a>Как настроить повтор клавиш в Researcherry (Mac)?

Это частый вопрос для Visual Studio Code, и процедура немного отличается в Researcherry, потому что путь `defaults` другой.

```bash
$ defaults write com.researcherry ApplePressAndHoldEnabled -bool false
```

## <a id="terminal-support"></a>Как открыть Researcherry из терминала?

Для macOS и Windows:
- Перейдите в палитру команд (View | Command Palette...)
- Выберите `Shell command: Install 'researcherry' command in PATH`.

![](https://user-images.githubusercontent.com/2707340/60140295-18338a00-9766-11e9-8fda-b525b6f15c13.png)

Это позволяет открывать файлы или директории в Researcherry напрямую из терминала:

```bash
~/in-my-project $ researcherry . # открыть эту директорию
~/in-my-project $ researcherry file.txt # открыть этот файл
```

Вы можете создать алиас для этой команды в вашем профиле оболочки для более удобного ввода (например, `alias code=researcherry`).

В Linux, при установке через пакетный менеджер, `researcherry` устанавливается в ваш `PATH`.

### <a id="from-linux-targz"></a>Из Linux .tar.gz

Когда архив `Researcherry-linux-<arch>-<version>.tar.gz` извлечен, основная точка входа для Researcherry — `./bin/researcherry`.
