#!/usr/bin/env bash
set -euo pipefail

locale-gen
ldconfig

groupadd -f autologin
groupadd -f nopasswdlogin

for group in wheel audio video optical storage power network lp scanner autologin nopasswdlogin; do
  getent group "$group" >/dev/null 2>&1 || groupadd "$group"
done

if ! id -u homeplay >/dev/null 2>&1; then
  useradd -m -U -c "HomePlay User" -s /bin/bash homeplay
fi

usermod -aG wheel,audio,video,optical,storage,power,network,lp,scanner,autologin,nopasswdlogin homeplay
passwd -d homeplay >/dev/null

if [ -d /etc/skel ] && [ -d /home/homeplay ]; then
  rsync -a --ignore-existing /etc/skel/ /home/homeplay/
  chown -R homeplay:homeplay /home/homeplay
fi

# Avoid expensive first-boot maintenance jobs in the live session.
touch /etc/.updated /var/.updated
