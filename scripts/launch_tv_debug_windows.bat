@echo off
:: ============================================================
:: TradingView Desktop — Debug Launch Script (Windows)
:: ============================================================
:: Launches TradingView with Chrome DevTools Protocol enabled
:: on port 9222 so Claude Code can connect to it.
::
:: Usage:
::   Double-click this file
::   OR run from Command Prompt: launch_tv_debug_windows.bat
::
:: If TradingView is not found, update the TV_PATH variable below.
:: ============================================================

setlocal

set PORT=9222

:: Common TradingView install locations — update if yours is different
set TV_PATH=%LOCALAPPDATA%\Programs\TradingView\TradingView.exe

:: Try alternate path if primary not found
if not exist "%TV_PATH%" (
  set TV_PATH=%PROGRAMFILES%\TradingView\TradingView.exe
)

:: Check if TradingView exists
if not exist "%TV_PATH%" (
  echo.
  echo ERROR: TradingView not found at:
  echo   %TV_PATH%
  echo.
  echo Please find your TradingView.exe and update TV_PATH in this script.
  echo Common locations:
  echo   %%LOCALAPPDATA%%\Programs\TradingView\TradingView.exe
  echo   %%PROGRAMFILES%%\TradingView\TradingView.exe
  echo.
  pause
  exit /b 1
)

:: Kill existing TradingView instances
echo Closing any existing TradingView instances...
taskkill /F /IM TradingView.exe 2>nul
timeout /t 2 /nobreak >nul

:: Launch TradingView with debug port
echo Launching TradingView Desktop with debug port %PORT%...
start "" "%TV_PATH%" --remote-debugging-port=%PORT%

echo.
echo TradingView is starting...
echo.
timeout /t 8 /nobreak >nul

:: Verify port is open
curl -s --max-time 3 "http://localhost:%PORT%/json" >nul 2>&1
if %ERRORLEVEL% == 0 (
  echo [OK] Debug port %PORT% is open and ready.
) else (
  echo [WAIT] Port %PORT% not yet responding - TradingView may still be loading.
  echo        Give it 10-15 more seconds before connecting Claude Code.
)

echo.
echo Next steps:
echo   1. Wait for TradingView to fully load your chart
echo   2. Open Claude Code in your terminal: claude
echo   3. Ask Claude: "Check my TradingView connection"
echo.
pause
