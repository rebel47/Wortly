param([switch]$ReleaseContent)
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Split-Path $PSScriptRoot -Parent)
python tool/validate_content.py
if ($LASTEXITCODE) { exit $LASTEXITCODE }
python -m unittest discover -s tool -p test_validator.py
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$PSScriptRoot/flutter.ps1" pub get
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$PSScriptRoot/dart.ps1" run build_runner build
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$PSScriptRoot/dart.ps1" format --output=none --set-exit-if-changed lib test integration_test
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$PSScriptRoot/flutter.ps1" analyze
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& "$PSScriptRoot/flutter.ps1" test
if ($LASTEXITCODE) { exit $LASTEXITCODE }
if ($ReleaseContent) {
    python tool/validate_content.py --release
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}
