# Temporal Awareness Protocol

**Real-time temporal grounding for AI instances and distributed systems**

Live endpoint: **https://continuity-bridge.github.io/temporal-awareness-protocol/**

---

## What This Is

A simple, reliable time reference service providing:
- Current time in Jerry's timezone (CST/America/Chicago)
- Accessible via HTTP from any platform
- Updates every 5 minutes via GitHub Actions
- Multiple formats (human-readable, ISO 8601, Unix timestamp)

## Why This Exists

AI instances and distributed systems need temporal grounding:
- Container environments have ephemeral state
- Local clocks may be incorrect or out of sync
- External time reference provides shared temporal context
- Enables cross-platform coordination

This is part of the [Continuity Bridge](https://github.com/continuity-bridge/continuity-bridge_tallest-anchor) architecture for AI instance persistence.

---

## Usage

### Web Interface

Visit: https://continuity-bridge.github.io/temporal-awareness-protocol/

Displays current time in Jerry's timezone (CST).

### JSON API

```bash
curl https://continuity-bridge.github.io/temporal-awareness-protocol/pulse.json
```

Returns:
```json
{
  "timestamp": "03/07/2026 01:45:32 CST",
  "iso": "2026-03-07T01:45:32-06:00",
  "unix": 1773219932,
  "timezone": "America/Chicago"
}
```

### Python

```python
import requests

response = requests.get('https://continuity-bridge.github.io/temporal-awareness-protocol/pulse.json')
pulse = response.json()

print(f"Current time: {pulse['timestamp']}")
# Output: Current time: 03/07/2026 01:45:32 CST
```

### Shell

```bash
# Get formatted time
curl -s https://continuity-bridge.github.io/temporal-awareness-protocol/pulse.json | jq -r '.timestamp'

# Get ISO timestamp
curl -s https://continuity-bridge.github.io/temporal-awareness-protocol/pulse.json | jq -r '.iso'
```

---

## Local Services (Optional)

For sub-minute precision, Jerry runs local bridge-pulse services on his machines.

### Linux/macOS (systemd)

See `services/linux/bridge-pulse.service` for systemd service configuration.

### Windows (NSSM)

See `services/windows/install-bridge-pulse.ps1` for Windows service setup.

### Local Endpoint

When running locally, the service writes to:
```
{CLAUDE_HOME}/.claude/logs/bridge.pulse
```

Format: Single line with current time
```
03/07/2026 01:45:32 CST
```

---

## Update Frequency

**GitHub Pages endpoint:** Updates every 5 minutes  
**Local services:** Updates every second (when running)

For most use cases, 5-minute precision is sufficient for temporal grounding.

---

## Privacy

This service exposes only:
- Current time in CST timezone
- No personal information
- No location data beyond timezone
- Public endpoint, no authentication

---

## Architecture

### GitHub Action Workflow

1. Action runs every 5 minutes (cron schedule)
2. Generates current time in CST
3. Writes `pulse.json` and `index.html`
4. Commits to `gh-pages` branch
5. GitHub Pages serves the files

### Files Generated

- `index.html` - Web interface
- `pulse.json` - JSON API endpoint

### Why GitHub Pages?

- Zero infrastructure cost
- Globally distributed (GitHub CDN)
- Reliable uptime
- Simple deployment
- Works from any platform (desktop, mobile, container)

---

## Contributing

This is part of Jerry Jackson's Continuity Bridge project. See the main repository for contribution guidelines.

---

## License

Apache 2.0 - See LICENSE file

---

## Links

- **Main Project:** [Continuity Bridge](https://github.com/continuity-bridge/continuity-bridge_tallest-anchor)
- **Live Endpoint:** https://continuity-bridge.github.io/temporal-awareness-protocol/
- **Source:** https://github.com/continuity-bridge/temporal-awareness-protocol

---

**Remember:** Time is external reference. External reference enables continuity. Continuity bridges discontinuity.
