# TradingView MCP × Claude Code

> **Give Claude full control of your TradingView Desktop chart.**
> Analyze markets, draw levels, read indicators, take screenshots, build Pine Scripts, and run multi-asset scans — all through natural language inside Claude Code.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)
![Platform](https://img.shields.io/badge/Platform-Mac%20%7C%20Windows%20%7C%20Linux-blue.svg)
![Tools](https://img.shields.io/badge/MCP%20Tools-78-orange.svg)
![TradingView](https://img.shields.io/badge/TradingView-Desktop-blueviolet.svg)

---

## What This Is

This repo gives you:

1. **A complete setup guide** — connect Claude Code to TradingView Desktop in minutes
2. **A Claude Code skill** — smart prompting layer that knows every tool and when to use it
3. **78 MCP tools** via the [TradingView MCP server](https://github.com/tradesdontlie/tradingview-mcp)
4. **Real workflows** — multi-asset analysis, S/R drawing, Pine Script development, batch scanning

**Architecture:**
```
Claude Code  ←→  MCP Server (stdio)  ←→  CDP Port 9222  ←→  TradingView Desktop
```

Claude talks to an MCP server. The MCP server talks to TradingView Desktop via Chrome DevTools Protocol. Everything runs locally — no external servers, no API calls to TradingView, no data leaves your machine.

---

## What Claude Can Do With Your Chart

| Category | What It Can Do |
|----------|---------------|
| **Chart Control** | Switch symbols, timeframes, chart types, scroll to date |
| **Price Data** | Pull OHLCV bars, real-time quotes, order book depth |
| **Indicators** | Add/remove/configure RSI, MACD, BB, EMAs, any study |
| **Pine Script** | Read indicator output — lines, labels, tables, zones |
| **Drawings** | Draw S/R levels, trend lines, rectangles, text labels |
| **Screenshots** | Capture chart, full screen, or strategy tester |
| **Pine Dev** | Inject, compile, debug Pine Script from Claude |
| **Alerts** | Create, list, delete price alerts |
| **Replay** | Bar-by-bar replay with simulated trade execution |
| **Batch** | Run any action across 10+ symbols automatically |
| **Streaming** | Monitor real-time quotes and indicator values |

---

## Prerequisites

Before you start, you need all of these:

| Requirement | Notes |
|-------------|-------|
| **TradingView Desktop** | Paid subscription required. Download at [tradingview.com](https://www.tradingview.com/desktop/) |
| **Node.js 18+** | [nodejs.org](https://nodejs.org/) — check with `node --version` |
| **Claude Code** | [claude.ai/code](https://claude.ai/code) — the CLI, not the web app |
| **Git** | For cloning the MCP server repo |
| **macOS / Windows / Linux** | All platforms supported |

> ⚠️ **TradingView Desktop is required.** The web app at tradingview.com does NOT work. You need the downloadable desktop application.

---

## Quick Install (5 Minutes)

### Step 1 — Clone the MCP Server

```bash
git clone https://github.com/tradesdontlie/tradingview-mcp.git
cd tradingview-mcp
npm install
```

Note the full path to this folder. You'll need it in Step 3.

```bash
pwd
# Example: /Users/yourname/tradingview-mcp
```

### Step 2 — Add the Launch Script

**macOS** — copy the included script:
```bash
cp scripts/launch_tv_debug_mac.sh ~/launch-tradingview.sh
chmod +x ~/launch-tradingview.sh
```

**Windows** — copy the batch file:
```
scripts\launch_tv_debug_windows.bat → Desktop or anywhere easy to access
```

**Linux:**
```bash
cp scripts/launch_tv_debug_linux.sh ~/launch-tradingview.sh
chmod +x ~/launch-tradingview.sh
```

### Step 3 — Configure Claude Code

Add this to `~/.claude/.mcp.json` (create it if it doesn't exist):

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

Replace `/FULL/PATH/TO/tradingview-mcp` with the path from Step 1.

### Step 4 — Install the Claude Skill

```bash
mkdir -p ~/.claude/skills/tradingview-mcp
cp skills/tradingview-mcp/SKILL.md ~/.claude/skills/tradingview-mcp/SKILL.md
```

### Step 5 — First Run

```bash
# 1. Launch TradingView with debug port
~/launch-tradingview.sh   # Mac/Linux
# or double-click launch_tv_debug_windows.bat on Windows

# 2. Open Claude Code in any project
claude

# 3. Verify connection
# Ask Claude: "Check my TradingView connection"
```

Claude will run `tv_health_check` and confirm it's connected. You're ready.

---

## How to Use It

Once connected, just talk to Claude naturally:

```
"Analyze BTCUSDT on the 4H and mark the key levels"
"Switch to ETHUSDT and pull the last 90 daily candles"
"Draw support at 78200 and resistance at 82850 in red"
"Screenshot the current chart"
"Add RSI to the chart and tell me the current value"
"Scan BTCUSDT, ETHUSDT, SOLUSDT on the weekly and give me bias for each"
"Write a Pine Script that marks equal highs and lows"
"Set an alert when BTC crosses 85000"
```

Claude knows which of the 78 tools to call, in what order, and how to interpret the output.

---

## Full Tool Reference (78 Tools)

### 🔌 Connection & Launch
| Tool | Description |
|------|-------------|
| `tv_launch` | Auto-launch TradingView Desktop with CDP debug port |
| `tv_health_check` | Verify connection — **always call this first** |
| `chart_get_state` | Get current symbol, timeframe, all loaded indicators + entity IDs |
| `tv_ui_state` | Read full UI state |
| `tv_discover` | Discover available chart elements |

### 📈 Chart Control
| Tool | Description |
|------|-------------|
| `chart_set_symbol` | Switch to any ticker: `BTCUSDT`, `AAPL`, `ES1!`, `NYMEX:CL1!` |
| `chart_set_timeframe` | Set resolution: `1` `5` `15` `60` `240` `D` `W` `M` |
| `chart_set_type` | Chart style: candles, bars, Heikin Ashi, line, area |
| `chart_scroll_to_date` | Jump to any date (ISO format: `2024-01-15`) |
| `chart_manage_indicator` | Add/remove studies. Use FULL names: `"Relative Strength Index"` not `"RSI"` |
| `indicator_set_inputs` | Change indicator settings: length, source, etc. |
| `indicator_toggle_visibility` | Show/hide indicator without removing it |

### 📉 Price Data
| Tool | Description |
|------|-------------|
| `quote_get` | Real-time snapshot: last price, OHLC, volume (pass symbol or leave blank for current chart) |
| `data_get_ohlcv` | Historical bars. **Always use `summary=true`** unless you need raw bars. |
| `data_get_study_values` | Read numeric output from any visible indicator (RSI value, MACD line, etc.) |

**Recommended OHLCV counts by timeframe:**
```
Weekly:  count=52   → 1 full year
Daily:   count=90   → 3 months
4H:      count=120  → 20 days
1H:      count=72   → 3 days
15M:     count=96   → 1 day
```

### 🌲 Pine Script Output (Custom Indicators)
| Tool | When to Use |
|------|-------------|
| `data_get_pine_lines` | Horizontal price levels drawn by custom indicators |
| `data_get_pine_labels` | Text annotations on chart ("PDH 24550", "Bias: Long") |
| `data_get_pine_tables` | Table data from Pine dashboards and stat panels |
| `data_get_pine_boxes` | Price zones as `{high, low}` pairs (supply/demand boxes) |

> ⚠️ Always pass `study_filter` to target a specific indicator by name. The indicator **must be visible** on the chart.

### ✏️ Drawing Tools
| Tool | Shape Types |
|------|-------------|
| `draw_shape` | `horizontal_line` · `vertical_line` · `trend_line` · `rectangle` · `text` |
| `draw_clear` | Remove all drawings from chart |
| `draw_list` | List all current drawings with IDs |
| `draw_get_properties` | Get style and position of a specific drawing |
| `draw_remove_one` | Remove a single drawing by ID |

**Color + style overrides (pass as JSON string):**
```json
{"linecolor": "#ef5350", "linewidth": 2, "linestyle": 0}
```

| `linestyle` | Style |
|-------------|-------|
| `0` | Solid |
| `1` | Dashed |
| `2` | Dotted |

**Standard color palette:**
```
Resistance  →  #ef5350  (red)
Support     →  #26a69a  (teal)
Supply zone →  #ff9800  (orange)
Demand zone →  #4caf50  (green)
Entry       →  #f97316  (orange, dashed)
Stop Loss   →  #ef4444  (red, solid)
Take Profit →  #22c55e  (green, dashed)
Neutral     →  #2196f3  (blue)
```

### 📸 Screenshots
| Tool | Options |
|------|---------|
| `capture_screenshot` | `region`: `"full"` · `"chart"` · `"strategy_tester"` |

Saved to `tradingview-mcp/screenshots/` by default. Claude can display the image inline.

### ⚠️ Alerts
| Tool | Description |
|------|-------------|
| `alert_create` | Create a price or condition alert |
| `alert_list` | View all active alerts |
| `alert_delete` | Remove an alert by ID |

### 🌀 Pine Script Development
| Tool | Description |
|------|-------------|
| `pine_set_source` | Inject Pine Script code into the editor |
| `pine_smart_compile` | Compile + auto-check errors in one step |
| `pine_get_errors` | Read compilation errors |
| `pine_get_console` | Read `log.info()` console output |
| `pine_analyze` | Static analysis of the script |
| `pine_check` | Syntax check without compiling |
| `pine_compile` | Compile only |
| `pine_get_source` | Read current script code ⚠️ can be 200KB+ — avoid unless editing |
| `pine_new` | Create a new blank script |
| `pine_open` | Open a saved script |
| `pine_save` | Save the current script |
| `pine_list_scripts` | List all saved Pine scripts |

### 🔁 Replay Mode
| Tool | Description |
|------|-------------|
| `replay_start` | Enter bar replay at a specific date |
| `replay_step` | Step one bar forward |
| `replay_autoplay` | Auto-play replay at a set speed |
| `replay_trade` | Simulate a trade in replay |
| `replay_status` | Check current replay position |
| `replay_stop` | Exit replay mode |

### ⚡ Batch Operations
| Tool | Description |
|------|-------------|
| `batch_run` | Run any action across multiple symbols/timeframes in one call |

**Example:** Screenshot 10 symbols on 4H automatically:
```
batch_run → action: capture_screenshot
            symbols: [BTCUSDT, ETHUSDT, SOLUSDT, BNBUSDT, ADAUSDT, DOGEUSDT, LINKUSDT, LTCUSDT, DOTUSDT, AVAXUSDT]
            timeframe: 240
```

### 📊 Market & Symbol Data
| Tool | Description |
|------|-------------|
| `symbol_search` | Find any tradable instrument by name |
| `symbol_info` | Exchange, type, currency, full description |
| `depth_get` | Order book bid/ask levels |
| `data_get_strategy_results` | Backtest performance stats (if strategy loaded) |
| `data_get_equity` | Strategy equity curve data |
| `data_get_trades` | Backtest trade history list |

### 🖥️ Layouts & Panes
| Tool | Description |
|------|-------------|
| `pane_list` | List all chart panes |
| `pane_focus` | Focus a specific pane |
| `pane_set_layout` | Set layout (single, 2x1, 2x2, etc.) |
| `pane_set_symbol` | Assign a different symbol to a specific pane |
| `layout_list` | List all saved TradingView layouts |
| `layout_switch` | Switch to a named saved layout |

### 🖱️ UI Interaction (Advanced)
| Tool | Description |
|------|-------------|
| `ui_click` | Click a UI element |
| `ui_hover` | Hover over an element |
| `ui_scroll` | Scroll in the chart or UI |
| `ui_type_text` | Type text into a field |
| `ui_keyboard` | Execute a keyboard shortcut |
| `ui_find_element` | Find an element on screen |
| `ui_open_panel` | Open a panel (strategy tester, screener, etc.) |
| `ui_fullscreen` | Toggle fullscreen mode |
| `ui_evaluate` | Evaluate JavaScript in the TradingView context |

### 🗂️ Tabs
| Tool | Description |
|------|-------------|
| `tab_list` | List all open tabs |
| `tab_new` | Open a new chart tab |
| `tab_switch` | Switch to a specific tab |
| `tab_close` | Close a tab |

### 👁️ Watchlist
| Tool | Description |
|------|-------------|
| `watchlist_add` | Add a symbol to the watchlist |
| `watchlist_get` | Get all symbols in the watchlist |

---

## Workflows

### Multi-Timeframe Analysis (Any Asset)

```
1. tv_health_check                    → confirm connected
2. chart_set_symbol → XXXUSDT         → load asset
3. chart_set_timeframe → W            → Weekly context
4. data_get_ohlcv (summary=true, count=52)
5. chart_set_timeframe → D            → Daily context
6. data_get_ohlcv (summary=true, count=90)
7. chart_set_timeframe → 240          → 4H setup
8. data_get_ohlcv (summary=true, count=120)
9. chart_set_timeframe → 60           → 1H entry
10. data_get_ohlcv (summary=true, count=72)
11. draw_clear                         → clean chart
12. draw_shape × N                     → mark key levels
13. capture_screenshot (region: chart) → save annotated chart
```

### Multi-Asset Scan (7 Pairs Example)

```
Loop for each pair in [BTCUSDT, ETHUSDT, SOLUSDT, BNBUSDT, DOGEUSDT, LINKUSDT, LTCUSDT]:
  1. chart_set_symbol
  2. Pull Weekly + 4H OHLCV
  3. Determine bias (structure + key levels)
  4. Draw levels
  5. Screenshot
  6. Move to next pair
```

### Pine Script Development Loop

```
1. pine_new                → blank editor
2. pine_set_source         → inject your code
3. pine_smart_compile      → compile + check
4. pine_get_errors         → read errors (if any)
5. pine_set_source         → fix and re-inject
6. pine_smart_compile      → recompile
7. capture_screenshot      → verify visual output
```

### Real-Time Monitoring

```
1. chart_set_symbol → target pair
2. data_get_study_values → read RSI, MACD, etc.
3. quote_get → real-time price
4. depth_get → order book
(repeat on interval)
```

---

## Real Output Example

Here is a real analysis output Claude generated using this setup:

> **$BTCUSDT** — BTC is recovering from the $60K annual floor with four consecutive bullish weekly closes. Price tagged the $82,850 HTF resistance — a clean equal-highs liquidity zone — and initiated a corrective pullback to the $78,754–$79,500 equilibrium zone. The 4H shows distribution after the rejection. Losing $78,000 on a 4H close opens $74,937. Holding and reclaiming $80,500 targets $82,850 retest.

```
Trading Pair: BTCUSDT
🔸 LONG Setup (Bullish bias)

📍 Entry:   $77,800 – $78,500
⚡️ TP1:    $82,000
⚡️ TP2:    $85,000
⚡️ TP3:    $88,500
🛑 SL:      $75,800
📊 RR:      1.9:1 → 3.3:1 → 5.3:1
🔥 Confidence: 6.5/10
```

See [`examples/multi_asset_analysis.md`](examples/multi_asset_analysis.md) for the full 7-pair walkthrough.

---

## Common Issues & Fixes

| Problem | Fix |
|---------|-----|
| `CDP connection failed` | Run the launch script before opening Claude Code |
| Chart is blank after symbol switch | Wait for `chart_ready: true` before drawing or screenshotting |
| `chart_manage_indicator` fails | Use the FULL study name: `"Relative Strength Index"` not `"RSI"` |
| `data_get_pine_*` returns empty | Indicator must be **visible** on chart. Pass `study_filter` with exact name. |
| `pine_get_source` is slow/hangs | Avoid on complex scripts — can return 200KB+. Only use when editing. |
| Screenshots are black | Chart isn't ready. Add a brief wait or re-check `chart_ready` flag. |
| Drawing appears in wrong position | `time` must be a valid UNIX timestamp. Use the current bar's time from OHLCV output. |
| Node.js version error | Run `node --version` — needs 18+. Update at nodejs.org |
| MCP server not found in Claude | Check the full absolute path in `~/.claude/.mcp.json` |

---

## Security & Privacy

- **100% local** — no data leaves your machine
- **No TradingView API** — connects via local CDP debug port only
- **Debug port is opt-in** — TradingView doesn't open port 9222 by default. You enable it with the launch script.
- **Read + draw only** — cannot execute real trades, cannot modify TradingView files, cannot access your account credentials
- **No network traffic interception**

---

## Legal Disclaimer

This project is **not affiliated with, endorsed by, or connected to TradingView Inc. or Anthropic**.

This is a personal productivity tool that automates local UI interaction. Users are responsible for ensuring their use complies with [TradingView's Terms of Service](https://www.tradingview.com/policies/).

**Do not use this tool to:**
- Scrape or redistribute TradingView data commercially
- Circumvent TradingView's access controls or paywalls
- Execute automated trades using extracted data in violation of exchange terms
- Resell or repackage TradingView data or intellectual property

The MIT license applies to the code in this repo only — it does not grant any rights over TradingView software, data, or trademarks.

---

## Project Structure

```
digitalleonard-tradingview-mcp/
├── README.md                        # This file
├── SETUP_GUIDE.md                   # Detailed platform-specific setup
├── CLAUDE.md                        # Tool decision guide for Claude
├── LICENSE                          # MIT
├── .mcp.json.example                # Template MCP config
│
├── skills/
│   └── tradingview-mcp/
│       └── SKILL.md                 # Claude Code skill (install this)
│
├── scripts/
│   ├── launch_tv_debug_mac.sh       # macOS launch script
│   ├── launch_tv_debug_windows.bat  # Windows launch script
│   └── launch_tv_debug_linux.sh     # Linux launch script
│
└── examples/
    └── multi_asset_analysis.md      # 7-pair walkthrough with real output
```

---

## Related Resources

- **MCP Server** (required): [tradesdontlie/tradingview-mcp](https://github.com/tradesdontlie/tradingview-mcp)
- **Claude Code**: [claude.ai/code](https://claude.ai/code)
- **TradingView Desktop**: [tradingview.com/desktop](https://www.tradingview.com/desktop/)
- **MCP Protocol Docs**: [modelcontextprotocol.io](https://modelcontextprotocol.io)

---

## License

MIT © Digital Leonard — see [LICENSE](LICENSE) for full text.

Code license only. Does not cover TradingView software, data, or intellectual property.

---

*Built by [Digital Leonard](https://youtube.com/@digitalleonard) — crypto trader, educator, and AI automation builder.*
