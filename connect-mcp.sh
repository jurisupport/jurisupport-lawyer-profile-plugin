#!/usr/bin/env bash
set -euo pipefail

MCP_URL="https://api.jurisupport.com/mcp"

refresh_path() {
  export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
}

shell_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

persist_codex_token() {
  local env_file="$HOME/.jurisupport-mcp.env"
  local profile line
  local profiles=()

  umask 077
  printf 'export JURISUPPORT_MCP_TOKEN=%s\n' "$(shell_quote "$token")" > "$env_file"
  chmod 600 "$env_file" >/dev/null 2>&1 || true

  case "$(basename "${SHELL:-}")" in
    zsh) profiles=("${ZDOTDIR:-$HOME}/.zshrc" "${ZDOTDIR:-$HOME}/.zprofile") ;;
    bash) profiles=("$HOME/.bashrc" "$HOME/.bash_profile") ;;
    *) profiles=("$HOME/.profile") ;;
  esac

  line='[ -f "$HOME/.jurisupport-mcp.env" ] && . "$HOME/.jurisupport-mcp.env"'
  for profile in "${profiles[@]}"; do
    mkdir -p "$(dirname "$profile")"
    touch "$profile"
    if ! grep -F -q "$line" "$profile"; then
      printf '\n# JuriSupport MCP token for Codex\n%s\n' "$line" >> "$profile"
    fi
  done

  if [[ "$(uname -s)" == "Darwin" ]] && command -v launchctl >/dev/null 2>&1; then
    launchctl setenv JURISUPPORT_MCP_TOKEN "$token" >/dev/null 2>&1 || true
  fi
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
  token="$(printf '%s' "$token" | tr -d '[:space:]')"
  printf '%s' "$token"
}

validate_token() {
  local tmp code
  tmp="$(mktemp)"
  code="$(curl -sS -o "$tmp" -w '%{http_code}' \
    -X POST "$MCP_URL" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json, text/event-stream' \
    -H "Authorization: Bearer $token" \
    --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"jurisupport-mcp-connector","version":"1.0.0"}}}' || true)"
  rm -f "$tmp"

  case "$code" in
    200|202) return 0 ;;
    401|403)
      echo "The token was rejected by JuriSupport. Reissue a token and run this connector again. / JuriSupport가 토큰을 거부했습니다. 토큰을 새로 발급한 뒤 다시 연결해 주세요." >&2
      exit 1
      ;;
    *)
      echo "Could not verify the token now (HTTP $code). Continuing registration. / 지금 토큰 검증을 완료하지 못했습니다(HTTP $code). 등록은 계속합니다." >&2
      ;;
  esac
}

echo "JuriSupport MCP connector / JuriSupport MCP 연결을 시작합니다."

refresh_path
if ! command -v claude >/dev/null 2>&1 && ! command -v codex >/dev/null 2>&1; then
  echo "Could not find claude or codex. Install Claude Code or Codex first. / claude 또는 codex 명령어를 찾을 수 없습니다. Claude Code 또는 Codex를 먼저 설치해 주세요." >&2
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
validate_token

echo "Registering JuriSupport MCP... / JuriSupport MCP를 등록합니다..."
if command -v claude >/dev/null 2>&1; then
  claude mcp remove jurisupport >/dev/null 2>&1 || true
  claude mcp add --transport http jurisupport "$MCP_URL" --header "Authorization: Bearer $token"
  claude mcp get jurisupport
else
  echo "Claude Code is not installed. Skipping Claude MCP. / Claude Code가 설치되어 있지 않아 Claude MCP는 건너뜁니다."
fi

if command -v codex >/dev/null 2>&1; then
  persist_codex_token
  export JURISUPPORT_MCP_TOKEN="$token"
  codex mcp remove jurisupport >/dev/null 2>&1 || true
  codex mcp add jurisupport --url "$MCP_URL" --bearer-token-env-var JURISUPPORT_MCP_TOKEN
  codex mcp get jurisupport
  echo "If you will run Codex in this same already-open terminal, run: source ~/.jurisupport-mcp.env / 지금 열린 같은 터미널에서 바로 Codex를 실행하려면 먼저 실행하세요: source ~/.jurisupport-mcp.env"
else
  echo "Codex is not installed. Skipping Codex MCP. / Codex가 설치되어 있지 않아 Codex MCP는 건너뜁니다."
fi

echo "Done. Quit and reopen Claude Code or the Codex app if it was already open. / 완료되었습니다. 이미 Claude Code나 Codex 앱이 열려 있었다면 완전히 종료한 뒤 다시 열어 주세요."
