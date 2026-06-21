#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_URL="https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
MARKETPLACE_NAME="jurisupport-lawyer-profile-plugin"
PLUGIN_REF="jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
PLUGIN_NAME="jurisupport-lawyer-profile"
CONNECT_MCP_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.sh"
JURISUPPORT_BOOTSTRAP_URL="https://raw.githubusercontent.com/jurisupport/jurisupport-plugins/main/bootstrap.sh"
LEGAL_TERMINAL_INSTALL_URL="https://raw.githubusercontent.com/jurisupport/legal-terminal/main/install-mac.sh"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

env_truthy() {
  case "${1:-}" in
    1|true|TRUE|yes|YES|y|Y|on|ON) return 0 ;;
    *) return 1 ;;
  esac
}

ask_yes_no() {
  local question="$1" answer=""
  if { exec 3<> /dev/tty; } 2>/dev/null; then
    printf "%s [Y/n] " "$question" >&3
    read -r answer <&3 || answer=""
    exec 3>&- 3<&-
  else
    return 1
  fi

  case "$answer" in
    [nN]|[nN][oO]) return 1 ;;
    *) return 0 ;;
  esac
}

jurisupport_plugins_installed() {
  [[ -f "$HOME/jurisupport-plugins/install.sh" ]] && return 0
  command -v claude >/dev/null 2>&1 || return 1
  claude plugin list 2>/dev/null | grep -E -q 'jurisupport@jurisupport-plugins|jurisupport-plugins|songmu-legal|korean-law'
}

install_jurisupport_plugins() {
  if env_truthy "${JURISUPPORT_LAWYER_PROFILE_SKIP_JURISUPPORT:-}"; then
    return
  fi

  if jurisupport_plugins_installed; then
    echo "jurisupport-plugins already looks installed. / jurisupport-plugins가 이미 설치된 것으로 보입니다."
    return
  fi

  if ! ask_yes_no "Install jurisupport-plugins first? / 먼저 JuriSupport 송무 플러그인 묶음을 설치할까요?"; then
    echo "Skipping jurisupport-plugins. / JuriSupport 송무 플러그인 설치를 건너뜁니다."
    return
  fi

  curl -fsSL "$JURISUPPORT_BOOTSTRAP_URL" \
    | JURISUPPORT_SKIP_LAWYER_PROFILE=1 JURISUPPORT_SKIP_LEGAL_TERMINAL=1 bash
  refresh_path
}

should_connect_mcp() {
  case "${JURISUPPORT_CONNECT_MCP:-}" in
    1|true|TRUE|yes|YES|y|Y) return 0 ;;
    0|false|FALSE|no|NO|n|N) return 1 ;;
  esac

  if [[ -n "${JURISUPPORT_MCP_TOKEN:-}" ]]; then
    return 0
  fi

  local claude_connected=1
  local codex_connected=0

  if command -v claude >/dev/null 2>&1 && claude mcp list 2>/dev/null | grep -q '^jurisupport:.*Connected'; then
    claude_connected=0
  fi

  if command -v codex >/dev/null 2>&1; then
    codex_connected=1
    codex mcp get jurisupport >/dev/null 2>&1 && codex_connected=0
  fi

  if [[ "$claude_connected" -eq 0 && "$codex_connected" -eq 0 ]]; then
    return 1
  fi

  local answer=""
  if { exec 3<> /dev/tty; } 2>/dev/null; then
    printf "Connect JuriSupport MCP now? If you have a token, choose y. [y/N] / 지금 JuriSupport MCP도 연결할까요? 토큰이 있으면 y를 누르세요. [y/N] " >&3
    read -r answer <&3 || answer=""
    exec 3>&- 3<&-
  else
    return 1
  fi

  case "$answer" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) return 1 ;;
  esac
}

install_legal_terminal() {
  if env_truthy "${JURISUPPORT_LAWYER_PROFILE_SKIP_LEGAL_TERMINAL:-}"; then
    return
  fi

  case "$(uname -s)" in
    Darwin*)
      ;;
    MINGW*|MSYS*|CYGWIN*)
      if ask_yes_no "Install legal-terminal too? / legal-terminal 앱도 설치할까요?"; then
        powershell.exe -NoProfile -ExecutionPolicy Bypass -Command '$env:LEGAL_TERMINAL_INSTALL_JURI_SUPPORT="0"; $env:LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE="0"; irm https://raw.githubusercontent.com/jurisupport/legal-terminal/main/install.ps1 | iex'
      fi
      return
      ;;
    *)
      echo "legal-terminal has macOS/Windows builds only; skipping. / legal-terminal은 macOS/Windows 배포만 있어 건너뜁니다."
      return
      ;;
  esac

  if ! ask_yes_no "Install legal-terminal too? / legal-terminal 앱도 설치할까요?"; then
    echo "Skipping legal-terminal. / legal-terminal 설치를 건너뜁니다."
    return
  fi

  curl -fsSL "$LEGAL_TERMINAL_INSTALL_URL" \
    | LEGAL_TERMINAL_INSTALL_JURI_SUPPORT=0 LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE=0 bash
}

echo "JuriSupport lawyer profile plugin installer / JuriSupport 변호사 강점찾기 플러그인 설치를 시작합니다."

refresh_path
if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code is not installed. Installing Claude Code first... / Claude Code가 설치되어 있지 않아 먼저 설치합니다..."
  curl -fsSL https://claude.ai/install.sh | bash
  refresh_path
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Could not find the claude command after installation. / 설치 후에도 claude 명령어를 찾을 수 없습니다." >&2
  echo "Open a new terminal and run this installer again. / 새 터미널을 열고 이 설치 명령을 다시 실행해 주세요." >&2
  exit 1
fi

claude --version
install_jurisupport_plugins

echo "Installing the JuriSupport lawyer profile plugin... / JuriSupport 변호사 강점찾기 플러그인을 설치합니다..."

if ! claude plugin marketplace add "$MARKETPLACE_URL"; then
  claude plugin marketplace update "$MARKETPLACE_NAME"
fi

if ! claude plugin install "$PLUGIN_REF"; then
  claude plugin update "$PLUGIN_NAME"
fi

claude plugin list
if should_connect_mcp; then
  curl -fsSL "$CONNECT_MCP_URL" | bash
else
  echo "Skipping MCP connection for now. You can run connect-mcp later. / 지금은 MCP 연결을 건너뜁니다. 나중에 connect-mcp 명령으로 연결할 수 있습니다."
fi

install_legal_terminal

echo "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile. / 완료되었습니다. 새 Claude Code 세션을 열고 /jurisupport-lawyer-profile:complete-personal-profile 을 실행하세요."
