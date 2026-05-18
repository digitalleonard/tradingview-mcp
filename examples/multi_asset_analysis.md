# Example: 7-Pair Multi-Asset Analysis

This is a real walkthrough of Claude running a full top-down analysis across 7 trading pairs using the TradingView MCP. This exact workflow was executed live and the output below is genuine.

**Pairs analyzed:** BTCUSDT, DOGEUSDT, LINKUSDT, JELLYJELLYUSDT, LTCUSDT, USELESSUSDT, APEUSDT
**Date:** May 2026
**Timeframes:** Weekly → Daily → 4H → 1H

---

## How It Was Run

The user typed one prompt:

> *"Analyze BTCUSDT, DOGEUSDT, LINKUSDT, JELLYJELLYUSDT, LTCUSDT, USELESSUSDT, APEUSDT — full top-down MTF analysis, mark all key levels on chart, setup for each if valid."*

Claude then:
1. Connected to TradingView (`tv_health_check`)
2. For each pair: switched symbol → pulled W/D/4H/1H OHLCV → analyzed structure
3. Switched to 4H → drew key levels → screenshotted each chart
4. Compiled the full report below

Total time: ~8 minutes for 7 pairs.

---

## MARKET SUMMARY

---

### $BTCUSDT — Neutral/Bullish | Corrective Pullback

BTC is 52-week down -25% from $106K open, but structurally recovering from the $60K weekly floor with four consecutive bullish weekly closes. Price tagged the $82,850 HTF resistance — a clean equal-highs liquidity zone — and initiated a corrective pullback to the $78,754–$79,500 equilibrium zone. The 4H structure shows distribution after the $82,850 rejection with a sharp flush to $78,754 (4H demand). The 1H is now ranging, coiling for a directional break. Losing $78,000 cleanly on a 4H close opens a run toward the $74,937–$75,000 demand zone. Holding and reclaiming $80,500 reinstates bullish continuation targeting $82,850 retest and eventual breakout toward $88K–$90K.

**Key levels drawn on chart:**
- 🔴 $82,850 — Major Resistance / Equal Highs
- 🟠 $81,000 — Supply Zone Top
- 🟠 $79,500 — Supply Zone Base / Current Price
- 🟢 $78,200 — 4H Demand / Key Support
- 🟢 $74,937 — Major Demand / BOS Level

---

### $DOGEUSDT — Bullish | Cleanest Setup in the List

DOGE printed a textbook 4-week accumulation sequence from the $0.080 weekly low, establishing a clean staircase of HH/HL on the weekly. Price is now approaching the $0.117 resistance cluster — a level that aligns with a 4H equal-highs liquidity pool and the prior daily distribution zone. The 1H swept the $0.1096 demand cleanly and recovered with intent. A confirmed 4H close above $0.117 flips DOGE into breakout mode targeting $0.125–$0.140.

**Key levels drawn on chart:**
- 🔴 $0.11706 — Key Resistance / 4H High
- 🟠 $0.11472 — 1H Liquidity Pool / EQH
- 🟢 $0.11000 — 4H Demand / Key Support
- 🟢 $0.10643 — 1H Low / Liquidity Grab Zone
- 🟢 $0.09617 — Major Demand / BOS Level

---

### $LINKUSDT — Neutral/Bullish | Demand Retest

LINK broke a multi-week compression with a +17% weekly BOS candle from the $7.15 annual low, tagging $10.87 — a significant structural high. Price is now in a healthy 4H pullback phase, testing the $10.03 demand base. A decisive 4H hold here with bullish momentum shift confirms the higher low and opens a measured move toward $12.00–$13.50.

**Key levels drawn on chart:**
- 🔴 $10.87 — Key Resistance / 4H High
- 🟢 $10.03 — 1H Support / Demand Base
- 🟢 $9.09 — 4H Demand Zone
- 🟢 $8.91 — Major Demand / 4H Low

---

