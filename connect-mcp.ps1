$ErrorActionPreference = "Stop"

$McpUrl = "https://api.jurisupport.com/mcp"

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

function Test-CodexMcpRegistered {
    try {
        $info = & codex mcp get jurisupport 2>$null | Out-String
    } catch {
        return $false
    }

    return ($info -match "url:\s+https://api\.jurisupport\.com/mcp") -and
        ($info -match "bearer_token_env_var:\s+JURISUPPORT_MCP_TOKEN")
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
    & claude mcp get jurisupport
} else {
    Write-Host "Claude Code is not installed. Skipping Claude MCP. / Claude Code가 설치되어 있지 않아 Claude MCP는 건너뜁니다."
}

if (Get-Command codex -ErrorAction SilentlyContinue) {
    $env:JURISUPPORT_MCP_TOKEN = $token
    [Environment]::SetEnvironmentVariable("JURISUPPORT_MCP_TOKEN", $token, "User")

    if (Test-CodexMcpRegistered) {
        Write-Host "Codex MCP is already registered. Keeping existing config. / Codex MCP가 이미 등록되어 있어 기존 설정을 유지합니다."
    } else {
        try {
            & codex mcp remove jurisupport *> $null
        } catch {
        }

        & codex mcp add jurisupport --url $McpUrl --bearer-token-env-var JURISUPPORT_MCP_TOKEN
    }
    & codex mcp get jurisupport
} else {
    Write-Host "Codex is not installed. Skipping Codex MCP. / Codex가 설치되어 있지 않아 Codex MCP는 건너뜁니다."
}

Write-Host "Done. Restart Claude Code or Codex if a session was already open. / 완료되었습니다. 이미 Claude Code나 Codex가 열려 있었다면 새로 시작해 주세요."
