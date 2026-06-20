#!/usr/bin/env bash
set -euo pipefail

INSTALLER_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.sh"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

run_if_claude_exists() {
  if command -v claude >/dev/null 2>&1; then
    "$@" || true
  fi
}

echo "Resetting JuriSupport Claude Code plugins..."

refresh_path
if command -v claude >/dev/null 2>&1; then
  run_if_claude_exists claude mcp remove jurisupport
  run_if_claude_exists claude plugin uninstall jurisupport-lawyer-profile --prune -y
  run_if_claude_exists claude plugin uninstall jurisupport --prune -y
  run_if_claude_exists claude plugin marketplace remove jurisupport-lawyer-profile-plugin
  run_if_claude_exists claude plugin marketplace remove jurisupport-plugins
else
  echo "Claude Code is not currently installed. Continuing with a fresh install."
fi

curl -fsSL "$INSTALLER_URL" | bash
