@echo off
echo Checking FlappyBird project status...

REM Check for Godot editor processes
tasklist /FI "IMAGENAME eq godot*" 2>NUL | find /I "godot" >NUL
if %ERRORLEVEL% EQU 0 (
    echo [INFO] Found running Godot editor process
    echo [INFO] FlappyBird project is already running!
    echo [INFO] No need to start again.
    exit /b 1
) else (
    echo [INFO] No running Godot editor process found
    echo [INFO] Project is not running, can start.
    exit /b 0
)
