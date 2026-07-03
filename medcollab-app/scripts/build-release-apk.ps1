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

# Use dart-define-from-file so PowerShell does not strip `//` from https:// URLs.
$defineFile = Join-Path $PSScriptRoot "dart-defines.release.json"
$defines = @{
    API_BASE_URL         = $ApiBaseUrl
    ENABLE_API_LOGGING   = "false"
    MSG91_WIDGET_ID      = $Msg91WidgetId
    MSG91_WIDGET_TOKEN   = $Msg91WidgetToken
}
if ($SocketUrl) {
    $defines.SOCKET_URL = $SocketUrl.TrimEnd("/")
}
$defines | ConvertTo-Json | Set-Content -Path $defineFile -Encoding UTF8

Write-Host "`n==> flutter build apk --release"
flutter build apk --release "--dart-define-from-file=$defineFile"

$apk = "build/app/outputs/flutter-apk/app-release.apk"
Write-Host "`nDone. APK: $apk"
Write-Host "Install: adb install -r $apk"
