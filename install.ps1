$ErrorActionPreference = "Stop"

$MarketplaceUrl = "https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git"
$MarketplaceName = "jurisupport-lawyer-profile-plugin"
$PluginRef = "jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin"
$PluginName = "jurisupport-lawyer-profile"

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

Write-Host "JuriSupport lawyer profile plugin installer"

Update-CurrentPath
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "Claude Code is not installed. Installing Claude Code first..."
    irm https://claude.ai/install.ps1 | iex
    Update-CurrentPath
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    throw "Could not find the claude command after installation. Open a new PowerShell window and run this installer again."
}

claude --version

Invoke-ClaudeOrUpdate `
    -PrimaryArgs @("plugin", "marketplace", "add", $MarketplaceUrl) `
    -FallbackArgs @("plugin", "marketplace", "update", $MarketplaceName)

Invoke-ClaudeOrUpdate `
    -PrimaryArgs @("plugin", "install", $PluginRef) `
    -FallbackArgs @("plugin", "update", $PluginName)

claude plugin list
Write-Host "Done. Open a new Claude Code session to use /jurisupport-lawyer-profile:complete-personal-profile."
