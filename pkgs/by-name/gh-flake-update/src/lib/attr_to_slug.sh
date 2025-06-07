# shellcheck shell=bash

attr_to_slug() { echo "$1" | tr '.' '-'; }
