# Claude Decision Guide — TradingView MCP

This file teaches Claude which tool to use for every TradingView task. When in doubt, follow these decision trees.

---

## Session Start Checklist

Every session, in this exact order:

```
1. tv_health_check          → Is TradingView running and connected?
   ├─ success → proceed
   └─ fail    → tell user to run launch script, then retry

2. chart_get_state          → What symbol/timeframe is currently on screen?
   (only needed if task requires knowing current state)
```

---

## Decision Tree: What Does the User Want?

```
User request
│
├─ "analyze [ASSET]" / "what's [ASSET] doing" / "give me a setup"
│   └─ → Run Multi-Timeframe Analysis Workflow
│
├─ "draw [level/zone/line]" / "mark [price]"
│   └─ → draw_shape with correct type and overrides
│
├─ "screenshot" / "capture" / "show me the chart"
│   └─ → capture_screenshot (region: "chart")
│
├─ "what's the RSI" / "read the indicator" / "what value is [study]"
│   └─ → data_get_study_values (ensure indicator is visible first)
│
├─ "switch to [SYMBOL]" / "change to [PAIR]"
│   └─ → chart_set_symbol → wait for chart_ready: true
│
├─ "write a Pine Script" / "build an indicator"
│   └─ → Pine Script Development Workflow
│
├─ "set an alert" / "alert me when [price]"
│   └─ → alert_create
│
├─ "scan [multiple pairs]" / "check all of these"
│   └─ → Loop: chart_set_symbol + ohlcv + draw + screenshot per pair
│         OR batch_run if only one action per symbol
│
└─ "what's the price" / "current price of [ASSET]"
    └─ → quote_get (pass symbol name directly)
```

---

## Multi-Timeframe Analysis Workflow

Use this for any single-asset analysis request.

```
Step 1: chart_set_symbol (target pair)
Step 2: chart_set_timeframe → W
        data_get_ohlcv (summary=true, count=52)
        → Read: high, low, last_5_bars, change_pct
        → Determine: weekly trend (HH/HL or LH/LL)

Step 3: chart_set_timeframe → D
        data_get_ohlcv (summary=true, count=90)
        → Read: high, low, last_5_bars
        → Determine: daily trend, key swing levels

Step 4: chart_set_timeframe → 240
        data_get_ohlcv (summary=true, count=120)
        → Read: range, last_5_bars
        → Determine: 4H structure, setup zone

Step 5: chart_set_timeframe → 60
        data_get_ohlcv (summary=true, count=72)
        → Read: last_5_bars
        → Determine: 1H entry context

Step 6: Correlate → derive final bias (Bullish / Bearish / Neutral)

Step 7: chart_set_timeframe → 240   (annotate on 4H)
        draw_clear
        draw_shape × N              (mark key levels)
        capture_screenshot (region: "chart")
```

---

## Drawing: Which Shape for What

| What You Want | Shape Type | Notes |
|---------------|-----------|-------|
| Horizontal S/R level | `horizontal_line` | Single point (time + price) |
| Diagonal trendline | `trend_line` | Requires point1 + point2 |
| Supply/demand zone | `rectangle` | Requires point1 (top-left) + point2 (bottom-right) |
| Text annotation | `text` | Use for labels like "BOS", "CHoCH", "Entry" |
| Session open/close | `vertical_line` | Single point (time only matters) |

**Always pass overrides as a JSON string:**
```
Resistance:  {"linecolor": "#ef5350", "linewidth": 2, "linestyle": 0}
Support:     {"linecolor": "#26a69a", "linewidth": 2, "linestyle": 0}
Supply:      {"linecolor": "#ff9800", "linewidth": 1, "linestyle": 1}
Demand:      {"linecolor": "#4caf50", "linewidth": 2, "linestyle": 0}
Entry:       {"linecolor": "#f97316", "linewidth": 2, "linestyle": 2}
SL:          {"linecolor": "#ef4444", "linewidth": 2, "linestyle": 0}
TP:          {"linecolor": "#22c55e", "linewidth": 2, "linestyle": 2}
```

**Time for draw_shape:** Use the timestamp from the most recent `data_get_ohlcv` last bar.

---

## Reading Indicator Data

**Standard study values (RSI, MACD, etc.):**
```
→ data_get_study_values
  (indicator must be visible and loaded on chart)
```

**Pine Script custom output:**
```
Lines/levels  → data_get_pine_lines  (pass study_filter)
Labels/text   → data_get_pine_labels (pass study_filter)
Tables        → data_get_pine_tables (pass study_filter)
Zones/boxes   → data_get_pine_boxes  (pass study_filter)
```

**Rule:** Always pass `study_filter` with the exact indicator name to target a specific script.

---

## Pine Script Development Workflow

```
Step 1: pine_new               → open fresh editor
Step 2: pine_set_source        → inject the code
Step 3: pine_smart_compile     → compile + error check
Step 4: pine_get_errors        → read errors (if any)
Step 5: fix code in Claude → pine_set_source again
Step 6: pine_smart_compile     → recompile
Step 7: capture_screenshot     → verify visual output on chart
Step 8: pine_save              → save when done
```

**Never use `pine_get_source`** on complex existing scripts — can return 200KB+ and burn your context window. Only use it when you specifically need to READ and EDIT existing code.

---

## OHLCV: summary=true vs raw bars

| Use Case | Setting |
|----------|---------|
| Trend analysis, bias determination | `summary=true` — get high/low/change/last_5_bars |
| Precise entry timing, candle-by-candle review | `summary=false` — get all raw bars |
| Default | Always start with `summary=true` |

**Count by timeframe:**
```
Weekly  → 52  (1 year)
Daily   → 90  (3 months)
4H      → 120 (20 days)
1H      → 72  (3 days)
15M     → 96  (1 day)
```

---

## Multi-Asset Scan Pattern

```
For each pair in the list:
  1. chart_set_symbol (pair)
  2. chart_set_timeframe (target TF)
  3. data_get_ohlcv (summary=true)
  4. Determine bias
  5. draw_clear
  6. draw_shape × N (key levels)
  7. capture_screenshot (filename: PAIR_TF_analysis)
  8. Store findings → move to next pair

After all pairs:
  → Compile summary table
  → Rank by setup quality
  → Surface top 2-3 actionable setups
```

Use `batch_run` if you only need ONE action per symbol (e.g., screenshot all pairs on 4H without analysis).

---

## When NOT to Use Certain Tools

| Tool | Don't Use When |
|------|----------------|
| `pine_get_source` | Script is large/complex — use only for editing |
| `data_get_pine_*` | Indicator isn't visible on chart |
| `ui_evaluate` | Simpler tool exists — this is a last resort |
| `chart_manage_indicator` with short name | Always use full name: "Relative Strength Index" |
| `capture_screenshot` | Immediately after symbol switch — wait for `chart_ready: true` |

---

## Error Recovery

| Error | Response |
|-------|----------|
| CDP connection failed | Tell user to run launch script. Do NOT retry in a loop. |
| `chart_ready: false` | Wait, then try `chart_get_state` again before proceeding |
| Pine compile errors | Read `pine_get_errors`, fix the code, recompile |
| Empty Pine output | Check indicator is visible, pass correct `study_filter` |
| Drawing at wrong price | Verify timestamp is from current chart context |
