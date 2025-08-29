@echo off
echo ========================================
echo       Flappy Bird Project Launcher
echo ========================================
echo.

REM Check if project file exists
if not exist "project.godot" (
    echo [ERROR] Project file project.godot not found!
    echo [ERROR] Please ensure you are running this script from the correct project directory.
    echo.
    pause
    exit /b 1
)

echo [INFO] Found Flappy Bird project file
echo [INFO] Project path: %CD%
echo.

REM Check for Godot executable
set GODOT_PATH=""
set GODOT_FOUND=false

REM Check current directory's bin folder
if exist "bin\godot.windows.editor.dev.x86_64.exe" (
    set GODOT_PATH="bin\godot.windows.editor.dev.x86_64.exe"
    set GODOT_FOUND=true
    echo [INFO] Found local Godot editor
) else if exist "bin\godot.windows.editor.dev.x86_64.console.exe" (
    set GODOT_PATH="bin\godot.windows.editor.dev.x86_64.console.exe"
    set GODOT_FOUND=true
    echo [INFO] Found local Godot editor (console version)
)

REM Check parent directory's godot_source/bin folder
if not %GODOT_FOUND%==true (
    if exist "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe" (
        set GODOT_PATH="..\godot_source\bin\godot.windows.editor.dev.x86_64.exe"
        set GODOT_FOUND=true
        echo [INFO] Found Godot editor in parent directory
    ) else if exist "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe" (
        set GODOT_PATH="..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe"
        set GODOT_FOUND=true
        echo [INFO] Found Godot editor (console version) in parent directory
    )
)

REM Check system PATH for Godot
if not %GODOT_FOUND%==true (
    where godot >nul 2>&1
    if %ERRORLEVEL%==0 (
        set GODOT_PATH=godot
        set GODOT_FOUND=true
        echo [INFO] Found Godot in system PATH
    )
)

if not %GODOT_FOUND%==true (
    echo [ERROR] Godot executable not found!
    echo.
    echo [HELP] Please ensure one of the following conditions is met:
    echo        - Godot build exists in current or parent directory
    echo        - Godot executable is in system PATH
    echo        - Manually specify Godot path
    echo.
    echo [HELP] Or build Godot first:
    echo        - Run build.bat in godot_source directory
    echo.
    pause
    exit /b 1
)

echo [INFO] Using Godot: %GODOT_PATH%
echo.

REM Display launch options
echo Please select launch method:
echo 1. Open project directly (recommended)
echo 2. Open editor only
echo 3. Open project and run
echo 4. Exit
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo [INFO] Opening Flappy Bird project...
    start "" %GODOT_PATH% --path "%CD%"
    echo [SUCCESS] Project opened!
) else if "%choice%"=="2" (
    echo [INFO] Opening Godot editor...
    start "" %GODOT_PATH%
    echo [SUCCESS] Editor opened!
) else if "%choice%"=="3" (
    echo [INFO] Opening project and running...
    start "" %GODOT_PATH% --path "%CD%" --main-pack "%CD%\MainScene.tscn"
    echo [SUCCESS] Project opened and running!
) else if "%choice%"=="4" (
    echo [INFO] Exiting launcher
    exit /b 0
) else (
    echo [ERROR] Invalid choice, using default method to open project
    start "" %GODOT_PATH% --path "%CD%"
    echo [SUCCESS] Project opened!
)

echo.
echo ========================================
echo [TIPS] Usage Tips:
echo [TIPS] - If project doesn't open, check Godot path settings
echo [TIPS] - First launch may take longer time
echo [TIPS] - Run in command line to see detailed output
echo [TIPS] - Use --path parameter to specify project path
echo ========================================
echo.
pause
