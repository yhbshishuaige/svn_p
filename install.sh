#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE="$SCRIPT_DIR/svn_p"
TARGET=${1:-/usr/bin/svn_p}
TARGET_DIR=$(dirname -- "$TARGET")

if [ ! -f "$SOURCE" ]; then
  echo "install.sh: cannot find $SOURCE" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  mkdir -p "$TARGET_DIR"
  install -m 755 "$SOURCE" "$TARGET"
elif [ -d "$TARGET_DIR" ] && [ -w "$TARGET_DIR" ]; then
  install -m 755 "$SOURCE" "$TARGET"
elif command -v sudo >/dev/null 2>&1; then
  sudo mkdir -p "$TARGET_DIR"
  sudo install -m 755 "$SOURCE" "$TARGET"
else
  echo "install.sh: installing to $TARGET needs root permission; run with sudo or choose another target" >&2
  echo "example: ./install.sh ~/.local/bin/svn_p" >&2
  exit 1
fi

printf 'installed: %s\n' "$TARGET"
printf 'hint: if your shell cached an old svn_p path, run: hash -r\n'
