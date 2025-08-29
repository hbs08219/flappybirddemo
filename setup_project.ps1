# Flappy Bird Project Environment Setup Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      Flappy Bird Project Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[INFO] Starting project environment setup..." -ForegroundColor Green
Write-Host ""

# Check if we're in the correct project directory
if (-not (Test-Path "project.godot")) {
    Write-Host "[ERROR] Project file project.godot not found!" -ForegroundColor Red
    Write-Host "[ERROR] Please ensure you are running this script from the correct project directory." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[INFO] Project validation successful" -ForegroundColor Green
Write-Host "[INFO] Project path: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Check if addons directory exists
if (-not (Test-Path "addons")) {
    Write-Host "[INFO] Creating addons directory..." -ForegroundColor Yellow
    try {
        New-Item -ItemType Directory -Path "addons" -Force | Out-Null
        Write-Host "[SUCCESS] addons directory created" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to create addons directory: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "[INFO] addons directory already exists" -ForegroundColor Green
}

Write-Host ""

# Check if Godot-MCP project exists
$mcpPath = "D:\Godot\Godot-MCP\addons\godot_mcp"
if (-not (Test-Path $mcpPath)) {
    Write-Host "[ERROR] Godot-MCP project not found!" -ForegroundColor Red
    Write-Host "[ERROR] Please ensure the following path exists: $mcpPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "[HELP] Please download or clone Godot-MCP project to D:\Godot\ directory" -ForegroundColor Yellow
    Write-Host "[HELP] Or modify the mcpPath variable in this script to point to the correct path" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[INFO] Found Godot-MCP project: $mcpPath" -ForegroundColor Green
Write-Host ""

# Check if soft reference already exists
if (Test-Path "addons\godot_mcp") {
    Write-Host "[INFO] Detected existing godot_mcp directory" -ForegroundColor Yellow
    Write-Host "[INFO] Checking if it's a soft reference..." -ForegroundColor Yellow
    
    try {
        $item = Get-Item "addons\godot_mcp"
        if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
            Write-Host "[INFO] Soft reference already exists, updating..." -ForegroundColor Yellow
            Remove-Item "addons\godot_mcp" -Force
            Write-Host "[INFO] Old soft reference removed" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Detected regular directory, backing up..." -ForegroundColor Yellow
            if (Test-Path "addons\godot_mcp_backup") {
                Remove-Item "addons\godot_mcp_backup" -Recurse -Force
            }
            Move-Item "addons\godot_mcp" "addons\godot_mcp_backup"
            Write-Host "[INFO] Original directory backed up as godot_mcp_backup" -ForegroundColor Green
        }
    } catch {
        Write-Host "[ERROR] Error processing existing directory: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host ""
}

# Create soft reference
Write-Host "[INFO] Creating soft reference..." -ForegroundColor Yellow
Write-Host "[INFO] Source directory: $mcpPath" -ForegroundColor Gray
Write-Host "[INFO] Target link: addons\godot_mcp" -ForegroundColor Gray
Write-Host ""

try {
    # Try to create Junction first
    New-Item -ItemType Junction -Path "addons\godot_mcp" -Target $mcpPath -Force | Out-Null
    Write-Host "[SUCCESS] Soft reference created successfully!" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Junction creation failed, trying Symbolic Link..." -ForegroundColor Yellow
    
    try {
        # Try to create Symbolic Link as fallback
        New-Item -ItemType SymbolicLink -Path "addons\godot_mcp" -Target $mcpPath -Force | Out-Null
        Write-Host "[SUCCESS] Symbolic Link created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Soft reference creation failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "[HELP] Possible solutions:" -ForegroundColor Yellow
        Write-Host "[HELP] 1. Run this script as Administrator" -ForegroundColor Gray
        Write-Host "[HELP] 2. Create soft reference manually" -ForegroundColor Gray
        Write-Host "[HELP] 3. Check if target path exists" -ForegroundColor Gray
        Write-Host ""
        Write-Host "[ERROR] Detailed error: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""

# Verify soft reference
if (Test-Path "addons\godot_mcp") {
    Write-Host "[INFO] Verifying soft reference..." -ForegroundColor Yellow
    try {
        $item = Get-Item "addons\godot_mcp"
        Write-Host "[SUCCESS] Soft reference verification successful!" -ForegroundColor Green
        Write-Host "[INFO] Type: $($item.LinkType)" -ForegroundColor Cyan
        Write-Host "[INFO] Target: $($item.Target)" -ForegroundColor Cyan
    } catch {
        Write-Host "[ERROR] Soft reference verification failed!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "[ERROR] Soft reference verification failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Check critical files
Write-Host "[INFO] Checking critical files..." -ForegroundColor Yellow
$missingFiles = 0

$requiredFiles = @(
    "addons\godot_mcp\plugin.cfg",
    "addons\godot_mcp\mcp_server.gd",
    "addons\godot_mcp\command_handler.gd"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "[SUCCESS] ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] ✗ $file" -ForegroundColor Red
        $missingFiles++
    }
}

Write-Host ""

if ($missingFiles -eq 0) {
    Write-Host "[SUCCESS] All critical files check passed" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Found $missingFiles missing files" -ForegroundColor Yellow
}

Write-Host ""

# Check startup script
Write-Host "[INFO] Checking startup script..." -ForegroundColor Yellow
if (Test-Path "run_flappybird.bat") {
    Write-Host "[SUCCESS] Startup script exists" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Startup script not found, please ensure run_flappybird.bat is created" -ForegroundColor Yellow
}

Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] Project environment setup completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Next steps:" -ForegroundColor White
Write-Host "[INFO] 1. Run run_flappybird.bat to start the project" -ForegroundColor Gray
Write-Host "[INFO] 2. Enable MCP plugin in Godot editor" -ForegroundColor Gray
Write-Host "[INFO] 3. Start developing Flappy Bird game" -ForegroundColor Gray
Write-Host ""
Write-Host "[TIPS] Soft reference created, Godot-MCP modifications will auto-sync" -ForegroundColor Cyan
Write-Host "[TIPS] To reset, delete addons\godot_mcp directory and run this script again" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
