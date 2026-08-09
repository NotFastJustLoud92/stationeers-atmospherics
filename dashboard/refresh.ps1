# Regenerates dashboard/cragspire_dashboard.html from live server state + repo content.
# Run this, then publish dashboard/cragspire_dashboard.html as the Claude Artifact
# at the dashboard's existing URL. Self-contained -- safe to run from a fresh session.

$ErrorActionPreference = 'Stop'

$repoDir    = "C:\Users\Ryan\Documents\stationeers-atmospherics"
$dashDir    = "$repoDir\dashboard"
$scriptsSrc = "C:\Users\Ryan\Desktop\Stationeers IC10 Scripts"
$memDir     = "C:\Users\Ryan\.claude\projects\C--\memory"
$serverRoot = "C:\Stationeers Dedicated Server"
$logPath    = "$serverRoot\output_log.txt"

function B64File($path) {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    return [System.Convert]::ToBase64String($bytes)
}

function JsonStr($s) {
    return '"' + ($s -replace '\\', '\\\\' -replace '"', '\"') + '"'
}

# Strips anything that looks like a private LAN IP or a labeled password from memory
# text before it gets embedded in the dashboard. Targeted redaction first (keeps the
# file readable), then a blanket private-IP scan as a backstop in case the source
# memory file drifts later and reintroduces connection details in different wording.
function Redact-Sensitive($text) {
    $t = $text -replace '(?m)^-\s*Server password:.*$', '- Connection details (LAN IP, ports, password) are private -- see the local launcher config directly rather than this file.'
    $t = $t -replace '(?m)^-\s*LAN IP:.*$\r?\n?', ''
    $ipPattern = '\b(?:192\.168|10\.\d{1,3}|172\.(?:1[6-9]|2\d|3[01]))\.\d{1,3}\.\d{1,3}\b'
    if ($t -match $ipPattern) {
        Write-Warning "Redact-Sensitive: private IP pattern still present after targeted redaction -- stripping matching lines wholesale."
        $t = ($t -split "`n" | Where-Object { $_ -notmatch $ipPattern }) -join "`n"
    }
    return $t
}

# ---------- server process / uptime ----------
$proc = Get-Process -Name "rocketstation_DedicatedServer" -ErrorAction SilentlyContinue
if ($proc) {
    $pillClass  = "ok"
    $statusText = "ONLINE"
    $uptime     = (Get-Date) - $proc.StartTime
    $uptimeText = "Up {0}h {1}m -- booted {2}" -f [int]$uptime.TotalHours, $uptime.Minutes, $proc.StartTime.ToString("HH:mm:ss")
} else {
    $pillClass  = "critical"
    $statusText = "OFFLINE"
    $uptimeText = "Server process not running"
}

# ---------- currently connected players (from output_log.txt) ----------
$players = [ordered]@{}
if (Test-Path $logPath) {
    Get-Content $logPath | ForEach-Object {
        if ($_ -match '^(\d{2}:\d{2}:\d{2}):.*Client: (.+?) \((\d+)\)\. Connected\.') {
            $players[$Matches[2]] = $Matches[1]
        } elseif ($_ -match 'Client disconnected:.*\|\s*(\S+)\s+connectTime:') {
            $players.Remove($Matches[1])
        }
    }
}
$playerItems = @()
foreach ($name in $players.Keys) {
    $since = $players[$name].Substring(0, 5)
    $playerItems += ('{' + '"name":' + (JsonStr $name) + ',"since":' + (JsonStr $since) + '}')
}
$playersJson = '[' + ($playerItems -join ',') + ']'
$playersCount = $players.Count

# ---------- latest commit ----------
Push-Location $repoDir
try {
    $lastCommitHash = (git rev-parse --short HEAD 2>$null).Trim()
    $lastCommitMsg  = (git log -1 --pretty=%s 2>$null).Trim()
} finally {
    Pop-Location
}
if (-not $lastCommitHash) { $lastCommitHash = "unknown" }
if (-not $lastCommitMsg)  { $lastCommitMsg  = "unknown" }

# ---------- static content (re-read + re-encode every run so drift can't happen) ----------
$pidB64      = B64File "$repoDir\diagrams\pid.html"
$handoffB64  = B64File "$repoDir\diagrams\handoff-log.html"

$memServerRaw = Get-Content "$memDir\stationeers-dedicated-server.md" -Raw -Encoding UTF8
$memServerRedacted = Redact-Sensitive $memServerRaw
$memServerBytes = [System.Text.Encoding]::UTF8.GetBytes($memServerRedacted)
$memServerB64 = [System.Convert]::ToBase64String($memServerBytes)

$memAtmosB64     = B64File "$memDir\stationeers-ic10-atmospherics.md"
$memBatchB64     = B64File "$memDir\batch-scripting-gotchas.md"
$memLaunchpadB64 = B64File "$memDir\stationeers-launchpad-version-matching.md"

