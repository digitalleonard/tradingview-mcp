#!/bin/bash
# ============================================================
# TradingView Desktop — Debug Launch Script (Linux)
# ============================================================
# Launches TradingView with Chrome DevTools Protocol enabled
# on port 9222 so Claude Code can connect to it.
#
# Usage:
#   chmod +x launch_tv_debug_linux.sh
#   ./launch_tv_debug_linux.sh
# ============================================================

set -e

PORT=9222

# Try common TradingView binary locations
TV_BIN=""
for path in \
  "/usr/bin/tradingview" \
  "/usr/local/bin/tradingview" \
  "$HOME/.local/bin/tradingview" \
  "/opt/TradingView/tradingview" \
  "/opt/tradingview/tradingview"; do
  if [ -f "$path" ]; then
    TV_BIN="$path"
    break
  fi
done

# Check for AppImage
if [ -z "$TV_BIN" ]; then
  APPIMAGE=$(find "$HOME" -name "TradingView*.AppImage" 2>/dev/null | head -1)
  if [ -n "$APPIMAGE" ]; then
    TV_BIN="$APPIMAGE"
  fi
fi

if [ -z "$TV_BIN" ]; then
  echo "❌ TradingView binary not found."
  echo ""
  echo "Please find your TradingView binary and update TV_BIN in this script."
  echo "Or pass the path as an argument: $0 /path/to/tradingview"
  echo ""
  echo "Looking for AppImage? Search with:"
  echo "  find \$HOME -name '*.AppImage' 2>/dev/null"
  exit 1
fi

# Accept path as argument
if [ -n "$1" ]; then
  TV_BIN="$1"
fi

echo "📍 Using TradingView binary: $TV_BIN"

# Kill existing instances
if pgrep -x "tradingview" > /dev/null 2>&1; then
  echo "🔄 Closing existing TradingView instance..."
  pkill -x "tradingview" 2>/dev/null || true
  sleep 2
fi

# Free port if in use
if lsof -i :$PORT > /dev/null 2>&1; then
  echo "⚠️  Port $PORT in use. Freeing it..."
  kill -9 $(lsof -t -i:$PORT) 2>/dev/null || true
  sleep 1
fi

# Launch
echo "🚀 Launching TradingView with debug port $PORT..."
"$TV_BIN" --remote-debugging-port=$PORT &

TV_PID=$!
echo "✅ TradingView started (PID: $TV_PID)"
echo ""
echo "⏳ Waiting for startup..."
sleep 6

# Check port
if curl -s --max-time 3 "http://localhost:$PORT/json" > /dev/null 2>&1; then
  echo "✅ Debug port $PORT is open and ready"
  echo ""
  echo "📋 Next steps:"
  echo "   1. Wait for TradingView to finish loading"
  echo "   2. Open Claude Code: claude"
  echo "   3. Ask Claude: 'Check my TradingView connection'"
else
  echo "⚠️  Port not yet responding. TradingView may still be loading."
  echo "   Wait 10-15 seconds then test: curl http://localhost:$PORT/json"
fi
