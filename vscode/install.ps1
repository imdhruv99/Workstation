# install.ps1 - install VS Code settings + extensions on Windows.
# Idempotent and safe to re-run. Copies settings.json (Windows symlinks need
# admin) and installs every extension listed in extensions.txt.
#
# Usage (PowerShell):
#   powershell -ExecutionPolicy Bypass -File vscode\install.ps1
#   powershell -ExecutionPolicy Bypass -File vscode\install.ps1 -NoExt

param(
    [switch]$NoExt
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserDir   = Join-Path $env:APPDATA "Code\User"
New-Item -ItemType Directory -Force -Path $UserDir | Out-Null

function Install-File($Src, $Dst) {
    if (-not (Test-Path $Src)) { return }
    if (Test-Path $Dst) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        Copy-Item $Dst "$Dst.$stamp.bak" -Force
        Write-Host "backed up existing $(Split-Path $Dst -Leaf)"
    }
    Copy-Item $Src $Dst -Force
    Write-Host "installed $(Split-Path $Dst -Leaf) -> $Dst"
}

Install-File (Join-Path $ScriptDir "settings.json")    (Join-Path $UserDir "settings.json")
Install-File (Join-Path $ScriptDir "keybindings.json") (Join-Path $UserDir "keybindings.json")

if (-not $NoExt) {
    if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Warning "'code' CLI not found on PATH - skipping extensions."
        Write-Warning "In VS Code: Ctrl+Shift+P -> 'Shell Command: Install code command in PATH'."
    } else {
        Get-Content (Join-Path $ScriptDir "extensions.txt") | ForEach-Object {
            $ext = ($_ -split '#')[0].Trim()
            if ($ext) { code --install-extension $ext --force }
        }
        Write-Host "extensions installed."
    }
}

Write-Host "VS Code setup complete. Reload the window to apply."
