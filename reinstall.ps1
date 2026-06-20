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
        & claude @ClaudeArgs
    }
}

Write-Host "Resetting JuriSupport Claude Code plugins..."

Update-CurrentPath
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Invoke-ClaudeIfAvailable -ClaudeArgs @("mcp", "remove", "jurisupport")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "uninstall", "jurisupport-lawyer-profile", "--prune", "-y")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "uninstall", "jurisupport", "--prune", "-y")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "marketplace", "remove", "jurisupport-lawyer-profile-plugin")
    Invoke-ClaudeIfAvailable -ClaudeArgs @("plugin", "marketplace", "remove", "jurisupport-plugins")
} else {
    Write-Host "Claude Code is not currently installed. Continuing with a fresh install."
}

irm $InstallerUrl | iex