### $JELLYJELLYUSDT — Neutral | No Setup

JELLY spiked to $0.0758 in the 4H window — a classic liquidity sweep above the prior local highs — and was immediately rejected back to $0.058–$0.061. The $0.0758 spike is a red flag: it printed with a long upper wick followed by sharp distribution. Price needs to hold above $0.0578 and reclaim $0.065+ for any bullish case. Until then, structure is compromised.

> **No high-probability setup at the moment.**

---

### $LTCUSDT — Neutral | Decision Point

LTC is at a pivotal decision point. After a -43.67% year-over-year decline from the $136 high, the $45.07 annual low appears to be in. The most recent weekly printed a strong BOS candle to $60.61 — the first meaningful HH in months. Price is now pulling back from that high, retesting the $56.28–$57.00 former resistance-turned-support level. A 4H close reclaiming $57.50 re-opens the $60.61 target.

**Key levels drawn on chart:**
- 🔴 $60.61 — Key Resistance / 4H-Daily High
- 🟠 $58.00 — 4H Mid-Range / Supply Base
- 🟢 $56.28 — 1H Low / Key Demand
- 🟢 $54.35 — 4H Base Demand

---

### $USELESSUSDT — Bearish Short-Term | Blow-Off Rejection

USELESS has been on a strong 90-day trend (+87%), building from $0.027 to a $0.086 spike high. However, yesterday's daily candle was a brutal rejection — price touched $0.086 and closed at $0.079, followed by a continuation sell-off to $0.060. This is a classic blow-off top signal on the daily. Any retracement toward $0.068–$0.071 presents a short entry.

**Key levels drawn on chart:**
- 🔴 $0.086 — Spike High / Major Resistance
- 🟠 $0.071 — Intermediate Resistance / Supply
- 🟢 $0.0605 — Key Support / Demand Base
- 🟢 $0.0536 — 4H Demand / Major Support

---

### $APEUSDT — Bearish | Structurally Broken

APE is structurally destroyed on the weekly — down -78% year-over-year from $0.786. Three weeks ago, price printed a shocking spike to $0.278 (a liquidity grab), then crashed back to the $0.145–$0.165 range. That $0.278 wick is now permanent overhead supply. The 1H is printing LH/LL with price pressing against the $0.1464 support. A confirmed break below $0.1464 opens $0.138 → $0.100.

**Key levels drawn on chart:**
- 🔴 $0.278 — Liquidity Grab / Pump Wick / Overhead Supply
- 🔴 $0.163 — 4H Resistance / Short Entry Zone
- 🟢 $0.1464 — 1H Low / Key Support — Decision Level
- 🟠 $0.138 — TP1 / Next Support
- 🟢 $0.1004 — 4H Base Demand

---

## TRADE SETUPS

---

### BTCUSDT — LONG

```
📍 Entry:       $77,800 – $78,500 (4H demand zone retest)
⚡️ TP1:        $82,000
⚡️ TP2:        $85,000
⚡️ TP3:        $88,500
🛑 Stop Loss:   $75,800
📊 RR:          1.9:1 → 3.3:1 → 5.3:1
🔥 Confidence:  6.5/10
```
> Wait for 1H CHoCH signal from demand. Do not front-run.

---

### BTCUSDT — SHORT (Alternative)

```
📍 Entry:       $81,200 – $82,000 (supply zone retest)
⚡️ TP1:        $78,000
⚡️ TP2:        $75,000
⚡️ TP3:        $73,200
🛑 Stop Loss:   $83,500
📊 RR:          1.6:1 → 3.1:1 → 3.7:1
🔥 Confidence:  6/10
```
> Only valid if price rejects with 1H bearish structure shift. Do not short into strength.

---

### DOGEUSDT — LONG ⭐ TOP PICK

