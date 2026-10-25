$ErrorActionPreference = 'Stop'
$taskSdk = $env:WORTLY_FLUTTER
if (-not $taskSdk) {
    $taskBundledSdk = Join-Path $env:USERPROFILE '.codex\tools\flutter-wortly'
    if (Test-Path -LiteralPath (Join-Path $taskBundledSdk 'bin\dart.bat')) {
        $taskSdk = $taskBundledSdk
    }
}
if ($taskSdk) {
    & (Join-Path $taskSdk 'bin\dart.bat') @args
} else {
    & dart @args
}
exit $LASTEXITCODE
