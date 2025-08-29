# Flappy Bird 项目启动器
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      Flappy Bird 项目启动器" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查项目文件是否存在
if (-not (Test-Path "project.godot")) {
    Write-Host "[ERROR] 未找到项目文件 project.godot！" -ForegroundColor Red
    Write-Host "[ERROR] 请确保在正确的项目目录中运行此脚本。" -ForegroundColor Red
    Write-Host ""
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "[INFO] 找到 Flappy Bird 项目文件" -ForegroundColor Green
Write-Host "[INFO] 项目路径: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# 检查 Godot 可执行文件
$godotPath = ""
$godotFound = $false

# 检查当前目录的 bin 文件夹
if (Test-Path "bin\godot.windows.editor.dev.x86_64.exe") {
    $godotPath = "bin\godot.windows.editor.dev.x86_64.exe"
    $godotFound = $true
    Write-Host "[INFO] 找到本地 Godot 编辑器" -ForegroundColor Green
} elseif (Test-Path "bin\godot.windows.editor.dev.x86_64.console.exe") {
    $godotPath = "bin\godot.windows.editor.dev.x86_64.console.exe"
    $godotFound = $true
    Write-Host "[INFO] 找到本地 Godot 编辑器（控制台版本）" -ForegroundColor Green
}

# 检查上级目录的 godot_source/bin 文件夹
if (-not $godotFound) {
    if (Test-Path "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe") {
        $godotPath = "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe"
        $godotFound = $true
        Write-Host "[INFO] 找到上级目录的 Godot 编辑器" -ForegroundColor Green
    } elseif (Test-Path "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe") {
        $godotPath = "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe"
        $godotFound = $true
        Write-Host "[INFO] 找到上级目录的 Godot 编辑器（控制台版本）" -ForegroundColor Green
    }
}

# 检查系统 PATH 中的 Godot
if (-not $godotFound) {
    try {
        $null = Get-Command godot -ErrorAction Stop
        $godotPath = "godot"
        $godotFound = $true
        Write-Host "[INFO] 找到系统 PATH 中的 Godot" -ForegroundColor Green
    } catch {
        # Godot 不在 PATH 中
    }
}

if (-not $godotFound) {
    Write-Host "[ERROR] 未找到 Godot 可执行文件！" -ForegroundColor Red
    Write-Host ""
    Write-Host "[HELP] 请确保以下任一条件满足：" -ForegroundColor Yellow
    Write-Host "  - 当前目录或上级目录存在 Godot 构建" -ForegroundColor Gray
    Write-Host "  - 系统 PATH 中包含 Godot 可执行文件" -ForegroundColor Gray
    Write-Host "  - 手动指定 Godot 路径" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[HELP] 或者先构建 Godot：" -ForegroundColor Yellow
    Write-Host "  - 在 godot_source 目录中运行 build.bat" -ForegroundColor Gray
    Write-Host ""
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "[INFO] 使用 Godot: $godotPath" -ForegroundColor Cyan
Write-Host ""

# 显示启动选项
Write-Host "请选择启动方式：" -ForegroundColor White
Write-Host "1. 直接打开项目（推荐）" -ForegroundColor Gray
Write-Host "2. 打开编辑器" -ForegroundColor Gray
Write-Host "3. 打开项目并运行" -ForegroundColor Gray
Write-Host "4. 退出" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "请输入选择 (1-4)"

switch ($choice) {
    "1" {
        Write-Host "[INFO] 正在打开 Flappy Bird 项目..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)" -ErrorAction Stop
            Write-Host "[SUCCESS] 项目已打开！" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] 启动失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "2" {
        Write-Host "[INFO] 正在打开 Godot 编辑器..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ErrorAction Stop
            Write-Host "[SUCCESS] 编辑器已打开！" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] 启动失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "3" {
        Write-Host "[INFO] 正在打开项目并运行..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)", "--main-pack", "$(Get-Location)\MainScene.tscn" -ErrorAction Stop
            Write-Host "[SUCCESS] 项目已打开并运行！" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] 启动失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "4" {
        Write-Host "[INFO] 退出启动器" -ForegroundColor Blue
        exit 0
    }
    default {
        Write-Host "[ERROR] 无效选择，使用默认方式打开项目" -ForegroundColor Red
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)" -ErrorAction Stop
            Write-Host "[SUCCESS] 项目已打开！" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] 启动失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[TIPS] 使用提示：" -ForegroundColor Yellow
Write-Host "[TIPS] - 如果项目没有打开，请检查 Godot 路径设置" -ForegroundColor Gray
Write-Host "[TIPS] - 首次打开可能需要较长时间" -ForegroundColor Gray
Write-Host "[TIPS] - 可以在命令行中运行以查看详细输出" -ForegroundColor Gray
Write-Host "[TIPS] - 使用 --path 参数指定项目路径" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "按回车键退出"
