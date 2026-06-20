#!/usr/bin/env bash
set -euo pipefail

INSTALLER_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.sh"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

remove_if_present() {
  if command -v claude >/dev/null 2>&1; then
    "$@" >/dev/null 2>&1 || true
  fi
}

echo "Resetting JuriSupport Claude Code plugins... / JuriSupport Claude Code 플러그인 설정을 초기화합니다..."

refresh_path
if command -v claude >/dev/null 2>&1; then
  remove_if_present claude mcp remove jurisupport
  remove_if_present claude plugin uninstall jurisupport-lawyer-profile --prune -y
  remove_if_present claude plugin uninstall jurisupport --prune -y
  remove_if_present claude plugin marketplace remove jurisupport-lawyer-profile-plugin
  remove_if_present claude plugin marketplace remove jurisupport-plugins
else
  echo "Claude Code is not currently installed. Continuing with a fresh install. / 현재 Claude Code가 설치되어 있지 않습니다. 새 설치로 계속 진행합니다."
fi

curl -fsSL "$INSTALLER_URL" | bash
