#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="homeplay-lite"
iso_label="HOMEPLAY_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="HomePlay Lite OS <https://github.com/shawanlik7/My-Linux>"
iso_application="HomePlay Lite OS Live ISO"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/passwd"]="0:0:644"
  ["/etc/shadow"]="0:0:400"
  ["/etc/pam.d/lightdm"]="0:0:644"
  ["/etc/sudoers.d/10-homeplay-live"]="0:0:440"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/homeplay-first-run"]="0:0:755"
  ["/usr/local/bin/homeplay-help"]="0:0:755"
  ["/usr/local/bin/homeplay-live-setup"]="0:0:755"
  ["/usr/local/bin/homeplay-old-games-hub"]="0:0:755"
  ["/usr/local/bin/homeplay-open-folder"]="0:0:755"
  ["/usr/local/bin/homeplay-update"]="0:0:755"
  ["/usr/local/bin/homeplay-xfce-setup"]="0:0:755"
)
