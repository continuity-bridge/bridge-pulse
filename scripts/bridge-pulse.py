#!/usr/bin/env python3
"""
bridge-pulse.py - Local temporal awareness service

Writes current time to {CLAUDE_HOME}/.claude/logs/bridge.pulse every second.
Provides local temporal grounding for AI instances.

Author: Vector
Created: 2026-03-07
"""

import os
import sys
import time
from pathlib import Path
from datetime import datetime
import pytz


def detect_claude_home():
    """Detect CLAUDE_HOME across platforms"""
    
    # Check environment variable
    if env_home := os.getenv('CLAUDE_HOME'):
        return Path(env_home)
    
    # Windows common locations
    if sys.platform == 'win32':
        for drive in ['D:', 'C:']:
            candidate = Path(f"{drive}/Claude")
            if candidate.exists():
                return candidate
    
    # Unix-like systems
    unix_home = Path.home() / "Claude"
    if unix_home.exists():
        return unix_home
    
    # Laptop location
    laptop_home = Path.home() / "continuity-bridge_tallest-anchor"
    if laptop_home.exists():
        return laptop_home
    
    return None


def write_pulse(pulse_file, timezone='America/Chicago'):
    """Write current time to pulse file"""
    
    tz = pytz.timezone(timezone)
    now = datetime.now(tz)
    
    # Format: MM/DD/YYYY HH:MM:SS TZ
    timestamp = now.strftime('%m/%d/%Y %H:%M:%S %Z')
    
    # Write atomically (write to temp, then move)
    temp_file = pulse_file.with_suffix('.tmp')
    temp_file.write_text(timestamp + '\n')
    temp_file.replace(pulse_file)


def main():
    """Main service loop"""
    
    # Detect CLAUDE_HOME
    claude_home = detect_claude_home()
    if not claude_home:
        print("ERROR: Cannot locate CLAUDE_HOME", file=sys.stderr)
        print("Set CLAUDE_HOME environment variable or ensure Claude directory exists", file=sys.stderr)
        sys.exit(1)
    
    # Create logs directory
    logs_dir = claude_home / '.claude' / 'logs'
    logs_dir.mkdir(parents=True, exist_ok=True)
    
    pulse_file = logs_dir / 'bridge.pulse'
    
    print(f"Bridge Pulse Service Started")
    print(f"CLAUDE_HOME: {claude_home}")
    print(f"Pulse file: {pulse_file}")
    print(f"Timezone: America/Chicago (CST/CDT)")
    print(f"Update interval: 1 second")
    print()
    print("Press Ctrl+C to stop")
    print()
    
    try:
        while True:
            write_pulse(pulse_file)
            time.sleep(1)
    
    except KeyboardInterrupt:
        print("\nBridge Pulse Service Stopped")
        sys.exit(0)
    
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
