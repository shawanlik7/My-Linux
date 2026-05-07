#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
profile_dir="${repo_root}/homeplay-lite"
work_dir="${WORK_DIR:-${repo_root}/work}"
out_dir="${OUT_DIR:-${repo_root}/out}"
cache_dir="${PACMAN_CACHE_DIR:-${repo_root}/.cache/pacman/pkg}"
generated_pacman_conf="${repo_root}/.cache/pacman-homeplay.conf"

if ! command -v mkarchiso >/dev/null 2>&1; then
  printf 'mkarchiso не найден.\n' >&2
  printf 'Установите archiso: sudo pacman -S --needed archiso\n' >&2
  exit 1
fi

mkdir -p "$work_dir" "$out_dir" "$cache_dir" "$(dirname "$generated_pacman_conf")"

sed "/^\\[options\\]/a CacheDir = ${cache_dir}/" \
  "${profile_dir}/pacman.conf" >"$generated_pacman_conf"

if [ "${EUID}" -ne 0 ]; then
  exec sudo mkarchiso -v -C "$generated_pacman_conf" -w "$work_dir" -o "$out_dir" "$profile_dir"
fi

exec mkarchiso -v -C "$generated_pacman_conf" -w "$work_dir" -o "$out_dir" "$profile_dir"
