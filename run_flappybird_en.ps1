# Flappy Bird Project Launcher
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      Flappy Bird Project Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if project file exists
if (-not (Test-Path "project.godot")) {
    Write-Host "[ERROR] Project file project.godot not found!" -ForegroundColor Red
    Write-Host "[ERROR] Please ensure you are running this script from the correct project directory." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[INFO] Found Flappy Bird project file" -ForegroundColor Green
Write-Host "[INFO] Project path: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Check for Godot executable
$godotPath = ""
$godotFound = $false

# Check current directory's bin folder
if (Test-Path "bin\godot.windows.editor.dev.x86_64.exe") {
    $godotPath = "bin\godot.windows.editor.dev.x86_64.exe"
    $godotFound = $true
    Write-Host "[INFO] Found local Godot editor" -ForegroundColor Green
} elseif (Test-Path "bin\godot.windows.editor.dev.x86_64.console.exe") {
    $godotPath = "bin\godot.windows.editor.dev.x86_64.console.exe"
    $godotFound = $true
    Write-Host "[INFO] Found local Godot editor (console version)" -ForegroundColor Green
}

# Check parent directory's godot_source/bin folder
if (-not $godotFound) {
    if (Test-Path "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe") {
        $godotPath = "..\godot_source\bin\godot.windows.editor.dev.x86_64.exe"
        $godotFound = $true
        Write-Host "[INFO] Found Godot editor in parent directory" -ForegroundColor Green
    } elseif (Test-Path "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe") {
        $godotPath = "..\godot_source\bin\godot.windows.editor.dev.x86_64.console.exe"
        $godotFound = $true
        Write-Host "[INFO] Found Godot editor (console version) in parent directory" -ForegroundColor Green
    }
}

# Check system PATH for Godot
if (-not $godotFound) {
    try {
        $null = Get-Command godot -ErrorAction Stop
        $godotPath = "godot"
        $godotFound = $true
        Write-Host "[INFO] Found Godot in system PATH" -ForegroundColor Green
    } catch {
        # Godot not in PATH
    }
}

if (-not $godotFound) {
    Write-Host "[ERROR] Godot executable not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "[HELP] Please ensure one of the following conditions is met:" -ForegroundColor Yellow
    Write-Host "  - Godot build exists in current or parent directory" -ForegroundColor Gray
    Write-Host "  - Godot executable is in system PATH" -ForegroundColor Gray
    Write-Host "  - Manually specify Godot path" -ForegroundColor Gray
    Write-Host ""
    Write-Host "[HELP] Or build Godot first:" -ForegroundColor Yellow
    Write-Host "  - Run build.bat in godot_source directory" -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[INFO] Using Godot: $godotPath" -ForegroundColor Cyan
Write-Host ""

# Display launch options
Write-Host "Please select launch method:" -ForegroundColor White
Write-Host "1. Open project directly (recommended)" -ForegroundColor Gray
Write-Host "2. Open editor only" -ForegroundColor Gray
Write-Host "3. Open project and run" -ForegroundColor Gray
Write-Host "4. Exit" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "[INFO] Opening Flappy Bird project..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)" -ErrorAction Stop
            Write-Host "[SUCCESS] Project opened!" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Launch failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "2" {
        Write-Host "[INFO] Opening Godot editor..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ErrorAction Stop
            Write-Host "[SUCCESS] Editor opened!" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Launch failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "3" {
        Write-Host "[INFO] Opening project and running..." -ForegroundColor Yellow
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)", "--main-pack", "$(Get-Location)\MainScene.tscn" -ErrorAction Stop
            Write-Host "[SUCCESS] Project opened and running!" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Launch failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    "4" {
        Write-Host "[INFO] Exiting launcher" -ForegroundColor Blue
        exit 0
    }
    default {
        Write-Host "[ERROR] Invalid choice, using default method to open project" -ForegroundColor Red
        try {
            Start-Process -FilePath $godotPath -ArgumentList "--path", "$(Get-Location)" -ErrorAction Stop
            Write-Host "[SUCCESS] Project opened!" -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Launch failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[TIPS] Usage Tips:" -ForegroundColor Yellow
Write-Host "[TIPS] - If project doesn't open, check Godot path settings" -ForegroundColor Gray
Write-Host "[TIPS] - First launch may take longer time" -ForegroundColor Gray
Write-Host "[TIPS] - Run in command line to see detailed output" -ForegroundColor Gray
Write-Host "[TIPS] - Use --path parameter to specify project path" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
