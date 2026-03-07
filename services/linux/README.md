# Linux Installation - Bridge Pulse Service

## Requirements

- Python 3.11+
- `pytz` package
- systemd (for service management)

## Installation Steps

### 1. Install Python Dependencies

```bash
pip3 install pytz --break-system-packages
# or in virtual environment:
# python3 -m venv venv && source venv/bin/activate && pip install pytz
```

### 2. Copy Script to CLAUDE_HOME

```bash
cd /home/tallest/Claude  # or your CLAUDE_HOME path
mkdir -p scripts
cp bridge-pulse.py scripts/
chmod +x scripts/bridge-pulse.py
```

### 3. Test the Script

```bash
python3 scripts/bridge-pulse.py
# Should output:
# Bridge Pulse Service Started
# CLAUDE_HOME: /home/tallest/Claude
# Pulse file: /home/tallest/Claude/.claude/logs/bridge.pulse
# ...
```

Press Ctrl+C to stop the test.

### 4. Install systemd Service

```bash
# Copy service file
sudo cp bridge-pulse.service /etc/systemd/system/

# Edit if your paths differ
sudo nano /etc/systemd/system/bridge-pulse.service
# Update User, WorkingDirectory, Environment, ExecStart paths

# Reload systemd
sudo systemctl daemon-reload

# Enable service (start on boot)
sudo systemctl enable bridge-pulse

# Start service
sudo systemctl start bridge-pulse
```

### 5. Verify Service

```bash
# Check status
sudo systemctl status bridge-pulse

# View logs
sudo journalctl -u bridge-pulse -f

# Check pulse file
cat /home/tallest/Claude/.claude/logs/bridge.pulse
# Should show: MM/DD/YYYY HH:MM:SS CST
```

## Service Management

```bash
# Start service
sudo systemctl start bridge-pulse

# Stop service
sudo systemctl stop bridge-pulse

# Restart service
sudo systemctl restart bridge-pulse

# Disable (don't start on boot)
sudo systemctl disable bridge-pulse

# View logs
sudo journalctl -u bridge-pulse -n 50
```

## Troubleshooting

**Service won't start:**
```bash
# Check logs
sudo journalctl -u bridge-pulse -n 50

# Test script manually
python3 /home/tallest/Claude/scripts/bridge-pulse.py
```

**Permission errors:**
- Ensure User in service file matches your username
- Ensure CLAUDE_HOME path is correct and accessible

**Import errors:**
```bash
# Install pytz
pip3 install pytz --break-system-packages
```

## Uninstall

```bash
sudo systemctl stop bridge-pulse
sudo systemctl disable bridge-pulse
sudo rm /etc/systemd/system/bridge-pulse.service
sudo systemctl daemon-reload
```
