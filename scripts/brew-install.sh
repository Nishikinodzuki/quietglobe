#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found: https://brew.sh" >&2
  exit 1
fi

export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=credential.helper
export GIT_CONFIG_VALUE_0=
export HOMEBREW_NO_AUTO_UPDATE=1

exec brew install --cask Nishikinodzuki/tap/quietglobe
