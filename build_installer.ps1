$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$windowsBuildScript = Join-Path $scriptDir 'packaging\windows\build.ps1'

if (-not (Test-Path -LiteralPath $windowsBuildScript)) {
    throw "Windows build script not found: $windowsBuildScript"
}

& $windowsBuildScript
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
