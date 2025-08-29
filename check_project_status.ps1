# FlappyBird项目状态检测脚本
# 检查项目是否已经在运行

Write-Host "🔍 检测FlappyBird项目运行状态..." -ForegroundColor Cyan

# 方法1：检查Godot编辑器进程
$godotProcesses = Get-Process | Where-Object {$_.ProcessName -like "*godot*"}

if ($godotProcesses) {
    Write-Host "✅ 发现Godot编辑器进程：" -ForegroundColor Green
    foreach ($process in $godotProcesses) {
        Write-Host "   - 进程ID: $($process.Id), 名称: $($process.ProcessName)" -ForegroundColor Yellow
    }
    
    # 方法2：检查MCP服务器端口
    $mcpPort = netstat -ano | findstr :9080
    if ($mcpPort) {
        Write-Host "✅ MCP服务器正在运行 (端口9080)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  MCP服务器未运行" -ForegroundColor Yellow
    }
    
    # 方法3：检查项目文件是否被占用
    $projectFile = "D:\Godot\flappybirddemo\project.godot"
    try {
        $file = [System.IO.File]::Open($projectFile, 'Open', 'Read', 'None')
        $file.Close()
        Write-Host "✅ 项目文件未被锁定" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  项目文件可能被锁定" -ForegroundColor Yellow
    }
    
    Write-Host "`n🎮 FlappyBird项目已经在运行中！" -ForegroundColor Green
    Write-Host "   无需重复启动。" -ForegroundColor Green
    
    # 返回退出码1表示项目已运行
    exit 1
} else {
    Write-Host "❌ 未发现运行中的Godot编辑器进程" -ForegroundColor Red
    Write-Host "   项目未运行，可以启动。" -ForegroundColor Yellow
    
    # 返回退出码0表示项目未运行
    exit 0
}
