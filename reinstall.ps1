$ErrorActionPreference = "Stop"

$InstallerUrl = "https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.ps1"
$MarketplaceUrl = "https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
$MarketplaceName = "jurisupport-lawyer-profile-plugin"
$PluginRef = "jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"

function Update-CurrentPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath;$env:Path"
}

function Invoke-ClaudeIfAvailable {
    param([string[]] $ClaudeArgs)

    if (Get-Command claude -ErrorAction SilentlyContinue) {
        try {
            & claude @ClaudeArgs *> $null
        } catch {
        }
    }
}

function Invoke-CodexIfAvailable {
    param([string[]] $CodexArgs)

    if (Get-Command codex -ErrorAction SilentlyContinue) {
        try {
            & codex @CodexArgs *> $null
        } catch {
        }
    }
}

function Install-CodexPluginIfAvailable {
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
        Write-Host "Codex is not currently installed. Skipping Codex reinstall. / Codex가 설치되어 있지 않아 Codex 재설치는 건너뜁니다."
        return
    }

    Invoke-CodexIfAvailable -CodexArgs @("plugin", "remove", $PluginRef)
    Invoke-CodexIfAvailable -CodexArgs @("plugin", "marketplace", "remove", $MarketplaceName)
    & codex plugin marketplace add $MarketplaceUrl *> $null
    & codex plugin add $PluginRef *> $null
    Write-Host "Codex plugin reinstalled. / Codex 플러그인 재설치가 완료되었습니다."
}

Write-Host "Resetting JuriSupport Claude Code and Codex plugins... / JuriSupport Claude Code 및 Codex 플러그인 설정을 초기화합니다..."

Update-CurrentPath
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Invoke-ClaudeIfAvailable -ClaudeArgs @("mcp", "remove", "jurisupport")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "uninstall", "jurisupport-lawyer-profile", "--prune", "-y")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "uninstall", "jurisupport", "--prune", "-y")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "marketplace", "remove", "jurisupport-lawyer-profile-plugin")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "marketplace", "remove", "jurisupport-plugins")
} else {
    Write-Host "Claude Code is not currently installed. Continuing with a fresh install. / 현재 Claude Code가 설치되어 있지 않습니다. 새 설치로 계속 진행합니다."
}

irm $InstallerUrl | iex
Install-CodexPluginIfAvailable
