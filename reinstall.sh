#!/usr/bin/env bash
set -euo pipefail

INSTALLER_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.sh"
MARKETPLACE_URL="https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
MARKETPLACE_NAME="jurisupport-lawyer-profile-plugin"
PLUGIN_REF="jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

run_if_present() {
  local tool="$1"
  shift
  if command -v "$tool" >/dev/null 2>&1; then
    "$tool" "$@" >/dev/null 2>&1 || true
  fi
}

install_codex_plugin() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "Codex is not currently installed. Skipping Codex reinstall. / Codex가 설치되어 있지 않아 Codex 재설치는 건너뜁니다."
    return
  fi

  run_if_present codex plugin remove "$PLUGIN_REF"
  run_if_present codex plugin marketplace remove "$MARKETPLACE_NAME"
  codex plugin marketplace add "$MARKETPLACE_URL" >/dev/null
  codex plugin add "$PLUGIN_REF" >/dev/null
  echo "Codex plugin reinstalled. / Codex 플러그인 재설치가 완료되었습니다."
}

echo "Resetting JuriSupport Claude Code and Codex plugins... / JuriSupport Claude Code 및 Codex 플러그인 설정을 초기화합니다..."

refresh_path
if command -v claude >/dev/null 2>&1; then
  run_if_present claude mcp remove jurisupport
  run_if_present claude plugin uninstall jurisupport-lawyer-profile --prune -y
  run_if_present claude plugin uninstall jurisupport --prune -y
  run_if_present claude plugin marketplace remove jurisupport-lawyer-profile-plugin
  run_if_present claude plugin marketplace remove jurisupport-plugins
else
  echo "Claude Code is not currently installed. Continuing with a fresh install. / 현재 Claude Code가 설치되어 있지 않습니다. 새 설치로 계속 진행합니다."
fi

curl -fsSL "$INSTALLER_URL" | bash
install_codex_plugin
