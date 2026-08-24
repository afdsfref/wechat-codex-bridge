$ErrorActionPreference = 'SilentlyContinue'

$bridge = 'C:\Users\Administrator\Documents\Codex\wechat-codex-bridge'
$storage = Join-Path $env:USERPROFILE '.wechat-acp\instances\codex-main'
$pidFile = Join-Path $storage 'daemon.pid'

$alive = $false
if (Test-Path $pidFile) {
    $rawPid = (Get-Content $pidFile -Raw | Out-String).Trim()
    if ($rawPid -match '^\d+$') {
        $alive = [bool](Get-Process -Id ([int]$rawPid) -ErrorAction SilentlyContinue)
    }
}

if (-not $alive) {
    Start-Process -FilePath (Join-Path $bridge 'start-wechat-codex.cmd') -WindowStyle Hidden
    $log = Join-Path $storage 'watchdog.log'
    Add-Content -Path $log -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' bridge restarted by watchdog')
}
