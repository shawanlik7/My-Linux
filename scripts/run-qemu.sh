#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
iso="${1:-}"

if [ -z "$iso" ]; then
  iso="$(find "${repo_root}/out" -maxdepth 1 -type f -name 'homeplay-lite-*.iso' -printf '%T@ %p\n' 2>/dev/null | sort -nr | awk 'NR == 1 {print $2}')"
fi

if [ -z "$iso" ] || [ ! -f "$iso" ]; then
  printf 'ISO не найден. Сначала соберите образ: ./scripts/build-iso.sh\n' >&2
  exit 1
fi

if command -v run_archiso >/dev/null 2>&1; then
  exec run_archiso -u -i "$iso"
fi

if ! command -v qemu-system-x86_64 >/dev/null 2>&1; then
  printf 'qemu-system-x86_64 не найден.\n' >&2
  printf 'Установите QEMU: sudo pacman -S --needed qemu-desktop edk2-ovmf\n' >&2
  exit 1
fi

accel_args=()
if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
  accel_args=(-enable-kvm -cpu host)
fi

exec qemu-system-x86_64 \
  "${accel_args[@]}" \
  -m 2048 \
  -smp 2 \
  -vga virtio \
  -display gtk \
  -boot d \
  -cdrom "$iso"
