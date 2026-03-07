# Windows Installation - Bridge Pulse Service

## Requirements

- Python 3.11+
- `pytz` package
- NSSM (Non-Sucking Service Manager) for service management

## Installation Steps

### 1. Install NSSM

Download NSSM from: https://nssm.cc/download

Extract to `C:\nssm\` (or another location)

### 2. Install Python Dependencies

```powershell
pip install pytz
```

### 3. Copy Script to CLAUDE_HOME

```powershell
cd D:\Claude  # or your CLAUDE_HOME path
mkdir scripts -ErrorAction SilentlyContinue
copy bridge-pulse.py scripts\
```

### 4. Test the Script

```powershell
python scripts\bridge-pulse.py
# Should output:
# Bridge Pulse Service Started
# CLAUDE_HOME: D:\Claude
# Pulse file: D:\Claude\.claude\logs\bridge.pulse
# ...
```

Press Ctrl+C to stop the test.

### 5. Install Service (PowerShell as Administrator)

```powershell
# Run installation script
.\install-bridge-pulse.ps1

# Or specify custom paths
.\install-bridge-pulse.ps1 -ClaudeHome "D:\Claude" -NssmPath "C:\nssm\nssm.exe"
```

### 6. Start Service

```powershell
net start BridgePulse
```

### 7. Verify Service

```powershell
# Check status
sc query BridgePulse

# View logs
type D:\Claude\.claude\logs\bridge-pulse.log

# Check pulse file
type D:\Claude\.claude\logs\bridge.pulse
# Should show: MM/DD/YYYY HH:MM:SS CST
```

## Service Management

```powershell
# Start service
net start BridgePulse

# Stop service
net stop BridgePulse

# View status
sc query BridgePulse

# View logs
type D:\Claude\.claude\logs\bridge-pulse.log
```

## Manual Installation (if script fails)

```powershell
# Install service
nssm install BridgePulse "C:\Python\python.exe" "D:\Claude\scripts\bridge-pulse.py"

# Configure
nssm set BridgePulse AppDirectory "D:\Claude"
nssm set BridgePulse AppEnvironmentExtra CLAUDE_HOME=D:\Claude
nssm set BridgePulse DisplayName "Bridge Pulse - Temporal Awareness"
nssm set BridgePulse Start SERVICE_AUTO_START
nssm set BridgePulse AppStdout "D:\Claude\.claude\logs\bridge-pulse.log"
nssm set BridgePulse AppStderr "D:\Claude\.claude\logs\bridge-pulse-error.log"

# Start
net start BridgePulse
```

## Troubleshooting

**Service won't start:**
```powershell
# Check logs
type D:\Claude\.claude\logs\bridge-pulse-error.log

# Test script manually
python D:\Claude\scripts\bridge-pulse.py
```

**Permission errors:**
- Ensure running PowerShell as Administrator
- Ensure service has access to D:\Claude

**Import errors:**
```powershell
pip install pytz
```

## Uninstall

```powershell
# Stop service
net stop BridgePulse

# Remove service
nssm remove BridgePulse confirm
```
