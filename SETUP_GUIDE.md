# Setup Guide — TradingView MCP × Claude Code

Complete step-by-step instructions for macOS, Windows, and Linux.

---

## Table of Contents

1. [What You're Installing](#what-youre-installing)
2. [Prerequisites Checklist](#prerequisites-checklist)
3. [Step 1 — Install Node.js](#step-1--install-nodejs)
4. [Step 2 — Install Claude Code](#step-2--install-claude-code)
5. [Step 3 — Clone the MCP Server](#step-3--clone-the-mcp-server)
6. [Step 4 — Configure Claude Code](#step-4--configure-claude-code)
7. [Step 5 — Set Up the Launch Script](#step-5--set-up-the-launch-script)
8. [Step 6 — Install the Claude Skill](#step-6--install-the-claude-skill)
9. [Step 7 — First Connection Test](#step-7--first-connection-test)
10. [Platform Notes](#platform-notes)
11. [Troubleshooting](#troubleshooting)

---

## What You're Installing

```
┌─────────────────────────────────────────────────────────┐
│                     Your Machine                         │
│                                                          │
│  Claude Code  ←→  MCP Server  ←→  TradingView Desktop  │
│  (your AI)       (Node.js)        (port 9222 / CDP)     │
└─────────────────────────────────────────────────────────┘
```

- **Claude Code** — Anthropic's AI coding assistant (the interface you type into)
- **MCP Server** — Node.js bridge that translates Claude's requests into TradingView actions
- **TradingView Desktop** — must be running with the debug port open

---

## Prerequisites Checklist

Before starting, confirm you have:

- [ ] TradingView Desktop installed (paid subscription)
- [ ] macOS 12+ / Windows 10+ / Ubuntu 20.04+
- [ ] Internet connection (for cloning the repo)
- [ ] Admin/sudo access on your machine

---

## Step 1 — Install Node.js

Node.js **18 or higher** is required.

### macOS
```bash
# Check if you already have it
node --version

# Install via Homebrew (recommended)
brew install node

# Or download from nodejs.org
# https://nodejs.org/en/download
```

### Windows
1. Go to [nodejs.org](https://nodejs.org/en/download)
2. Download the **LTS** installer (.msi)
3. Run the installer — accept defaults
4. Open a new Command Prompt and verify:
   ```
   node --version
   npm --version
   ```

### Linux (Ubuntu/Debian)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version
```

---

## Step 2 — Install Claude Code

Claude Code is the AI CLI you'll use to interact with TradingView.

```bash
npm install -g @anthropic/claude-code
```

Verify:
```bash
claude --version
```

Sign in when prompted. You need an active Claude account (claude.ai).

> **Note:** Claude Code requires a Pro or API subscription for full functionality. The free tier has usage limits.

---

## Step 3 — Clone the MCP Server

The MCP server is the bridge between Claude and TradingView. It's open-source and community-built.

```bash
git clone https://github.com/tradesdontlie/tradingview-mcp.git
cd tradingview-mcp
npm install
```

**Copy the absolute path** — you need it for Step 4:

```bash
# macOS / Linux
pwd
# Example output: /Users/yourname/tradingview-mcp

# Windows (PowerShell)
Get-Location
# Example output: C:\Users\YourName\tradingview-mcp
```

---

## Step 4 — Configure Claude Code

Claude Code uses a JSON config file to know which MCP servers to connect to.

### Locate or Create the Config File

```
macOS / Linux:  ~/.claude/.mcp.json
Windows:        C:\Users\YourName\.claude\.mcp.json
```

### Add the TradingView Server

Open the file (create it if it doesn't exist) and add:

```json
{
  "mcpServers": {
    "tradingview": {
      "command": "node",
      "args": ["/FULL/PATH/TO/tradingview-mcp/src/server.js"]
    }
  }
}
```

**Replace** `/FULL/PATH/TO/tradingview-mcp` with the path you copied in Step 3.

**macOS example:**
```json
{
  "mcpServers": {
    "tradingview": {
      "command": "node",
      "args": ["/Users/john/tradingview-mcp/src/server.js"]
    }
  }
}
```

**Windows example:**
```json
{
  "mcpServers": {
    "tradingview": {
      "command": "node",
      "args": ["C:\\Users\\John\\tradingview-mcp\\src\\server.js"]
    }
  }
}
```

> ⚠️ On Windows, use **double backslashes** `\\` in JSON paths.

### If You Already Have Other MCP Servers

Add the tradingview entry alongside your existing ones:
```json
{
  "mcpServers": {
    "existingServer": {
      "command": "...",
      "args": ["..."]
    },
    "tradingview": {
      "command": "node",
      "args": ["/path/to/tradingview-mcp/src/server.js"]
    }
  }
}
```

---

## Step 5 — Set Up the Launch Script

TradingView Desktop must be launched with a special debug flag (`--remote-debugging-port=9222`) for Claude to connect to it. This is NOT enabled by default.

### macOS

Copy the launch script from this repo:
```bash
cp scripts/launch_tv_debug_mac.sh ~/launch-tradingview.sh
chmod +x ~/launch-tradingview.sh
```

Run it every time before using Claude with TradingView:
```bash
~/launch-tradingview.sh
```

Or manually:
```bash
/Applications/TradingView.app/Contents/MacOS/TradingView \
  --remote-debugging-port=9222 &
```

### Windows

Copy `scripts/launch_tv_debug_windows.bat` to your Desktop or a folder you can access easily.

Double-click it to launch TradingView with the debug port.

Or run manually in Command Prompt:
```batch
"C:\Users\YourName\AppData\Local\Programs\TradingView\TradingView.exe" --remote-debugging-port=9222
```

> **Finding your TradingView install path on Windows:**
> Right-click the TradingView shortcut → Properties → "Target" field

### Linux

```bash
cp scripts/launch_tv_debug_linux.sh ~/launch-tradingview.sh
chmod +x ~/launch-tradingview.sh
~/launch-tradingview.sh
```

Or manually:
```bash
tradingview --remote-debugging-port=9222 &
```

---

## Step 6 — Install the Claude Skill

The skill file teaches Claude which tools to use, in what order, and how to interpret results. Without it, Claude can still use the tools but won't have the structured analysis workflows.

```bash
# macOS / Linux
mkdir -p ~/.claude/skills/tradingview-mcp
cp skills/tradingview-mcp/SKILL.md ~/.claude/skills/tradingview-mcp/SKILL.md

# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\tradingview-mcp"
Copy-Item "skills\tradingview-mcp\SKILL.md" "$env:USERPROFILE\.claude\skills\tradingview-mcp\SKILL.md"
```

Verify the skill is in place:
```bash
# macOS / Linux
cat ~/.claude/skills/tradingview-mcp/SKILL.md | head -5

# Windows
type "%USERPROFILE%\.claude\skills\tradingview-mcp\SKILL.md"
```

---

## Step 7 — First Connection Test

**Every session, follow this order:**

1. Run the launch script (TradingView opens)
2. Wait for TradingView to fully load your chart
3. Open Claude Code: `claude`
4. Test the connection:

```
You: Check my TradingView connection and tell me what's on the chart
```

Claude will run `tv_health_check` and `chart_get_state`. You should see:

```
✅ Connected to TradingView Desktop
Symbol: BTCUSDT
Timeframe: 240
Indicators: [...]
```

If you see an error, check the [Troubleshooting](#troubleshooting) section below.

---

## Platform Notes

### macOS Specific

**Gatekeeper warning when running launch script:**
```bash
# If macOS blocks the script, run:
xattr -d com.apple.quarantine ~/launch-tradingview.sh
```

**TradingView not found:**
The script assumes TradingView is in `/Applications/TradingView.app`. If yours is elsewhere:
```bash
# Find it
find /Applications -name "TradingView.app" 2>/dev/null
```

### Windows Specific

**TradingView install location varies:**
Common paths:
```
C:\Users\YourName\AppData\Local\Programs\TradingView\TradingView.exe
C:\Program Files\TradingView\TradingView.exe
```

**PowerShell execution policy:**
If scripts don't run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Path in .mcp.json on Windows:**
Use one of these formats:
```json
"C:\\Users\\YourName\\tradingview-mcp\\src\\server.js"
```
or with forward slashes:
```json
"C:/Users/YourName/tradingview-mcp/src/server.js"
```

### Linux Specific

**TradingView Desktop on Linux:**
TradingView Desktop may not be officially supported on all Linux distros. Check if your distro has a package or use the AppImage if available.

**Port 9222 already in use:**
```bash
# Check what's using the port
lsof -i :9222

# Kill it if needed
kill -9 $(lsof -t -i:9222)
```

---

## Troubleshooting

### "CDP connection failed after 5 attempts"

**Cause:** TradingView is not running with the debug port, or it hasn't finished loading.

**Fix:**
1. Close TradingView completely
2. Run the launch script again
3. Wait ~10 seconds for TradingView to fully load
4. Try again in Claude

```bash
# Verify the debug port is open
curl http://localhost:9222/json
# Should return JSON with browser info
```

### "Module not found" or npm errors

```bash
cd /path/to/tradingview-mcp
rm -rf node_modules
npm install
```

### Claude doesn't know about TradingView tools

**Cause:** The MCP server isn't configured or isn't running.

**Fix:**
1. Verify `~/.claude/.mcp.json` has the correct path
2. Restart Claude Code
3. Ask Claude: "What MCP tools do you have available?" — it should list TradingView tools

### Skill not triggering

**Cause:** Skill file not in the right location.

```bash
ls ~/.claude/skills/tradingview-mcp/SKILL.md
```

If not found, repeat Step 6.

### "chart_ready: false" after symbol switch

Add a brief wait before drawing or screenshotting. Tell Claude: "Wait for the chart to load before proceeding."

### Screenshots are saving but look wrong

- Ensure TradingView window is not minimized or behind other windows
- Use `region: "chart"` not `region: "full"` for cleaner output

---

## Session Workflow (Every Day)

```
1.  ~/launch-tradingview.sh      ← always first
2.  Wait for TradingView to load
3.  claude                        ← open Claude Code
4.  "Check my TradingView connection"
5.  Start analyzing
```

You only need to run Steps 1–4 once per session. Claude stays connected until you close it.

---

## Updating the MCP Server

```bash
cd /path/to/tradingview-mcp
git pull
npm install
```

Then restart Claude Code.

---

## Uninstalling

```bash
# Remove MCP config entry (edit ~/.claude/.mcp.json)
# Remove skill
rm -rf ~/.claude/skills/tradingview-mcp
# Remove launch script
rm ~/launch-tradingview.sh
# Remove MCP server (optional)
rm -rf /path/to/tradingview-mcp
```

---

*Questions? Open an issue on the [GitHub repo](https://github.com/digitalleonard/tradingview-mcp).*
