# Тестирование HomePlay Lite OS

## Быстрая проверка профиля

Перед сборкой проверь:

```bash
git status
bash -n scripts/build-iso.sh scripts/run-qemu.sh
find homeplay-lite/airootfs/usr/local/bin -type f -exec bash -n {} \;
```

Проверка пакетов без скачивания:

```bash
grep -vE '^\s*(#|$)' homeplay-lite/packages.x86_64 | xargs pacman -Sp --noconfirm >/dev/null
```

## QEMU

Сборка:

```bash
./scripts/build-iso.sh
```

Запуск:

```bash
./scripts/run-qemu.sh
```

Что проверить:

- ISO загружается в графический режим.
- Пользователь `homeplay` входит автоматически.
- Панель находится снизу, меню слева.
- На рабочем столе есть понятные ярлыки.
- Открываются Firefox, Thunar, Celluloid, LibreOffice.
- NetworkManager показывает сетевой апплет.
- `Игры` открывает Old Games Hub.
- `Обновить систему` показывает предупреждение, а не запускает терминал.

## VirtualBox

Настройки VM:

- Тип: Linux, Arch Linux 64-bit.
- RAM: 2048 MB для нормального теста.
- CPU: 2 ядра.
- Video Memory: 64 MB.
- EFI: можно проверить отдельно, но сначала проще BIOS.
- Storage: подключить ISO из `out/`.

Если XFCE не стартует, проверь LightDM:

```bash
systemctl status lightdm
journalctl -b -u lightdm
```

## Реальный слабый ноутбук

Минимально разумно:

- RAM: 2 GB для Firefox + LibreOffice.
- RAM: 1 GB возможно, но браузер и офис будут тяжелыми.
- CPU: двухъядерный x86_64 предпочтительно.
- GPU: для DXVK нужен Vulkan; без Vulkan использовать обычный Wine/OpenGL.

Перед записью на флешку проверь ISO в QEMU. Потом записывай обычным способом:

```bash
sudo dd if=out/homeplay-lite-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Будь осторожен: `/dev/sdX` нужно заменить на флешку, ошибка может стереть диск.
