param(
    [Parameter(Mandatory = $true)]
    [string]$ApiBaseUrl,

    [string]$SocketUrl = "",

    [string]$Msg91WidgetId = "366642727548323934353735",

    [Parameter(Mandatory = $true)]
    [string]$Msg91WidgetToken,

    [switch]$SkipAnalyze
)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$ApiBaseUrl = $ApiBaseUrl.TrimEnd("/")

Write-Host "Building MedCollab release APK"
Write-Host "  API_BASE_URL:       $ApiBaseUrl"
Write-Host "  MSG91_WIDGET_ID:    $Msg91WidgetId"
if ($SocketUrl) {
    Write-Host "  SOCKET_URL:         $SocketUrl"
}

if (-not $SkipAnalyze) {
    Write-Host "`n==> flutter analyze"
    flutter analyze
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

# Write JSON without BOM — PowerShell UTF8 encoding adds BOM and can break dart-define-from-file.
$defineFile = Join-Path $PSScriptRoot "dart-defines.release.json"
$jsonLines = @(
    "{",
    "  `"API_BASE_URL`": `"$ApiBaseUrl`",",
    "  `"ENABLE_API_LOGGING`": false,",
    "  `"MSG91_WIDGET_ID`": `"$Msg91WidgetId`",",
    "  `"MSG91_WIDGET_TOKEN`": `"$Msg91WidgetToken`""
)
if ($SocketUrl) {
    $jsonLines += "  ,`"SOCKET_URL`": `"$($SocketUrl.TrimEnd('/'))`""
}
$jsonLines += "}"
$json = $jsonLines -join "`n"
[System.IO.File]::WriteAllText($defineFile, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host "`n==> dart-defines.release.json"
Get-Content $defineFile

Write-Host "`n==> flutter build apk --release"
flutter build apk --release "--dart-define-from-file=scripts/dart-defines.release.json"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$apk = "build/app/outputs/flutter-apk/app-release.apk"
Write-Host "`nDone. APK: $apk"
Write-Host "Install: adb install -r $apk"
