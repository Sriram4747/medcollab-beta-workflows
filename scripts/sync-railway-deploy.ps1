# Sync GitLab branch → GitHub master so Railway auto-deploys.
# Railway watches: https://github.com/mathiharan29/medcollab-beta (branch master)
#
# Usage (from repo root):
#   .\scripts\sync-railway-deploy.ps1
#   .\scripts\sync-railway-deploy.ps1 -Branch master

param(
    [string]$Branch = "design/clinical-design-system"
)

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
Set-Location $root

Write-Host "Syncing $Branch -> github/master (Railway deploy trigger)"
Write-Host ""

$ahead = git rev-list --count "github/master..$Branch" 2>$null
if ($LASTEXITCODE -ne 0) {
    git fetch github master
    $ahead = git rev-list --count "github/master..$Branch"
}

if ([int]$ahead -eq 0) {
    Write-Host "Already up to date — github/master matches $Branch."
    exit 0
}

Write-Host "Commits to push: $ahead"
git log --oneline "github/master..$Branch"
Write-Host ""

git push origin "HEAD:$Branch"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

git push github "${Branch}:master"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Done. Railway should redeploy from GitHub master in ~1-2 minutes."
Write-Host "Health: https://medcollab.up.railway.app/health"
