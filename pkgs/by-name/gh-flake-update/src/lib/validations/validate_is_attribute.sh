# shellcheck shell=bash

validate_is_attribute() {
  if ! nix eval ".#$1" &>/dev/null; then
    echo "Attribute '$1' does not exist."
  fi
}
