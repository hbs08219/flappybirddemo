@echo off
chcp 65001 >nul
echo ========================================
echo       Flappy Bird 项目环境设置
echo ========================================
echo.

echo [INFO] 开始设置项目环境...
echo.

REM 检查是否在正确的项目目录中
if not exist "project.godot" (
    echo [ERROR] 未找到项目文件 project.godot！
    echo [ERROR] 请确保在正确的项目目录中运行此脚本。
    echo.
    pause
    exit /b 1
)

echo [INFO] 项目验证成功
echo [INFO] 项目路径: %CD%
echo.

REM 检查 addons 目录是否存在
if not exist "addons" (
    echo [INFO] 创建 addons 目录...
    mkdir addons
    echo [SUCCESS] addons 目录已创建
) else (
    echo [INFO] addons 目录已存在
)

echo.

REM 检查 Godot-MCP 项目是否存在
set MCP_PATH="D:\Godot\Godot-MCP\addons\godot_mcp"
if not exist %MCP_PATH% (
    echo [ERROR] 未找到 Godot-MCP 项目！
    echo [ERROR] 请确保以下路径存在：%MCP_PATH%
    echo.
    echo [HELP] 请先克隆或下载 Godot-MCP 项目到 D:\Godot\ 目录
    echo [HELP] 或者修改此脚本中的 MCP_PATH 变量指向正确路径
    echo.
    pause
    exit /b 1
)

echo [INFO] 找到 Godot-MCP 项目: %MCP_PATH%
echo.

REM 检查是否已经存在软引用
if exist "addons\godot_mcp" (
    echo [INFO] 检测到已存在的 godot_mcp 目录
    echo [INFO] 正在检查是否为软引用...
    
    REM 检查是否为 junction 或 symbolic link
    dir "addons\godot_mcp" | findstr /i "junction" >nul
    if %ERRORLEVEL%==0 (
        echo [INFO] 软引用已存在，正在更新...
        rmdir "addons\godot_mcp"
        echo [INFO] 旧软引用已移除
    ) else (
        echo [WARNING] 检测到普通目录，正在备份...
        if exist "addons\godot_mcp_backup" (
            rmdir /s /q "addons\godot_mcp_backup"
        )
        move "addons\godot_mcp" "addons\godot_mcp_backup"
        echo [INFO] 原目录已备份为 godot_mcp_backup
    )
    echo.
)

REM 创建软引用
echo [INFO] 正在创建软引用...
echo [INFO] 源目录: %MCP_PATH%
echo [INFO] 目标链接: addons\godot_mcp
echo.

REM 尝试使用 PowerShell 创建 junction
powershell -Command "New-Item -ItemType Junction -Path 'addons\godot_mcp' -Target '%MCP_PATH%' -Force" >nul 2>&1

if %ERRORLEVEL%==0 (
    echo [SUCCESS] 软引用创建成功！
) else (
    echo [ERROR] PowerShell 创建软引用失败，尝试使用 mklink...
    
    REM 尝试使用 mklink 创建目录符号链接
    mklink /D "addons\godot_mcp" %MCP_PATH% >nul 2>&1
    
    if %ERRORLEVEL%==0 (
        echo [SUCCESS] 使用 mklink 创建软引用成功！
    ) else (
        echo [ERROR] 软引用创建失败！
        echo.
        echo [HELP] 可能的解决方案：
        echo [HELP] 1. 以管理员身份运行此脚本
        echo [HELP] 2. 手动创建软引用：mklink /D addons\godot_mcp %MCP_PATH%
        echo [HELP] 3. 使用 PowerShell 管理员权限运行
        echo.
        pause
        exit /b 1
    )
)

echo.

REM 验证软引用
if exist "addons\godot_mcp" (
    echo [INFO] 验证软引用...
    dir "addons\godot_mcp" | findstr /i "junction" >nul
    if %ERRORLEVEL%==0 (
        echo [SUCCESS] 软引用验证成功！
        echo [INFO] 类型: Junction (目录连接点)
    ) else (
        echo [SUCCESS] 软引用验证成功！
        echo [INFO] 类型: Symbolic Link (符号链接)
    )
) else (
    echo [ERROR] 软引用验证失败！
    pause
    exit /b 1
)

echo.

REM 检查关键文件
echo [INFO] 检查关键文件...
set MISSING_FILES=0

if not exist "addons\godot_mcp\plugin.cfg" (
    echo [WARNING] 缺少 plugin.cfg 文件
    set /a MISSING_FILES+=1
)

if not exist "addons\godot_mcp\mcp_server.gd" (
    echo [WARNING] 缺少 mcp_server.gd 文件
    set /a MISSING_FILES+=1
)

if not exist "addons\godot_mcp\command_handler.gd" (
    echo [WARNING] 缺少 command_handler.gd 文件
    set /a MISSING_FILES+=1
)

if %MISSING_FILES%==0 (
    echo [SUCCESS] 所有关键文件检查通过
) else (
    echo [WARNING] 发现 %MISSING_FILES% 个文件缺失
)

echo.

REM 创建启动脚本
echo [INFO] 检查启动脚本...
if not exist "run_flappybird.bat" (
    echo [WARNING] 未找到启动脚本，请确保已创建 run_flappybird.bat
) else (
    echo [SUCCESS] 启动脚本已存在
)

echo.

echo ========================================
echo [SUCCESS] 项目环境设置完成！
echo ========================================
echo.
echo [INFO] 下一步操作：
echo [INFO] 1. 运行 run_flappybird.bat 启动项目
echo [INFO] 2. 在 Godot 编辑器中启用 MCP 插件
echo [INFO] 3. 开始开发 Flappy Bird 游戏
echo.
echo [TIPS] 软引用已创建，Godot-MCP 的修改会自动同步
echo [TIPS] 如需重新设置，请删除 addons\godot_mcp 目录后重新运行此脚本
echo.
pause
