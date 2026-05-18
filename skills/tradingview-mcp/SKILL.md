---
name: tradingview-mcp
description: Use when the user wants to analyze charts, draw levels, read indicator values, take screenshots, run multi-asset scans, build Pine Scripts, set alerts, or control TradingView Desktop programmatically through Claude. Triggers on any request involving live chart data, technical analysis automation, or TradingView tool use.
---

# TradingView MCP

## Overview

Full programmatic control of TradingView Desktop via Claude Code. 78 tools covering chart control, price data, drawings, indicators, Pine Script development, alerts, screenshots, and batch operations. Everything you can do manually in TradingView, Claude can do through this MCP.

**Requires:** TradingView Desktop (not web) + MCP server running with CDP debug port.

---

## Setup & Installation

### 1. Install the MCP Server

```bash
git clone https://github.com/yoebet/tradingview-mcp.git
cd tradingview-mcp
npm install
```

### 2. Register the MCP in Claude Code

Add to `~/.claude/.mcp.json`:

```json
{
  "mcpServers": {
    "tradingview": {
      "command": "node",
      "args": ["/path/to/tradingview-mcp/src/index.js"],
      "env": {}
    }
  }
}
```

### 3. Launch TradingView with Debug Port

**Mac (create a launch script):**
```bash
#!/bin/bash
# ~/launch-tradingview.sh
/Applications/TradingView.app/Contents/MacOS/TradingView \
  --remote-debugging-port=9222 &
```

```bash
chmod +x ~/launch-tradingview.sh
```

**Windows:**
```batch
"C:\Users\YourName\AppData\Local\Programs\TradingView\TradingView.exe" --remote-debugging-port=9222
```

### 4. Workflow Every Session

```
1. Run ~/launch-tradingview.sh
2. Open Claude Code
3. Call tv_health_check to confirm connection
```

---

## Quick Start

```
# Always check connection first
tv_health_check

# Get current chart state
chart_get_state

# Switch symbol and timeframe
chart_set_symbol → BTCUSDT
chart_set_timeframe → 240   (4H)

# Pull price data
data_get_ohlcv (summary=true)

# Draw a level
draw_shape (horizontal_line, price, color)

# Screenshot
capture_screenshot (region: "chart")
```

---

## Tool Reference by Category

### Connection & State
| Tool | What it does |
|------|-------------|
| `tv_health_check` | Verify CDP connection. Always call first. |
| `tv_launch` | Auto-launch TradingView with debug port |
| `chart_get_state` | Get symbol, timeframe, loaded indicators + entity IDs |

### Chart Control
| Tool | What it does |
|------|-------------|
| `chart_set_symbol` | Switch ticker (BTCUSDT, AAPL, ES1!, NYMEX:CL1!) |
| `chart_set_timeframe` | Set resolution: 1, 5, 15, 60, 240, D, W, M |
| `chart_set_type` | Candles, bars, Heikin Ashi, line, etc. |
| `chart_scroll_to_date` | Jump to a specific date (ISO format) |
| `chart_manage_indicator` | Add/remove studies. Use FULL names: "Relative Strength Index" not "RSI" |
| `indicator_set_inputs` | Change indicator settings (length, source, etc.) |
| `indicator_toggle_visibility` | Show/hide indicator without removing |

### Price Data
| Tool | What it does |
|------|-------------|
| `quote_get` | Real-time snapshot: last price, OHLC, volume |
| `data_get_ohlcv` | Historical bars. Always use `summary=true` unless you need raw bars. |
| `data_get_study_values` | Read numeric output from any visible indicator |

### Pine Script Output (Custom Indicators)
| Tool | When to use |
|------|-------------|
| `data_get_pine_lines` | Horizontal levels drawn by custom scripts |
| `data_get_pine_labels` | Text annotations ("PDH 24550", "Bias: Long") |
| `data_get_pine_tables` | Table data from Pine dashboards |
| `data_get_pine_boxes` | Price zones as {high, low} pairs |

> ⚠️ Always pass `study_filter` to target a specific indicator. Indicator must be **visible** on chart.

### Drawing Tools
| Tool | Shape types |
|------|------------|
| `draw_shape` | `horizontal_line`, `vertical_line`, `trend_line`, `rectangle`, `text` |
| `draw_clear` | Remove all drawings |
| `draw_list` | List all current drawings |
| `draw_get_properties` | Get style/position of a specific drawing |
| `draw_remove_one` | Remove a single drawing by ID |

**Draw overrides (JSON string):**
```json
{"linecolor": "#ef5350", "linewidth": 2, "linestyle": 0}
```
`linestyle`: 0 = solid, 1 = dashed, 2 = dotted

**Colors:** Red `#ef5350` | Green `#26a69a` | Orange `#ff9800` | Blue `#2196f3`

### Screenshots
| Tool | Options |
|------|---------|
| `capture_screenshot` | `region`: "full", "chart", "strategy_tester" |

