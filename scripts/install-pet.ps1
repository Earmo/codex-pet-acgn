[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [string]$PetId,

  [switch]$List,

  [string]$CodexHome = $env:CODEX_HOME,

  [string]$RawBase = $env:CODEX_PET_RAW_BASE
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RawBase)) {
  $RawBase = "https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main"
}

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
  $CodexHome = Join-Path $HOME ".codex"
}

function Get-Catalog {
  Invoke-RestMethod -Uri "$RawBase/pets.json"
}

function Write-Catalog {
  $catalog = Get-Catalog
  foreach ($pet in $catalog) {
    $version = if ($null -eq $pet.spriteVersionNumber) { 1 } else { $pet.spriteVersionNumber }
    "{0} - {1} (v{2})" -f $pet.id, $pet.displayName, $version
  }
}

if ($List) {
  Write-Catalog
  exit 0
}

if ([string]::IsNullOrWhiteSpace($PetId)) {
  Write-Host "用法: install-pet.ps1 <pet-id>"
  Write-Host "列出宠物: install-pet.ps1 -List"
  exit 1
}

if ($PetId -notmatch "^[a-z0-9]+(?:-[a-z0-9]+)*$") {
  throw "无效的宠物 ID: $PetId"
}

$catalogEntry = Get-Catalog | Where-Object { $_.id -eq $PetId } | Select-Object -First 1
if ($null -eq $catalogEntry) {
  throw "未找到宠物: $PetId。请先运行 install-pet.ps1 -List。"
}

$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ("codex-pet-{0}" -f [Guid]::NewGuid().ToString("N"))
$targetDir = Join-Path (Join-Path $CodexHome "pets") $PetId

try {
  New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

  foreach ($file in @("pet.json", "spritesheet.webp", "checksums.sha256")) {
    Invoke-WebRequest -UseBasicParsing `
      -Uri "$RawBase/pets/$PetId/$file" `
      -OutFile (Join-Path $tempRoot $file)
  }

  $expected = @{}
  foreach ($line in Get-Content (Join-Path $tempRoot "checksums.sha256")) {
    if ($line -match "^(?<hash>[0-9a-fA-F]{64})\s+\*?(?<file>.+)$") {
      $expected[$Matches.file.Trim()] = $Matches.hash.ToLowerInvariant()
    }
  }

  foreach ($file in @("pet.json", "spritesheet.webp")) {
    if (-not $expected.ContainsKey($file)) {
      throw "校验文件缺少条目: $file"
    }

    $actual = (Get-FileHash (Join-Path $tempRoot $file) -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne $expected[$file]) {
      throw "文件校验失败: $file"
    }
  }

  $pet = Get-Content -Raw (Join-Path $tempRoot "pet.json") | ConvertFrom-Json
  if ($pet.id -ne $PetId) {
    throw "pet.json 的 ID 与请求不一致: $($pet.id)"
  }

  New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
  Copy-Item (Join-Path $tempRoot "pet.json") $targetDir -Force
  Copy-Item (Join-Path $tempRoot "spritesheet.webp") $targetDir -Force
  Write-Host "已安装 $PetId 到 $targetDir"
}
finally {
  if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
  }
}