$scriptIntake             = B64File "$scriptsSrc\atmospherics_intake.txt"
$scriptCompression        = B64File "$scriptsSrc\atmospherics_compression.txt"
$scriptGassplit           = B64File "$scriptsSrc\atmospherics_gassplit.txt"
$scriptCo2supply          = B64File "$scriptsSrc\atmospherics_co2supply.txt"
$scriptIcecrusher         = B64File "$scriptsSrc\atmospherics_icecrusher.txt"
$scriptN2osupply          = B64File "$scriptsSrc\atmospherics_n2osupply.txt"
$scriptRegulation         = B64File "$scriptsSrc\atmospherics_regulation.txt"
$scriptRecaptureCo2       = B64File "$scriptsSrc\atmospherics_recapture_co2.txt"
$scriptRecapturePollutant = B64File "$scriptsSrc\atmospherics_recapture_pollutant.txt"
$scriptRecaptureMethaneh2 = B64File "$scriptsSrc\atmospherics_recapture_methaneh2.txt"
$scriptRecaptureO2        = B64File "$scriptsSrc\atmospherics_recapture_o2.txt"
$scriptRecaptureN2        = B64File "$scriptsSrc\atmospherics_recapture_n2.txt"
$scriptIntakeCompression  = B64File "$scriptsSrc\atmospherics_intake_compression.txt"

$ts = Get-Date -Format "yyyy-MM-dd HH:mm 'MST'"

# ---------- substitute ----------
$tpl = Get-Content "$dashDir\template.html" -Raw -Encoding UTF8

$tpl = $tpl.Replace("__SERVER_PILL_CLASS__", $pillClass)
$tpl = $tpl.Replace("__SERVER_STATUS_TEXT__", $statusText)
$tpl = $tpl.Replace("__UPTIME_TEXT__", $uptimeText)
$tpl = $tpl.Replace("__PLAYERS_COUNT__", "$playersCount")
$tpl = $tpl.Replace("__PLAYERS_JSON__", $playersJson)
$tpl = $tpl.Replace("__LAST_COMMIT_MSG__", $lastCommitMsg)
$tpl = $tpl.Replace("__LAST_COMMIT_HASH__", $lastCommitHash)
$tpl = $tpl.Replace("__PID_B64__", $pidB64)
$tpl = $tpl.Replace("__HANDOFF_B64__", $handoffB64)
$tpl = $tpl.Replace("__MEM_SERVER_B64__", $memServerB64)
$tpl = $tpl.Replace("__MEM_ATMOS_B64__", $memAtmosB64)
$tpl = $tpl.Replace("__MEM_BATCH_B64__", $memBatchB64)
$tpl = $tpl.Replace("__MEM_LAUNCHPAD_B64__", $memLaunchpadB64)
$tpl = $tpl.Replace("__SCRIPT_INTAKE_B64__", $scriptIntake)
$tpl = $tpl.Replace("__SCRIPT_COMPRESSION_B64__", $scriptCompression)
$tpl = $tpl.Replace("__SCRIPT_GASSPLIT_B64__", $scriptGassplit)
$tpl = $tpl.Replace("__SCRIPT_CO2SUPPLY_B64__", $scriptCo2supply)
$tpl = $tpl.Replace("__SCRIPT_ICECRUSHER_B64__", $scriptIcecrusher)
$tpl = $tpl.Replace("__SCRIPT_N2OSUPPLY_B64__", $scriptN2osupply)
$tpl = $tpl.Replace("__SCRIPT_REGULATION_B64__", $scriptRegulation)
$tpl = $tpl.Replace("__SCRIPT_RECAPTURE_CO2_B64__", $scriptRecaptureCo2)
$tpl = $tpl.Replace("__SCRIPT_RECAPTURE_POLLUTANT_B64__", $scriptRecapturePollutant)
$tpl = $tpl.Replace("__SCRIPT_RECAPTURE_METHANEH2_B64__", $scriptRecaptureMethaneh2)
$tpl = $tpl.Replace("__SCRIPT_RECAPTURE_O2_B64__", $scriptRecaptureO2)
$tpl = $tpl.Replace("__SCRIPT_RECAPTURE_N2_B64__", $scriptRecaptureN2)
$tpl = $tpl.Replace("__SCRIPT_INTAKE_COMPRESSION_B64__", $scriptIntakeCompression)
$tpl = $tpl.Replace("__REFRESH_TIMESTAMP__", $ts)

$outPath = "$dashDir\cragspire_dashboard.html"
[System.IO.File]::WriteAllText($outPath, $tpl, (New-Object System.Text.UTF8Encoding $false))

"Regenerated $outPath ($((Get-Item $outPath).Length) bytes) -- server $statusText, $playersCount player(s) online, latest commit $lastCommitHash"
