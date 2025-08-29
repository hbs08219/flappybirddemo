@echo off
chcp 65001 >nul
echo ========================================
echo       Flappy Bird 项目启动器
echo ========================================
echo.

REM 检查项目文件是否存在
if not exist "project.godot" (
    echo [ERROR] 未找到项目文件 project.godot！
    echo [ERROR] 请确保在正确的项目目录中运行此脚本。
    echo.
    pause
    exit /b 1
)

echo [INFO] 找到 Flappy Bird 项目文件
echo [INFO] 项目路径: %CD%
echo.

REM 检查 Godot 可执行文件
set GODOT_PATH=""
set GODOT_FOUND=false

REM 检查当前目录的 bin 文件夹
if exist "bin\godot.windows.editor.dev.x86_64.exe" (
    set GODOT_PATH="bin\godot.windows.editor.dev.x86_64.exe"
    set GODOT_FOUND=true
    echo [INFO] 找到本地 Godot 编辑器
) else if exist "bin\godot.windows.editor.dev.x86_64.console.exe" (
    set GODOT_PATH="bin\godot.windows.editor.dev.x86_64.console.exe"
    set GODOT_FOUND=true
    echo [INFO] 找到本地 Godot 编辑器（控制台版本）
)

REM 检查上级目录的 godot_source/bin 文件夹
if not %GODOT_FOUND%==true (
    if exist "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe" (
        set GODOT_PATH="..\godot_source\bin\godot.windows.editor.dev.x86_64.exe"
        set GODOT_FOUND=true
        echo [INFO] 找到上级目录的 Godot 编辑器
    ) else if exist "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe" (
        set GODOT_PATH="..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe"
        set GODOT_FOUND=true
        echo [INFO] 找到上级目录的 Godot 编辑器（控制台版本）
    )
)

REM 检查系统 PATH 中的 Godot
if not %GODOT_FOUND%==true (
    where godot >nul 2>&1
    if %ERRORLEVEL%==0 (
        set GODOT_PATH=godot
        set GODOT_FOUND=true
        echo [INFO] 找到系统 PATH 中的 Godot
    )
)

if not %GODOT_FOUND%==true (
    echo [ERROR] 未找到 Godot 可执行文件！
    echo.
    echo [HELP] 请确保以下任一条件满足：
    echo        - 当前目录或上级目录存在 Godot 构建
    echo        - 系统 PATH 中包含 Godot 可执行文件
    echo        - 手动指定 Godot 路径
    echo.
    echo [HELP] 或者先构建 Godot：
    echo        - 在 godot_source 目录中运行 build.bat
    echo.
    pause
    exit /b 1
)

echo [INFO] 使用 Godot: %GODOT_PATH%
echo.

REM 打开 Godot 编辑器并加载项目
echo [INFO] 正在打开 Godot 编辑器并加载 Flappy Bird 项目...
start "" %GODOT_PATH% --editor --path "%CD%"
echo [SUCCESS] Godot 编辑器已打开并加载项目！

echo.
echo ========================================
echo [TIPS] 使用提示：
echo [TIPS] - 如果编辑器没有打开，请检查 Godot 路径设置
echo [TIPS] - 首次打开可能需要较长时间
echo [TIPS] - 可以在命令行中运行以查看详细输出
echo [TIPS] - 使用 --editor --path 参数打开编辑器并加载项目
echo ========================================
echo.
pause
