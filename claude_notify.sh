#!/bin/bash
set -euo pipefail

read message title < <(jq -r '.message, .title')

~/dotfiles/wsl_notify.sh "$title" "$message"
