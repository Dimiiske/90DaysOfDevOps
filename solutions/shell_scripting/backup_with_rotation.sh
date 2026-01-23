#!/bin/bash

set -euo pipefail

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Need sudo" >&2
    exit 1
  fi
}

check_dir() {
  local path="$1"

  if [ ! -d "$path" ]; then
    echo "Directory does not exist!"
    exit 1
  fi
}

create_backup() {
  local path="$1"
  local date=$(date "+%Y-%m-%d_%H-%M-%S")
  local name="backup_$date"
  local green="\033[1;32m"
  local default="\033[0m"

  rsync -av "$path/" "$path/$name/"
  echo -e "$green Backup created: $path/$name $default"
}

remove_old() {
  local path="$1"

  ls -t "$path" | grep "backup_" | tail -n +4 | xargs rm -rf
}

main() {
  local path="$1"

  check_root
  check_dir "$path"
  create_backup "$path"
  remove_old "$path"
}

main "$@"