# Cisco MCP Scanner - one-command lab scan
# Run this script from:
# C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab

$ErrorActionPreference = "Stop"

$LabPath = "C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab"
$VenvPath = Join-Path $LabPath "cisco-mcp-scan"
$ActivateScript = Join-Path $VenvPath "Scripts\Activate.ps1"
$McpConfig = Join-Path $LabPath "mcp.json"
$ResultsFile = Join-Path $LabPath "cisco-mcp-results.json"

Write-Host ""
Write-Host "============================================" 
Write-Host " Cisco MCP Scanner - Vulnerable MCP Lab"
Write-Host "============================================"
Write-Host ""

# Move to the lab directory
Set-Location $LabPath

# Check the virtual environment
if (-not (Test-Path $ActivateScript)) {
    Write-Host "ERROR: Cisco virtual environment was not found:" -ForegroundColor Red
    Write-Host $VenvPath -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Create it first with:" -ForegroundColor Yellow
    Write-Host "uv venv cisco-mcp-scan --python 3.13"
    exit 1
}

# Check MCP configuration
if (-not (Test-Path $McpConfig)) {
    Write-Host "ERROR: mcp.json was not found:" -ForegroundColor Red
    Write-Host $McpConfig -ForegroundColor Yellow
    exit 1
}

# Activate the Cisco scanner environment
Write-Host "[1/3] Activating cisco-mcp-scan environment..." -ForegroundColor Cyan
. $ActivateScript

# Check that the scanner is available
if (-not (Get-Command mcp-scanner -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: mcp-scanner is not available in the cisco-mcp-scan environment." -ForegroundColor Red
    Write-Host "Install it once with:" -ForegroundColor Yellow
    Write-Host "uv pip install cisco-ai-mcp-scanner"
    exit 1
}

Write-Host "[2/3] Running Cisco Prompt Defense scan..." -ForegroundColor Cyan
Write-Host ""

# Save the raw output to a JSON file.
# PowerShell redirection is intentionally used because it worked reliably
# with the current scanner installation.
mcp-scanner --analyzers prompt_defense --raw config --config-path ".\mcp.json" > ".\cisco-mcp-results.json"

Write-Host ""
Write-Host "[3/3] Scan completed." -ForegroundColor Green
Write-Host ""

if (Test-Path $ResultsFile) {
    $SizeKB = [math]::Round((Get-Item $ResultsFile).Length / 1KB, 2)
    Write-Host "Raw results saved to:" -ForegroundColor Green
    Write-Host $ResultsFile
    Write-Host "File size: $SizeKB KB"
} else {
    Write-Host "WARNING: The scan completed, but the results file was not found." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "To review the JSON:" -ForegroundColor Cyan
Write-Host "notepad `"$ResultsFile`""
Write-Host ""
Write-Host "============================================"
Write-Host " Scan finished"
Write-Host "============================================"
