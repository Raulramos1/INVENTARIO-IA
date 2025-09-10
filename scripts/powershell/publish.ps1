Param(
  [string]$RepoUrl = "https://github.com/Raulramos1/INVENTARIO-IA.git",
  [string]$Branch = "main",
  [string]$CommitMessage = "Initial commit: HA + Grocy stack",
  [switch]$Force
)

function Ensure-GitInstalled {
  try {
    git --version | Out-Null
  } catch {
    Write-Error "Git no está instalado o no está en PATH. Instálalo y reintenta."
    exit 1
  }
}

function Init-Or-Update-Repo {
  param([string]$repoUrl, [string]$branch, [switch]$force)

  if (-not (Test-Path ".git")) {
    git init
    git checkout -b $branch
    git remote add origin $repoUrl
  } else {
    if ($force) {
      Write-Host "Forzando 'git fetch' de origin..."
      git remote set-url origin $repoUrl
      git fetch origin
    }
    try {
      git rev-parse --verify $branch 2>$null | Out-Null
    } catch {
      git checkout -b $branch
    }
  }
}

function Commit-And-Push {
  param([string]$branch, [string]$message)

  git add .
  if (-not $message) { $message = "update" }
  git commit -m $message

  # Intenta push y crea la rama remota si no existe
  git push -u origin $branch
}

# --- main ---
Ensure-GitInstalled

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
# El script está en scripts/powershell; subimos dos niveles
Set-Location (Resolve-Path (Join-Path $repoRoot "..\.."))

Write-Host "Directorio del repo: $(Get-Location)"
Init-Or-Update-Repo -repoUrl $RepoUrl -branch $Branch -force:$Force
Commit-And-Push -branch $Branch -message $CommitMessage

Write-Host "✅ Publicado en $RepoUrl (rama $Branch). Si se solicita autenticación, usa tu cuenta de GitHub."
