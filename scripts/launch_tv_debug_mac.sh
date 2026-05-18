#!/bin/bash
# ============================================================
# TradingView Desktop — Debug Launch Script (macOS)
# ============================================================
# Launches TradingView with Chrome DevTools Protocol enabled
# on port 9222 so Claude Code can connect to it.
#
# Usage:
#   chmod +x launch_tv_debug_mac.sh
#   ./launch_tv_debug_mac.sh
#
# Or copy to home directory for easy access:
#   cp launch_tv_debug_mac.sh ~/launch-tradingview.sh
#   ~/launch-tradingview.sh
# ============================================================

set -e

PORT=9222
TV_APP="/Applications/TradingView.app/Contents/MacOS/TradingView"

# Check if TradingView is installed
if [ ! -f "$TV_APP" ]; then
  echo "❌ TradingView not found at: $TV_APP"
  echo ""
  echo "Try finding it with:"
  echo "  find /Applications -name 'TradingView.app' 2>/dev/null"
  echo ""
  echo "Then update the TV_APP variable in this script."
  exit 1
fi

# Kill any existing TradingView instances
if pgrep -x "TradingView" > /dev/null; then
  echo "🔄 Closing existing TradingView instance..."
  pkill -x "TradingView" 2>/dev/null || true
  sleep 2
fi

# Check if port 9222 is already in use
if lsof -i :$PORT > /dev/null 2>&1; then
  echo "⚠️  Port $PORT is already in use. Killing existing process..."
  kill -9 $(lsof -t -i:$PORT) 2>/dev/null || true
  sleep 1
fi

# Launch TradingView with CDP debug port
echo "🚀 Launching TradingView Desktop with debug port $PORT..."
"$TV_APP" --remote-debugging-port=$PORT &

TV_PID=$!
echo "✅ TradingView started (PID: $TV_PID)"
echo ""
echo "⏳ Waiting for TradingView to fully load..."
sleep 5

# Verify the debug port is accessible
if curl -s --max-time 3 "http://localhost:$PORT/json" > /dev/null 2>&1; then
  echo "✅ Debug port $PORT is open and ready"
  echo ""
  echo "📋 Next steps:"
  echo "   1. Wait for TradingView to finish loading your chart"
  echo "   2. Open Claude Code: claude"
  echo "   3. Ask Claude: 'Check my TradingView connection'"
else
  echo "⚠️  Port $PORT not yet responding — TradingView may still be loading"
  echo "   Give it 10-15 seconds, then try: curl http://localhost:$PORT/json"
fi
