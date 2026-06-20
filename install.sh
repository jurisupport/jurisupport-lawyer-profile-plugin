#!/usr/bin/env bash
set -euo pipefail

MARKETPLACE_URL="https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
MARKETPLACE_NAME="jurisupport-lawyer-profile-plugin"
PLUGIN_REF="jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
PLUGIN_NAME="jurisupport-lawyer-profile"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
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

echo "Installing the JuriSupport lawyer profile plugin... / JuriSupport 변호사 강점찾기 플러그인을 설치합니다..."

if ! claude plugin marketplace add "$MARKETPLACE_URL"; then
  claude plugin marketplace update "$MARKETPLACE_NAME"
fi

if ! claude plugin install "$PLUGIN_REF"; then
  claude plugin update "$PLUGIN_NAME"
fi

claude plugin list
echo "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile. / 완료되었습니다. 새 Claude Code 세션을 열고 /jurisupport-lawyer-profile:complete-personal-profile 을 실행하세요."
