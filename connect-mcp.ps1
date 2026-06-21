$ErrorActionPreference = "Stop"

$McpUrl = "https://api.jurisupport.com/mcp"
$CodexDisabledTools = @(
    "studio_generate_outline",
    "studio_generate_content",
    "studio_convert_content",
    "studio_chat_edit",
    "studio_convert_pdf",
    "studio_generate_tags",
    "studio_generate_focus_keyword",
    "studio_generate_meta_description",
    "studio_generate_youtube_title",
    "studio_generate_youtube_description",
    "studio_generate_thumbnail",
    "studio_generate_thumbnail_text",
    "studio_generate_illustration",
    "studio_get_credits",
    "studio_list_snapshots",
    "studio_save_snapshot",
    "studio_get_snapshot",
    "studio_update_snapshot",
    "studio_delete_snapshot"
)

function Update-CurrentPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath;$env:Path"
}

function Normalize-Token {
    param([string] $Token)

    $normalized = ($Token -replace "`r|`n", "").Trim()
    $normalized = $normalized.Trim('"', "'", '`')
    $normalized = $normalized -replace "^(?i)authorization:\s*bearer\s+", ""
    $normalized = $normalized -replace "^(?i)bearer\s+", ""
    $normalized = $normalized.Trim().Trim("<", ">")
    $normalized = $normalized -replace "\s+", ""
    return $normalized
}

function Test-McpToken {
    param([string] $Token)

    $body = @{
        jsonrpc = "2.0"
        id = 1
        method = "initialize"
        params = @{
            protocolVersion = "2025-06-18"
            capabilities = @{}
            clientInfo = @{
                name = "jurisupport-mcp-connector"
                version = "1.0.0"
            }
        }
    } | ConvertTo-Json -Depth 8 -Compress

    try {
        Invoke-WebRequest `
            -Uri $McpUrl `
            -Method Post `
            -Headers @{ Authorization = "Bearer $Token"; Accept = "application/json, text/event-stream" } `
            -ContentType "application/json" `
            -Body $body `
            -UseBasicParsing *> $null
        return $true
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if (($statusCode -eq 401) -or ($statusCode -eq 403)) {
            Write-Host "The token was rejected by JuriSupport. Paste a new token and try again. / JuriSupport가 토큰을 거부했습니다. 새 토큰을 붙여넣어 다시 시도해 주세요."
            return $false
        }
        Write-Warning "Could not verify the token now (HTTP $statusCode). Continuing registration. / 지금 토큰 검증을 완료하지 못했습니다(HTTP $statusCode). 등록은 계속합니다."
        return $true
    }
}

function Set-CodexMcpDirectHeaderConfig {
    param([string] $Token)

    $configDir = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        Join-Path $HOME ".codex"
    } else {
        $env:CODEX_HOME
    }
    $configPath = Join-Path $configDir "config.toml"
    $authHeader = "Bearer $Token" | ConvertTo-Json -Compress

    $lines = @(
        "[mcp_servers.jurisupport]",
        'url = "https://api.jurisupport.com/mcp"',
        "http_headers = { Authorization = $authHeader }",
        "disabled_tools = ["
    )

    for ($i = 0; $i -lt $CodexDisabledTools.Count; $i++) {
        $suffix = if ($i -lt ($CodexDisabledTools.Count - 1)) { "," } else { "" }
        $lines += "  $($CodexDisabledTools[$i] | ConvertTo-Json -Compress)$suffix"
    }

    $lines += @(
        "]",
        "startup_timeout_sec = 20",
        "tool_timeout_sec = 60",
        ""
    )

    $block = ($lines -join "`n")
    $text = if (Test-Path $configPath) { Get-Content $configPath -Raw } else { "" }
    $pattern = "(?ms)^\[mcp_servers\.jurisupport\]\r?\n.*?(?=^\[|\z)"

    if ([regex]::IsMatch($text, $pattern)) {
        $text = [regex]::Replace($text, $pattern, $block, 1)
    } else {
        if (($text.Length -gt 0) -and (-not $text.EndsWith("`n"))) {
            $text += "`n"
        }
        $text += "`n$block"
    }

    New-Item -ItemType Directory -Force $configDir *> $null
    Set-Content -Path $configPath -Value $text -Encoding UTF8 -NoNewline
}

Write-Host "JuriSupport MCP connector / JuriSupport MCP 연결을 시작합니다."

Update-CurrentPath
if ((-not (Get-Command claude -ErrorAction SilentlyContinue)) -and (-not (Get-Command codex -ErrorAction SilentlyContinue))) {
    throw "Could not find claude or codex. Install Claude Code or Codex first. / claude 또는 codex 명령어를 찾을 수 없습니다. Claude Code 또는 Codex를 먼저 설치해 주세요."
}

while ($true) {
    $rawToken = $env:JURISUPPORT_MCP_TOKEN
    if ([string]::IsNullOrWhiteSpace($rawToken)) {
        $secureToken = Read-Host "Paste only the JuriSupport MCP token, then press Enter. Input is hidden. / JuriSupport MCP 토큰만 붙여넣고 Enter를 누르세요. 입력은 화면에 보이지 않습니다" -AsSecureString
        $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
        try {
            $rawToken = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        } finally {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }

    $token = Normalize-Token $rawToken
    if ([string]::IsNullOrWhiteSpace($token)) {
        Write-Host "Token is empty. Please paste the token again. / 토큰이 비어 있습니다. 다시 붙여넣어 주세요."
        Remove-Item Env:JURISUPPORT_MCP_TOKEN -ErrorAction SilentlyContinue
        continue
    }

    if (Test-McpToken $token) {
        break
    }
    Remove-Item Env:JURISUPPORT_MCP_TOKEN -ErrorAction SilentlyContinue
}

Write-Host "Registering JuriSupport MCP... / JuriSupport MCP를 등록합니다..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    try {
        & claude mcp remove jurisupport *> $null
    } catch {
    }

    & claude mcp add --transport http jurisupport $McpUrl --header "Authorization: Bearer $token"
    Write-Host "Claude MCP registered. / Claude MCP 등록 완료."
} else {
    Write-Host "Claude Code is not installed. Skipping Claude MCP. / Claude Code가 설치되어 있지 않아 Claude MCP는 건너뜁니다."
}

if (Get-Command codex -ErrorAction SilentlyContinue) {
    $env:JURISUPPORT_MCP_TOKEN = $token

    try {
        & codex mcp remove jurisupport *> $null
    } catch {
    }

    & codex mcp add jurisupport --url $McpUrl --bearer-token-env-var JURISUPPORT_MCP_TOKEN
    Set-CodexMcpDirectHeaderConfig $token
    & codex mcp get jurisupport
} else {
    Write-Host "Codex is not installed. Skipping Codex MCP. / Codex가 설치되어 있지 않아 Codex MCP는 건너뜁니다."
}

Write-Host "Done. Restart Claude Code or Codex if a session was already open. / 완료되었습니다. 이미 Claude Code나 Codex가 열려 있었다면 새로 시작해 주세요."
