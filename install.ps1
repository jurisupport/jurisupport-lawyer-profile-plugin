$ErrorActionPreference = "Stop"

$MarketplaceUrl = "https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
$MarketplaceName = "jurisupport-lawyer-profile-plugin"
$PluginRef = "jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
$PluginName = "jurisupport-lawyer-profile"
$ConnectMcpUrl = "https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.ps1"
$JuriSupportBootstrapUrl = "https://raw.githubusercontent.com/jurisupport/jurisupport-plugins/main/windows-bootstrap.ps1"
$LegalTerminalInstallUrl = "https://raw.githubusercontent.com/jurisupport/legal-terminal/main/install.ps1"

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

function Test-EnvTruthy {
    param([string] $Name)
    $value = [Environment]::GetEnvironmentVariable($Name)
    return $value -match "^(1|true|yes|y|on)$"
}

function Read-YesNoDefaultYes {
    param([string] $Question)
    $answer = Read-Host "$Question [Y/n]"
    return $answer -notmatch "^(n|no)$"
}

function Test-JuriSupportPluginsInstalled {
    $repoDir = Join-Path $env:USERPROFILE "jurisupport-plugins"
    if (Test-Path (Join-Path $repoDir "install.sh")) {
        return $true
    }

    try {
        $plugins = & claude plugin list 2>$null | Out-String
        return $plugins -match "jurisupport@jurisupport-plugins|jurisupport-plugins|songmu-legal|korean-law"
    } catch {
        return $false
    }
}

function Invoke-JuriSupportPluginsInstaller {
    if (Test-EnvTruthy "JURISUPPORT_LAWYER_PROFILE_SKIP_JURISUPPORT") {
        return
    }

    if (Test-JuriSupportPluginsInstalled) {
        Write-Host "jurisupport-plugins already looks installed. / jurisupport-plugins가 이미 설치된 것으로 보입니다."
        return
    }

    if (-not (Read-YesNoDefaultYes "Install jurisupport-plugins first? / 먼저 JuriSupport 송무 플러그인 묶음을 설치할까요?")) {
        Write-Host "Skipping jurisupport-plugins. / JuriSupport 송무 플러그인 설치를 건너뜁니다."
        return
    }

    $previousSkipLawyerProfile = $env:JURISUPPORT_SKIP_LAWYER_PROFILE
    $previousSkipLegalTerminal = $env:JURISUPPORT_SKIP_LEGAL_TERMINAL
    try {
        $env:JURISUPPORT_SKIP_LAWYER_PROFILE = "1"
        $env:JURISUPPORT_SKIP_LEGAL_TERMINAL = "1"
        irm $JuriSupportBootstrapUrl | iex
        Update-CurrentPath
    } finally {
        if ($null -eq $previousSkipLawyerProfile) {
            Remove-Item Env:JURISUPPORT_SKIP_LAWYER_PROFILE -ErrorAction SilentlyContinue
        } else {
            $env:JURISUPPORT_SKIP_LAWYER_PROFILE = $previousSkipLawyerProfile
        }

        if ($null -eq $previousSkipLegalTerminal) {
            Remove-Item Env:JURISUPPORT_SKIP_LEGAL_TERMINAL -ErrorAction SilentlyContinue
        } else {
            $env:JURISUPPORT_SKIP_LEGAL_TERMINAL = $previousSkipLegalTerminal
        }
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

    $claudeConnected = $false
    $codexConnected = $true

    if (Get-Command claude -ErrorAction SilentlyContinue) {
        try {
            $mcpList = & claude mcp list 2>$null | Out-String
            $claudeConnected = $mcpList -match "(?m)^jurisupport:.*Connected"
        } catch {
        }
    }

    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $codexConnected = $false
        try {
            $codexInfo = & codex mcp get jurisupport 2>$null | Out-String
            $codexConnected = ($codexInfo -match "url:\s+https://api\.jurisupport\.com/mcp") -and
                ($codexInfo -match "http_headers:") -and
                ($codexInfo -notmatch "http_headers:\s+-") -and
                ($codexInfo -notmatch "bearer_token_env_var:")
        } catch {
        }
    }

    if ($claudeConnected -and $codexConnected) {
        return $false
    }

    $answer = Read-Host "Connect JuriSupport MCP now? If you have a token, choose y. [y/N] / 지금 JuriSupport MCP도 연결할까요? 토큰이 있으면 y를 누르세요. [y/N]"
    return $answer -match "^(y|yes)$"
}

function Invoke-LegalTerminalInstaller {
    if (Test-EnvTruthy "JURISUPPORT_LAWYER_PROFILE_SKIP_LEGAL_TERMINAL") {
        return
    }

    if (-not (Read-YesNoDefaultYes "Install legal-terminal too? / legal-terminal 앱도 설치할까요?")) {
        Write-Host "Skipping legal-terminal. / legal-terminal 설치를 건너뜁니다."
        return
    }

    $previousInstallJuriSupport = $env:LEGAL_TERMINAL_INSTALL_JURI_SUPPORT
    $previousInstallLawyerProfile = $env:LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE
    try {
        $env:LEGAL_TERMINAL_INSTALL_JURI_SUPPORT = "0"
        $env:LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE = "0"
        irm $LegalTerminalInstallUrl | iex
    } finally {
        if ($null -eq $previousInstallJuriSupport) {
            Remove-Item Env:LEGAL_TERMINAL_INSTALL_JURI_SUPPORT -ErrorAction SilentlyContinue
        } else {
            $env:LEGAL_TERMINAL_INSTALL_JURI_SUPPORT = $previousInstallJuriSupport
        }

        if ($null -eq $previousInstallLawyerProfile) {
            Remove-Item Env:LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE -ErrorAction SilentlyContinue
        } else {
            $env:LEGAL_TERMINAL_INSTALL_LAWYER_PROFILE = $previousInstallLawyerProfile
        }
    }
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
Invoke-JuriSupportPluginsInstaller

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

Invoke-LegalTerminalInstaller

Write-Host "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile. / 완료되었습니다. 새 Claude Code 세션을 열고 /jurisupport-lawyer-profile:complete-personal-profile 을 실행하세요."
