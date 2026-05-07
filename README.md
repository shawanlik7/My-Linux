# HomePlay Lite OS

HomePlay Lite OS - легкий Arch-based профиль для сборки домашнего ISO через `archiso`.

Цель проекта: простая система для слабого ноутбука, похожая на Windows по базовой логике: нижняя панель, меню слева, крупные ярлыки, минимум лишнего и отдельный Old Games Hub для старых Windows-игр.

## Что внутри

- База: Arch Linux, `archiso`, `pacman`, `systemd`.
- Рабочий стол: XFCE, LightDM, автологин live-пользователя `homeplay`.
- Сеть: NetworkManager, апплет Wi-Fi, firewall через `ufw`.
- Домашние программы: Firefox, LibreOffice Still, Celluloid/mpv, Audacious, Ristretto, Mousepad, Xarchiver, Thunar.
- Игры: Wine, Wine Mono/Gecko, Winetricks, Lutris, GameMode, 32-bit библиотеки для старых игр.
- Восстановление: Timeshift установлен, а скрипт обновления пытается создать snapshot перед обновлением, если Timeshift уже настроен.

Важно: DXVK не добавлен как отдельный пакет, потому что в официальных репозиториях Arch его обычно используют через Lutris/раннеры, а на старых ноутбуках без Vulkan он не поможет. Для NFS Most Wanted 2005 и S.T.A.L.K.E.R. чаще надежнее начинать с обычного Wine/OpenGL, а DXVK включать только если видеокарта поддерживает Vulkan.

## Структура проекта

```text
.
├── homeplay-lite/
│   ├── packages.x86_64
│   ├── pacman.conf
│   ├── profiledef.sh
│   └── airootfs/
│       ├── etc/
│       │   ├── lightdm/
│       │   ├── skel/
│       │   ├── sudoers.d/
│       │   ├── systemd/
│       │   └── xdg/autostart/
│       └── usr/
│           ├── local/bin/
│           └── share/homeplay/
├── scripts/
│   ├── build-iso.sh
│   └── run-qemu.sh
└── docs/
    ├── GAMES.md
    └── TESTING.md
```

## Сборка ISO

На Arch/Arch-based системе установи инструменты сборки:

```bash
sudo pacman -Syu
sudo pacman -S --needed archiso git
```

Собрать ISO:

```bash
./scripts/build-iso.sh
```

То же самое вручную:

```bash
sudo mkarchiso -v -w work -o out homeplay-lite
```

`mkarchiso` принимает путь к папке профиля `homeplay-lite`, а не путь к `profiledef.sh`.

Профиль использует явные официальные Arch-зеркала в `homeplay-lite/pacman.conf`. Это нужно, чтобы сборка не зависела от mirrorlist текущей Arch-based системы.

Скрипт `./scripts/build-iso.sh` дополнительно создает изолированный cache пакетов в `.cache/pacman/pkg`. Это важно на Manjaro/других Arch-based системах: нельзя смешивать пакеты хоста и чистого Arch ISO в общем `/var/cache/pacman/pkg`.

## Тестирование в QEMU

Установи QEMU:

```bash
sudo pacman -S --needed qemu-desktop edk2-ovmf
```

Запуск последнего ISO:

```bash
./scripts/run-qemu.sh
```

Запуск конкретного файла:

```bash
./scripts/run-qemu.sh out/homeplay-lite-YYYY.MM.DD-x86_64.iso
```

Если установлен `run_archiso`, скрипт использует его. Иначе запускается обычный `qemu-system-x86_64` с 2 GB RAM.

## Тестирование в VirtualBox

1. Создай VM типа `Linux / Arch Linux (64-bit)`.
2. RAM: 2048 MB для теста, 1024 MB допустимо для проверки загрузки.
3. CPU: 2 ядра, если есть.
4. Видеопамять: 64 MB.
5. Подключи ISO из папки `out/`.
6. Запусти VM и проверь автологин в XFCE, Wi-Fi апплет, звук, ярлыки и Old Games Hub.

## Как добавлять игры

1. Открой ярлык `Игры` на рабочем столе.
2. Выбери `Добавить NFS Most Wanted 2005` или `Добавить S.T.A.L.K.E.R.`.
3. Укажи файл запуска игры или установщик с диска/папки.
4. После добавления появится ярлык с понятным названием.
5. Если игра не запускается, открой `Игры` и выбери `Починить запуск игры`.

Используй только легальные копии игр. Проект не включает игры, ключи, crack-файлы или проприетарные установщики.

## Обновления

На рабочем столе есть приложение `Обновить систему`. Оно:

- предупреждает пользователя перед обновлением;
- пытается создать Timeshift snapshot, если Timeshift настроен;
- запускает обновление через `pacman`;
- показывает лог простым окном.

Для настоящего ноутбука лучше ставить систему на Btrfs и заранее настроить Timeshift. На live ISO snapshot не имеет смысла без постоянного хранилища.

## Предупреждения для слабого ноутбука

- Firefox и LibreOffice удобные, но не самые легкие. Если RAM меньше 2 GB, можно заменить LibreOffice на AbiWord/Gnumeric, а Firefox на более легкий браузер.
- Lutris удобен для игр, но тяжелее простых Wine-ярлыков.
- GameMode почти не нагружает систему, но не делает старое железо быстрее магически.
- DXVK нужен только при рабочей поддержке Vulkan. На старых Intel GMA, Radeon X/HD старых поколений и старых NVIDIA через Nouveau он может не работать.
- Не включай тяжелые эффекты XFCE: compositor отключен специально.

## GitHub

Обычный цикл разработки:

```bash
git status
git add .
git commit -m "Add HomePlay Lite OS archiso profile"
git push
```
