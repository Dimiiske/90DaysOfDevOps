#!/bin/bash

set -eo pipefail

check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Need sudo" >&2
    exit 1
  fi
}

set_passwd() {
  local username="$1"
  local green="\033[1;32m"
  local yellow="\033[1;33m"
  local default="\033[0m"

  echo -e "$yellow Set password for user $username $default"
  if ! passwd "$username"; then
    delete_user "$username"
    exit 1
  fi
}

check_user() {
  local username="$1"

  if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
    echo "Wrong username $username"
    exit 1
  fi

  if id -u "$username" &>/dev/null; then
    echo "User $username exists"
    return 1
  else
    echo "User $username does not exist"
  fi
}

create_user() {
  local username="$1"
  local path="/home/$username"
  local shell="/bin/bash"
  local green="\033[1;32m"
  local yellow="\033[1;33m"
  local default="\033[0m"

  echo -e "$yellow Adding new user with name $username $default"
  useradd -d "$path" -m -s "$shell" "$username" &>/dev/null

  set_passwd "$username"

  echo -e "$green User $username added $default"
}

delete_user() {
  local username="$1"
  local green="\033[1;32m"
  local default="\033[0m"

  userdel -r "$username" &>/dev/null

  echo -e "$green User $username deleted $default"
}

list_users() {
  cat /etc/passwd | awk -F: '$3 >= 1000 && $3 != 65534 {print $1, $3}'
}

help() {
    echo "usage: user_management.sh [OPTIONS] [USERNAME]"
    echo "Commands:"
    echo "-c, --create   create user with username"
    echo "-d, --delete   delete user with username"
    echo "-r, --reset    reset username's password"
    echo "-l, --list     show all users"
    echo "-h, --help     help option"
}

parse_flag() {
  local flag="$1"
  local username="$2"
  if [ "$flag" == "-c" ] || [ "$flag" == "--create" ]; then
    if check_user "$username"; then
      create_user "$username"
    fi
  elif [ "$flag" == "-d" ] || [ "$flag" == "--delete" ]; then
    if ! check_user "$username"; then
      delete_user "$username"
    fi
  elif [ "$flag" == "-r" ] || [ "$flag" == "--reset" ]; then
    if ! check_user "$username"; then
      set_passwd "$username"
    fi
  elif [ "$flag" == "-l" ] || [ "$flag" == "--list" ]; then
    list_users
  elif [ "$flag" == "-h" ] || [ "$flag" == "--help" ]; then
    help
  else
    echo "Unknown option"
  fi
}

main() {
  local flag="$1"
  local username="$2"

  check_root
  parse_flag "$flag" "$username"
}

main "$@"