Files saved to `tradingview-mcp/screenshots/` by default.

### Alerts
| Tool | What it does |
|------|-------------|
| `alert_create` | Create a price or condition alert |
| `alert_list` | View all active alerts |
| `alert_delete` | Remove an alert |

### Pine Script IDE
| Tool | What it does |
|------|-------------|
| `pine_set_source` | Inject Pine code into the editor |
| `pine_smart_compile` | Compile + auto-check errors in one step |
| `pine_get_errors` | Read compilation errors |
| `pine_get_console` | Read `log.info()` output |
| `pine_get_source` | Read current script (⚠️ can return 200KB+ — avoid unless editing) |
| `pine_new` / `pine_save` | Create/save scripts |
| `pine_list_scripts` | List saved Pine scripts |

### Replay Mode
| Tool | What it does |
|------|-------------|
| `replay_start` | Enter bar replay at a date |
| `replay_step` | Step one bar forward |
| `replay_autoplay` | Auto-play replay at a speed |
| `replay_trade` | Simulate a trade during replay |
| `replay_stop` | Exit replay mode |

### Batch Operations
| Tool | What it does |
|------|-------------|
| `batch_run` | Run any action across multiple symbols/timeframes in one call |

**Example use:** Screenshot 10 symbols automatically, scan for indicator values across 20 pairs.

### Market Data
| Tool | What it does |
|------|-------------|
| `symbol_search` | Find any tradable instrument |
| `symbol_info` | Exchange, type, currency, full name |
| `quote_get` | Real-time price (current chart or pass a symbol) |
| `depth_get` | Order book bid/ask levels |
| `data_get_strategy_results` | Backtest performance stats |
| `data_get_equity` | Strategy equity curve data |
| `data_get_trades` | Backtest trade history |

### Layout & Panes
| Tool | What it does |
|------|-------------|
| `pane_list` | List all chart panes |
| `pane_focus` | Focus a specific pane |
| `pane_set_layout` | Change pane layout |
| `pane_set_symbol` | Set different symbol per pane |
| `layout_list` | List saved TradingView layouts |
| `layout_switch` | Switch to a saved layout |

---

## Standard Multi-Timeframe Analysis Workflow

Use this structure for any asset:

```
1. tv_health_check                          → confirm connection
2. chart_set_symbol (XXXUSDT)              → load pair
3. For each TF [W, D, 240, 60]:
   - chart_set_timeframe
   - data_get_ohlcv (summary=true, count=52-120)
   - note: high, low, last_5_bars, structure
4. chart_set_timeframe (240)               → switch to 4H for annotation
5. draw_clear                              → clean slate
6. draw_shape (horizontal_line) × N       → mark key levels
7. capture_screenshot (region: "chart")   → save annotated chart
8. Repeat for next pair
```

**Key OHLCV counts by timeframe:**
- Weekly: 52 bars = 1 year
- Daily: 90 bars = ~3 months
- 4H: 120 bars = ~20 days
- 1H: 72 bars = 3 days

---

## Multi-Asset Batch Screenshot

```
batch_run → action: capture_screenshot
           symbols: [BTCUSDT, ETHUSDT, SOLUSDT, DOGEUSDT]
           timeframe: 240
```

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| CDP connection fails | Run `tv_launch` or execute the launch script first |
| `chart_manage_indicator` doesn't work | Use full study name: "Relative Strength Index" not "RSI" |
| `data_get_pine_*` returns empty | Indicator must be visible on chart, pass `study_filter` |
| `pine_get_source` times out | Avoid on complex scripts — returns 200KB+. Use only when editing. |
| Drawings appear on wrong chart | Always call `chart_set_symbol` before drawing — confirm `chart_ready: true` |
| Screenshot is black/blank | Chart isn't ready — wait for `chart_ready: true` after symbol switch |
| `draw_shape` errors | Time must be a valid UNIX timestamp. Use current bar's time from OHLCV. |

---

## Drawing Template — Key Levels

```
Resistance (red solid):    {"linecolor": "#ef5350", "linewidth": 2, "linestyle": 0}
Supply zone (orange dash): {"linecolor": "#ff9800", "linewidth": 1, "linestyle": 1}
Support (teal solid):      {"linecolor": "#26a69a", "linewidth": 2, "linestyle": 0}
Demand (green solid):      {"linecolor": "#4caf50", "linewidth": 2, "linestyle": 0}
Entry (orange dash):       {"linecolor": "#f97316", "linewidth": 2, "linestyle": 2}
SL (red solid):            {"linecolor": "#ef4444", "linewidth": 2, "linestyle": 0}
TP (green dash):           {"linecolor": "#22c55e", "linewidth": 2, "linestyle": 2}
```

---

## Related Skills

- `trade-analysis-output` — Full multi-timeframe analysis → 5 formatted outputs (Telegram, X, YouTube hook, structured setup, follow-up templates)
