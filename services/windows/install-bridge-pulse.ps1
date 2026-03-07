# install-bridge-pulse.ps1
# Install Bridge Pulse service on Windows using NSSM

# Requires: NSSM (Non-Sucking Service Manager)
# Download from: https://nssm.cc/download

param(
    [string]$ClaudeHome = "D:\Claude",
    [string]$NssmPath = "C:\nssm\nssm.exe"
)

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges. Please run as Administrator."
    exit 1
}

# Check if NSSM exists
if (-not (Test-Path $NssmPath)) {
    Write-Error "NSSM not found at: $NssmPath"
    Write-Host "Download NSSM from: https://nssm.cc/download"
    Write-Host "Extract to C:\nssm\ or specify path with -NssmPath parameter"
    exit 1
}

# Check if Claude directory exists
if (-not (Test-Path $ClaudeHome)) {
    Write-Error "Claude directory not found: $ClaudeHome"
    Write-Host "Specify correct path with -ClaudeHome parameter"
    exit 1
}

# Paths
$ScriptPath = Join-Path $ClaudeHome "scripts\bridge-pulse.py"
$PythonPath = (Get-Command python).Source

if (-not $PythonPath) {
    Write-Error "Python not found in PATH"
    exit 1
}

Write-Host "Installing Bridge Pulse Service..."
Write-Host "CLAUDE_HOME: $ClaudeHome"
Write-Host "Python: $PythonPath"
Write-Host "Script: $ScriptPath"
Write-Host ""

# Install service
& $NssmPath install BridgePulse $PythonPath $ScriptPath

# Configure service
& $NssmPath set BridgePulse AppDirectory $ClaudeHome
& $NssmPath set BridgePulse AppEnvironmentExtra CLAUDE_HOME=$ClaudeHome
& $NssmPath set BridgePulse DisplayName "Bridge Pulse - Temporal Awareness"
& $NssmPath set BridgePulse Description "Provides temporal grounding for AI instances"
& $NssmPath set BridgePulse Start SERVICE_AUTO_START
& $NssmPath set BridgePulse AppStdout "$ClaudeHome\.claude\logs\bridge-pulse.log"
& $NssmPath set BridgePulse AppStderr "$ClaudeHome\.claude\logs\bridge-pulse-error.log"

Write-Host ""
Write-Host "Service installed successfully!"
Write-Host ""
Write-Host "To start service:"
Write-Host "  net start BridgePulse"
Write-Host ""
Write-Host "To view status:"
Write-Host "  sc query BridgePulse"
Write-Host ""
Write-Host "To stop service:"
Write-Host "  net stop BridgePulse"
Write-Host ""
Write-Host "To uninstall service:"
Write-Host "  nssm remove BridgePulse confirm"
