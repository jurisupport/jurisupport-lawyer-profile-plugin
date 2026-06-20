$ErrorActionPreference = "Stop"

$MarketplaceUrl = "https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
$MarketplaceName = "jurisupport-lawyer-profile-plugin"
$PluginRef = "jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
$PluginName = "jurisupport-lawyer-profile"
$ConnectMcpUrl = "https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.ps1"

function Update-CurrentPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath;$env:Path"
}

function Invoke-ClaudeOrUpdate {
    param(
        [string[]] $PrimaryArgs,
        [string[]] $FallbackArgs
    )

    & claude @PrimaryArgs
    if ($LASTEXITCODE -eq 0) {
        return
    }

    & claude @FallbackArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

function Should-ConnectMcp {
    if ($env:JURISUPPORT_CONNECT_MCP -match "^(1|true|yes|y)$") {
        return $true
    }

    if ($env:JURISUPPORT_CONNECT_MCP -match "^(0|false|no|n)$") {
        return $false
    }

    if (-not [string]::IsNullOrWhiteSpace($env:JURISUPPORT_MCP_TOKEN)) {
        return $true
    }

    $answer = Read-Host "Connect JuriSupport MCP now? If you have a token, choose y. [y/N] / 지금 JuriSupport MCP도 연결할까요? 토큰이 있으면 y를 누르세요. [y/N]"
    return $answer -match "^(y|yes)$"
}

Write-Host "JuriSupport lawyer profile plugin installer / JuriSupport 변호사 강점찾기 플러그인 설치를 시작합니다."

Update-CurrentPath
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "Claude Code is not installed. Installing Claude Code first... / Claude Code가 설치되어 있지 않아 먼저 설치합니다..."
    irm https://claude.ai/install.ps1 | iex
    Update-CurrentPath
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    throw "Could not find the claude command after installation. Open a new PowerShell window and run this installer again. / 설치 후에도 claude 명령어를 찾을 수 없습니다. 새 PowerShell 창을 열고 설치 명령을 다시 실행해 주세요."
}

claude --version

Write-Host "Installing the JuriSupport lawyer profile plugin... / JuriSupport 변호사 강점찾기 플러그인을 설치합니다..."

Invoke-ClaudeOrUpdate `
    -PrimaryArgs @("plugin", "marketplace", "add", $MarketplaceUrl) `
    -FallbackArgs @("plugin", "marketplace", "update", $MarketplaceName)

Invoke-ClaudeOrUpdate `
    -PrimaryArgs @("plugin", "install", $PluginRef) `
    -FallbackArgs @("plugin", "update", $PluginName)

claude plugin list
if (Should-ConnectMcp) {
    irm $ConnectMcpUrl | iex
} else {
    Write-Host "Skipping MCP connection for now. You can run connect-mcp later. / 지금은 MCP 연결을 건너뜁니다. 나중에 connect-mcp 명령으로 연결할 수 있습니다."
}

Write-Host "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile. / 완료되었습니다. 새 Claude Code 세션을 열고 /jurisupport-lawyer-profile:complete-personal-profile 을 실행하세요."
