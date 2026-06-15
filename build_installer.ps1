$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$installerDir = Join-Path $root 'installer'
$scriptFile = Join-Path $installerDir 'EasyRob.iss'
$scriptContent = Get-Content -LiteralPath $scriptFile
$versionLine = $scriptContent | Where-Object { $_ -match '^#define MyAppVersion "(.+)"$' } | Select-Object -First 1
if (-not $versionLine) {
    throw "Could not read MyAppVersion from $scriptFile"
}

$version = [regex]::Match($versionLine, '^#define MyAppVersion "(.+)"$').Groups[1].Value
$outputFile = Join-Path $root "dist\EasyRob-Setup-$version.exe"

$requiredFiles = @(
    'EasyRob.iss',
    'locks\conda-explicit.txt',
    'locks\requirements.txt',
    'scripts\install_easyrob.ps1',
    'scripts\launch_easyrob.pyw',
    'scripts\uninstall_easyrob.ps1',
    'assets\Miniforge3-Windows-x86_64.exe',
    'assets\Robert_icon.ico',
    'source\env.yaml'
)

foreach ($file in $requiredFiles) {
    $path = Join-Path $installerDir $file
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required installer file is missing: $path"
    }
}

$isccCandidates = @(
    "$env:ProgramFiles\Inno Setup 7\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 7\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
)

$iscc = $isccCandidates |
    Where-Object { Test-Path -LiteralPath $_ } |
    Select-Object -First 1

if (-not $iscc) {
    throw 'Inno Setup 6 or 7 was not found. Install it before building EasyRob.'
}

Write-Host "Compiling EasyRob with: $iscc"
Push-Location $installerDir
try {
    & $iscc $scriptFile
    if ($LASTEXITCODE -ne 0) {
        throw "Inno Setup failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

if (-not (Test-Path -LiteralPath $outputFile)) {
    throw "Compilation finished but the installer was not found: $outputFile"
}

$sizeMb = [math]::Round((Get-Item -LiteralPath $outputFile).Length / 1MB, 2)
Write-Host "Installer created successfully:"
Write-Host "  $outputFile"
Write-Host "  Size: $sizeMb MB"
