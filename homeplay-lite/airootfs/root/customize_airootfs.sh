#!/usr/bin/env bash
set -euo pipefail

locale-gen
ldconfig

# Avoid expensive first-boot maintenance jobs in the live session.
touch /etc/.updated /var/.updated
