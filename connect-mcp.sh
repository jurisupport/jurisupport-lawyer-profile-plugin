#!/usr/bin/env bash
set -euo pipefail

MCP_URL="https://api.jurisupport.com/mcp"
CODEX_DISABLED_TOOLS=(
  studio_generate_outline
  studio_generate_content
  studio_convert_content
  studio_chat_edit
  studio_convert_pdf
  studio_generate_tags
  studio_generate_focus_keyword
  studio_generate_meta_description
  studio_generate_youtube_title
  studio_generate_youtube_description
  studio_generate_thumbnail
  studio_generate_thumbnail_text
  studio_generate_illustration
  studio_get_credits
  studio_list_snapshots
  studio_save_snapshot
  studio_get_snapshot
  studio_update_snapshot
  studio_delete_snapshot
)

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
      echo "The token was rejected by JuriSupport. Paste a new token and try again. / JuriSupport가 토큰을 거부했습니다. 새 토큰을 붙여넣어 다시 시도해 주세요." >&2
      return 1
      ;;
    *)
      echo "Could not verify the token now (HTTP $code). Continuing registration. / 지금 토큰 검증을 완료하지 못했습니다(HTTP $code). 등록은 계속합니다." >&2
      ;;
  esac
}

patch_codex_mcp_config() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 is required to write Codex direct-header MCP config. / Codex direct-header MCP 설정 작성에는 python3가 필요합니다." >&2
    return 1
  fi

  local disabled_tools
  disabled_tools="$(IFS=,; printf '%s' "${CODEX_DISABLED_TOOLS[*]}")"
  CODEX_JURISUPPORT_MCP_TOKEN="$token" \
  CODEX_JURISUPPORT_DISABLED_TOOLS="$disabled_tools" \
    python3 <<'PY'
import json
import os
import pathlib
import re

token = os.environ["CODEX_JURISUPPORT_MCP_TOKEN"]
disabled_tools = [tool for tool in os.environ["CODEX_JURISUPPORT_DISABLED_TOOLS"].split(",") if tool]
config_dir = pathlib.Path(os.environ.get("CODEX_HOME", pathlib.Path.home() / ".codex"))
config_path = config_dir / "config.toml"
text = config_path.read_text() if config_path.exists() else ""

tool_lines = [
    f"  {json.dumps(tool)}{',' if index < len(disabled_tools) - 1 else ''}"
    for index, tool in enumerate(disabled_tools)
]
block = "\n".join([
    "[mcp_servers.jurisupport]",
    'url = "https://api.jurisupport.com/mcp"',
    f"http_headers = {{ Authorization = {json.dumps('Bearer ' + token)} }}",
    "disabled_tools = [",
    *tool_lines,
    "]",
    "startup_timeout_sec = 20",
    "tool_timeout_sec = 60",
    "",
])

pattern = r"(?ms)^\[mcp_servers\.jurisupport\]\n.*?(?=^\[|\Z)"
if re.search(pattern, text):
    text = re.sub(pattern, block, text, count=1)
else:
    if text and not text.endswith("\n"):
        text += "\n"
    text += "\n" + block

config_dir.mkdir(parents=True, exist_ok=True)
config_path.write_text(text)
PY
}

echo "JuriSupport MCP connector / JuriSupport MCP 연결을 시작합니다."

refresh_path
if ! command -v claude >/dev/null 2>&1 && ! command -v codex >/dev/null 2>&1; then
  echo "Could not find claude or codex. Install Claude Code or Codex first. / claude 또는 codex 명령어를 찾을 수 없습니다. Claude Code 또는 Codex를 먼저 설치해 주세요." >&2
  exit 1
fi

while true; do
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
    echo "Token is empty. Please paste the token again. / 토큰이 비어 있습니다. 다시 붙여넣어 주세요." >&2
    unset JURISUPPORT_MCP_TOKEN
    continue
  fi

  if validate_token; then
    break
  fi
  unset JURISUPPORT_MCP_TOKEN
done

echo "Registering JuriSupport MCP... / JuriSupport MCP를 등록합니다..."
if command -v claude >/dev/null 2>&1; then
  claude mcp remove jurisupport >/dev/null 2>&1 || true
  claude mcp add --transport http jurisupport "$MCP_URL" --header "Authorization: Bearer $token"
  echo "Claude MCP registered. / Claude MCP 등록 완료."
else
  echo "Claude Code is not installed. Skipping Claude MCP. / Claude Code가 설치되어 있지 않아 Claude MCP는 건너뜁니다."
fi

if command -v codex >/dev/null 2>&1; then
  export JURISUPPORT_MCP_TOKEN="$token"
  codex mcp remove jurisupport >/dev/null 2>&1 || true
  codex mcp add jurisupport --url "$MCP_URL" --bearer-token-env-var JURISUPPORT_MCP_TOKEN
  patch_codex_mcp_config
  codex mcp get jurisupport
else
  echo "Codex is not installed. Skipping Codex MCP. / Codex가 설치되어 있지 않아 Codex MCP는 건너뜁니다."
fi

echo "Done. Quit and reopen Claude Code or the Codex app if it was already open. / 완료되었습니다. 이미 Claude Code나 Codex 앱이 열려 있었다면 완전히 종료한 뒤 다시 열어 주세요."
