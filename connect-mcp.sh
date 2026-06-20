#!/usr/bin/env bash
set -euo pipefail

MCP_URL="https://api.jurisupport.com/mcp"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

normalize_token() {
  local token="$1"
  token="${token//$'\r'/}"
  token="${token//$'\n'/}"
  token="$(printf '%s' "$token" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  token="${token#\"}"
  token="${token%\"}"
  token="${token#\'}"
  token="${token%\'}"
  token="${token#\`}"
  token="${token%\`}"
  token="$(printf '%s' "$token" | sed -E 's/^[Aa]uthorization:[[:space:]]*[Bb]earer[[:space:]]+//; s/^[Bb]earer[[:space:]]+//')"
  token="${token#<}"
  token="${token%>}"
  printf '%s' "$token"
}

echo "JuriSupport MCP connector / JuriSupport MCP 연결을 시작합니다."

refresh_path
if ! command -v claude >/dev/null 2>&1; then
  echo "Could not find the claude command. Install Claude Code first. / claude 명령어를 찾을 수 없습니다. Claude Code를 먼저 설치해 주세요." >&2
  exit 1
fi

raw_token="${JURISUPPORT_MCP_TOKEN:-}"
if [[ -z "$raw_token" ]]; then
  if { exec 3<> /dev/tty; } 2>/dev/null; then
    printf "Paste only the JuriSupport MCP token, then press Enter. Input is hidden. / JuriSupport MCP 토큰만 붙여넣고 Enter를 누르세요. 입력은 화면에 보이지 않습니다: " >&3
    read -rs raw_token <&3 || raw_token=""
    printf "\n" >&3
    exec 3>&- 3<&-
  else
    echo "No interactive terminal detected. Set JURISUPPORT_MCP_TOKEN and run again. / 대화형 터미널이 아닙니다. JURISUPPORT_MCP_TOKEN 값을 설정한 뒤 다시 실행해 주세요." >&2
    exit 1
  fi
fi

token="$(normalize_token "$raw_token")"
if [[ -z "$token" ]]; then
  echo "Token is empty. Please copy the token from JuriSupport and run again. / 토큰이 비어 있습니다. JuriSupport에서 토큰을 복사한 뒤 다시 실행해 주세요." >&2
  exit 1
fi

echo "Registering JuriSupport MCP... / JuriSupport MCP를 등록합니다..."
claude mcp remove jurisupport >/dev/null 2>&1 || true
claude mcp add --transport http jurisupport "$MCP_URL" --header "Authorization: Bearer $token"
claude mcp get jurisupport
echo "Done. Restart Claude Code if this session was already open. / 완료되었습니다. 이미 Claude Code가 열려 있었다면 새로 시작해 주세요."
