param(
  [string]$Path = "."
)

$ErrorActionPreference = "Stop"

$blockedFilePatterns = @(
  "\.tfstate$",
  "\.tfstate\.",
  "\.tfplan$",
  "\.plan$",
  "\\\.terraform\\",
  "\\\.alzlib\\",
  "\.pem$",
  "\.pfx$",
  "\.p12$",
  "\.key$",
  "\.kubeconfig$"
)

$sensitiveContentPatterns = @(
  "client_secret\s*=",
  "ARM_CLIENT_SECRET",
  "access_key\s*=",
  "sas_token\s*=",
  "shared_access_key",
  "-----BEGIN (RSA |EC |OPENSSH |)PRIVATE KEY-----",
  "xox[baprs]-[A-Za-z0-9-]+",
  "gh[pousr]_[A-Za-z0-9_]{30,}",
  "eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}"
)

$allowedSampleGuids = @(
  "00000000-0000-0000-0000-000000000000",
  "11111111-1111-1111-1111-111111111111",
  "22222222-2222-2222-2222-222222222222",
  "33333333-3333-3333-3333-333333333333",
  "44444444-4444-4444-4444-444444444444",
  "55555555-5555-5555-5555-555555555555",
  # Microsoft built-in Azure role definition IDs used by the examples.
  "8e3af657-a8ff-443c-a75c-2fe8c4bcb635",
  "acdd72a7-3385-48ef-bd42-f606fba81ae7",
  "b24988ac-6180-42a0-ab88-20f7382dd24c"
)

$findings = New-Object System.Collections.Generic.List[string]

$files = Get-ChildItem -Path $Path -Recurse -File -Force |
  Where-Object {
    $_.FullName -notmatch "\\\.git\\" -and
    $_.FullName -notmatch "\\\.terraform\\" -and
    $_.FullName -notmatch "\\\.alzlib\\"
  }

foreach ($file in $files) {
  $relative = Resolve-Path -Path $file.FullName -Relative

  foreach ($pattern in $blockedFilePatterns) {
    if ($file.FullName -match $pattern) {
      $findings.Add("Blocked file pattern: $relative")
    }
  }

  if ($file.Length -gt 2MB) {
    continue
  }

  $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
  if ($null -eq $content) {
    continue
  }

  foreach ($pattern in $sensitiveContentPatterns) {
    if ($relative -notmatch "scripts\\Test-PublicRepoSafety\.ps1$" -and $content -match $pattern) {
      $findings.Add("Sensitive content pattern '$pattern': $relative")
    }
  }

  $guidMatches = [regex]::Matches($content, "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}")
  foreach ($match in $guidMatches) {
    if ($allowedSampleGuids -notcontains $match.Value.ToLowerInvariant()) {
      $findings.Add("Review GUID value '$($match.Value)' in $relative")
    }
  }
}

if ($findings.Count -gt 0) {
  Write-Host "Public repo safety scan found items to review:" -ForegroundColor Yellow
  $findings | Sort-Object -Unique | ForEach-Object { Write-Host "- $_" }
  exit 1
}

Write-Host "Public repo safety scan passed." -ForegroundColor Green
