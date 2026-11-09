# Script Tu Dong Dong Bo Toan Bo He Sinh Thai TuanAI-GovTech Tren May Tinh Moi
$ErrorActionPreference = "SilentlyContinue"
Write-Host "1. Kiem tra va cai dat Git & GitHub CLI..." -ForegroundColor Cyan
winget install --id GitHub.cli -e --source winget --accept-package-agreements --accept-source-agreements --silent

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.56.0.windows.4/MinGit-2.56.0.4-64-bit.zip"
    $destDir = "$env:LocalAppData\Programs\MinGit"
    $zipFile = "$env:TEMP\MinGit.zip"
    Invoke-WebRequest -Uri $gitUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $destDir -Force
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$destDir\cmd*") {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$destDir\cmd;C:\Program Files\GitHub CLI", "User")
    }
}
$env:Path += ";$env:LocalAppData\Programs\MinGit\cmd;C:\Program Files\GitHub CLI"

Write-Host "2. Cai dat toan bo 26 Skills, 4 Agents va Quy tac GEMINI.md..." -ForegroundColor Cyan
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.gemini\config\plugins\agent-skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.gemini\config\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.gemini\config\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.codex\skills" | Out-Null

Copy-Item -Path "$repoRoot\*" -Destination "$env:USERPROFILE\.gemini\config\plugins\agent-skills" -Recurse -Force
Copy-Item -Path "$repoRoot\skills\*" -Destination "$env:USERPROFILE\.gemini\config\skills" -Recurse -Force
Copy-Item -Path "$repoRoot\skills\*" -Destination "$env:USERPROFILE\.codex\skills" -Recurse -Force
Copy-Item -Path "$repoRoot\agents\*" -Destination "$env:USERPROFILE\.gemini\config\agents" -Recurse -Force
if (Test-Path "$repoRoot\rules\GEMINI.md") {
    Copy-Item -Path "$repoRoot\rules\GEMINI.md" -Destination "$env:USERPROFILE\.gemini\config\GEMINI.md" -Force
}

Write-Host "HOAN TAT DONG BO 100% TREN MAY TINH MOI!" -ForegroundColor Green
