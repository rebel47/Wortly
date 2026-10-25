# No advanced parameters: Flutter's -d must pass through unchanged, rather than
# being consumed as PowerShell's common -Debug switch.
$ErrorActionPreference = 'Stop'
if ($env:OS -eq 'Windows_NT' -and $env:JAVA_TOOL_OPTIONS -notmatch 'jdk.net.unixdomain.tmpdir') {
    # This host's Windows AF_UNIX connect fails with JBR/OpenJDK 21. An absent
    # socket directory makes Java's PipeImpl use its supported TCP fallback.
    $env:JAVA_TOOL_OPTIONS = "$env:JAVA_TOOL_OPTIONS -Djdk.net.unixdomain.tmpdir=C:/wortly-no-unix-pipes"
}
$taskSdk = $env:WORTLY_FLUTTER
if (-not $taskSdk) {
    $taskBundledSdk = Join-Path $env:USERPROFILE '.codex\tools\flutter-wortly'
    if (Test-Path -LiteralPath (Join-Path $taskBundledSdk 'bin\flutter.bat')) {
        $taskSdk = $taskBundledSdk
    }
}
if ($taskSdk) {
    & (Join-Path $taskSdk 'bin\flutter.bat') @args
} else {
    & flutter @args
}
exit $LASTEXITCODE
