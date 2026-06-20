$ErrorActionPreference = "Stop"

$InstallerUrl = "https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.ps1"

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

Write-Host "Resetting JuriSupport Claude Code plugins... / JuriSupport Claude Code 플러그인 설정을 초기화합니다..."

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
