# Cisco MCP Scanner - Interactive Lab Scan
# Run from:
# C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab

$ErrorActionPreference = "Stop"

$LabPath = "C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab"
$VenvPath = Join-Path $LabPath "cisco-mcp-scan"
$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
$McpConfig = Join-Path $LabPath "mcp.json"
$ResultsFile = Join-Path $LabPath "cisco-mcp-results.json"

# Move to lab directory
Set-Location $LabPath

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Cisco MCP Scanner - Vulnerable MCP Lab" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check virtual environment
if (-not (Test-Path $ActivateScript)) {
    Write-Host "ERROR: Cisco virtual environment was not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Expected location:" -ForegroundColor Yellow
    Write-Host $VenvPath
    Write-Host ""
    Write-Host "Create it with:" -ForegroundColor Yellow
    Write-Host "uv venv cisco-mcp-scan --python 3.13"
    exit 1
}

# Check MCP configuration
if (-not (Test-Path $McpConfig)) {
    Write-Host "ERROR: mcp.json was not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Expected location:" -ForegroundColor Yellow
    Write-Host $McpConfig
    exit 1
}

# Activate environment
Write-Host "[1/4] Activating cisco-mcp-scan environment..." -ForegroundColor Cyan
. $ActivateScript

Write-Host ""

# Check scanner
if (-not (Get-Command mcp-scanner -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: mcp-scanner is not available." -ForegroundColor Red
    Write-Host ""
    Write-Host "Install it with:" -ForegroundColor Yellow
    Write-Host "uv pip install cisco-ai-mcp-scanner"
    exit 1
}

# Show installed version
Write-Host "Installed Cisco MCP Scanner:" -ForegroundColor DarkCyan
uv pip show cisco-ai-mcp-scanner | Select-String "Name|Version"

Write-Host ""
Write-Host "============================================" -ForegroundColor White
Write-Host " Select Scan Option" -ForegroundColor White
Write-Host "============================================" -ForegroundColor White
Write-Host ""
Write-Host "  [1] Run normal scan" -ForegroundColor Green
Write-Host "      Use the currently installed scanner version"
Write-Host ""
Write-Host "  [2] Update scanner and run scan" -ForegroundColor Yellow
Write-Host "      Upgrade Cisco MCP Scanner first"
Write-Host "      Then run the scan"
Write-Host ""
Write-Host "  [3] Exit" -ForegroundColor Red
Write-Host ""

$Choice = Read-Host "Enter your choice (1, 2 or 3)"

Write-Host ""

switch ($Choice) {

    "1" {

        Write-Host "============================================" -ForegroundColor Green
        Write-Host " Normal Scan Selected" -ForegroundColor Green
        Write-Host "============================================" -ForegroundColor Green
        Write-Host ""

    }

    "2" {

        Write-Host "============================================" -ForegroundColor Yellow
        Write-Host " Updating Cisco MCP Scanner" -ForegroundColor Yellow
        Write-Host "============================================" -ForegroundColor Yellow
        Write-Host ""

        Write-Host "Updating package..." -ForegroundColor Cyan

        uv pip install --upgrade cisco-ai-mcp-scanner

        Write-Host ""
        Write-Host "Updated scanner version:" -ForegroundColor Green

        uv pip show cisco-ai-mcp-scanner | Select-String "Name|Version"

        Write-Host ""
        Write-Host "Update completed. Starting scan..." -ForegroundColor Green
        Write-Host ""
    }

    "3" {

        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0

    }

    default {

        Write-Host "Invalid option. Please select 1, 2 or 3." -ForegroundColor Red
        exit 1

    }
}

# Remove previous result if it exists
if (Test-Path $ResultsFile) {
    Remove-Item $ResultsFile -Force
}

Write-Host "[2/4] MCP configuration:" -ForegroundColor Cyan
Write-Host $McpConfig
Write-Host ""

Write-Host "[3/4] Running Cisco Prompt Defense scan..." -ForegroundColor Cyan
Write-Host ""

# Run scanner and save raw output
mcp-scanner `
    --analyzers prompt_defense `
    --raw `
    config `
    --config-path ".\mcp.json" `
    > ".\cisco-mcp-results.json"

Write-Host ""
Write-Host "[4/4] Scan completed." -ForegroundColor Green
Write-Host ""

# Verify results
if (Test-Path $ResultsFile) {

    $SizeKB = [math]::Round(
        (Get-Item $ResultsFile).Length / 1KB,
        2
    )

    Write-Host "============================================" -ForegroundColor Green
    Write-Host " Scan Results" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""

    Write-Host "Raw results saved to:" -ForegroundColor Cyan
    Write-Host $ResultsFile

    Write-Host ""
    Write-Host "File size: $SizeKB KB" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "To open the JSON report:" -ForegroundColor Cyan
    Write-Host "notepad `"$ResultsFile`"" -ForegroundColor White

    Write-Host ""
    Write-Host "To generate an HTML report, use the JSON file" -ForegroundColor Cyan
    Write-Host "with your approved AI tool and the JSON-to-HTML prompt." -ForegroundColor Cyan

}
else {

    Write-Host "WARNING: Scan completed but result file was not created." -ForegroundColor Yellow

}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Scan finished"
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
