@echo off
chcp 65001 >nul
echo ========================================
echo      FlappyBird Smart Launcher
echo ========================================

REM First check if project is already running
echo [INFO] Checking project status...
call check_project_status.bat
if %ERRORLEVEL% EQU 1 (
    echo.
    echo [INFO] Project is already running, no need to start again
    echo [INFO] Press any key to close this window...
    pause >nul
    exit /b 0
)

echo [INFO] Project not running, starting now...
echo.

REM Check project file
if not exist "project.godot" (
    echo [ERROR] Project file project.godot not found
    echo [ERROR] Please ensure you're in the correct project directory
    echo [ERROR] Press any key to close this window...
    pause >nul
    exit /b 1
)

echo [INFO] Found FlappyBird project file
echo [INFO] Project path: %CD%

REM Find Godot editor
set GODOT_PATH=
if exist "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe" (
    set GODOT_PATH=..\godot_source\bin\godot.windows.editor.dev.x86_64.exe
    echo [INFO] Found Godot editor in parent directory
    echo [INFO] Using Godot: "%GODOT_PATH%"
) else if exist "..\..\godot_source\bin\godot.windows.editor.dev.x86_64.exe" (
    set GODOT_PATH=..\..\godot_source\bin\godot.windows.editor.dev.x86_64.exe
    echo [INFO] Found Godot editor in parent directory
    echo [INFO] Using Godot: "%GODOT_PATH%"
) else (
    echo [ERROR] Godot editor not found
    echo [ERROR] Please ensure godot_source directory exists
    echo [ERROR] Press any key to close this window...
    pause >nul
    exit /b 1
)

echo.
echo [INFO] Opening Godot editor and loading Flappy Bird project...
start "" "%GODOT_PATH%" --editor --path "%CD%"

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Godot editor opened and project loaded!
) else (
    echo [ERROR] Failed to start, error code: %ERRORLEVEL%
)

echo.
echo ========================================
echo [TIPS] Usage tips:
echo [TIPS] - First launch may take longer
echo [TIPS] - Using --editor --path to open editor and load project
echo [TIPS] - Keep this window open to see Godot editor logs
echo ========================================
echo.
echo [INFO] This window will stay open to show Godot editor logs
echo [INFO] You can now run the game in Godot editor
echo [INFO] Press any key to close this window when done...
pause >nul