```
📍 Entry:       $0.1095 – $0.1115 (4H demand / 1H CHoCH)
⚡️ TP1:        $0.1170
⚡️ TP2:        $0.1250
⚡️ TP3:        $0.1400
🛑 Stop Loss:   $0.1045
📊 RR:          1.1:1 → 2.4:1 → 4.3:1
🔥 Confidence:  7/10
```
> Best structure in the list. Multiple timeframe confluence. Partial exit at TP1 is the smart money move.

---

### LINKUSDT — LONG ⭐ TOP PICK

```
📍 Entry:       $10.00 – $10.15 (4H demand / 1H CHoCH)
⚡️ TP1:        $10.87
⚡️ TP2:        $12.00
⚡️ TP3:        $13.50
🛑 Stop Loss:   $9.45
📊 RR:          1.4:1 → 3.5:1 → 6.0:1
🔥 Confidence:  6.5/10
```
> Needs confirming 1H candle before entry. Risk of deeper sweep to $9.09.

---

### JELLYJELLYUSDT

> ⚠️ **No high-probability setup at the moment.** Choppy post-spike. Monitor for base formation above $0.0578.

---

### LTCUSDT — LONG

```
📍 Entry:       $55.80 – $56.50 (S/R flip zone / 4H demand)
⚡️ TP1:        $60.61
⚡️ TP2:        $65.00
⚡️ TP3:        $70.00
🛑 Stop Loss:   $53.50
📊 RR:          1.8:1 → 3.6:1 → 5.0:1
🔥 Confidence:  5.5/10
```
> Needs 4H close reclaim of $57.50 minimum before trusting.

---

### USELESSUSDT — SHORT (Conditional)

```
📍 Entry:       $0.068 – $0.071 (wait for retracement to supply)
⚡️ TP1:        $0.060
⚡️ TP2:        $0.053
⚡️ TP3:        $0.044
🛑 Stop Loss:   $0.076
📊 RR:          1.4:1 → 2.8:1 → 4.2:1
🔥 Confidence:  5/10
```
> Ultra-low liquidity token. Micro position sizing only. Do not chase current price.

---

### APEUSDT — SHORT (Conditional)

```
📍 Entry:       $0.155 – $0.163 (wait for retracement to supply)
⚡️ TP1:        $0.138
⚡️ TP2:        $0.100
⚡️ TP3:        $0.085
🛑 Stop Loss:   $0.172
📊 RR:          1.1:1 → 3.7:1 → 4.5:1
🔥 Confidence:  5/10
```
> Wait for retrace into supply. If $0.1464 breaks before retrace, reassess — breakdown entry has poor RR.

---

## Final Priority Ranking

| Rank | Pair | Bias | Confidence |
|------|------|------|------------|
| 1 | **DOGEUSDT** | Bullish | 7/10 |
| 2 | **LINKUSDT** | Bullish | 6.5/10 |
| 3 | **BTCUSDT** | Neutral | 6.5/10 |
| 4 | LTCUSDT | Neutral | 5.5/10 |
| 5 | USELESSUSDT | Bearish | 5/10 |
| 6 | APEUSDT | Bearish | 5/10 |
| 7 | JELLYJELLYUSDT | Neutral | No setup |

---

## What Claude Generated Automatically

For each pair, Claude:
- Switched the TradingView chart to that symbol
- Pulled 4 timeframes of OHLCV data (W/D/4H/1H)
- Analyzed market structure (HH/HL, BOS, CHoCH, liquidity zones)
- Drew key horizontal levels with color-coded labels
- Took an annotated screenshot
- Wrote the market summary and setup

All charts were annotated and saved to the `screenshots/` folder automatically.

---

## How to Replicate This

```
Open Claude Code and say:

"Analyze [PAIR1], [PAIR2], [PAIR3] using top-down multi-timeframe analysis.
For each pair: pull weekly, daily, 4H, and 1H data, identify market structure,
mark key S/R levels on the 4H chart, take a screenshot, and give me a setup
if there is valid confluence with at least 1:2 RR."
```

Claude will do the rest.
