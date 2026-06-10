$repos = gh repo list blackletum --fork --limit 550 --json nameWithOwner | ConvertFrom-Json

$updated = @()
$skipped = @()
$diverged = @()
$archived = @()

foreach ($repo in $repos) {
    $name = $repo.nameWithOwner
    Write-Host "Syncing $name..."
    
    $result = gh repo sync $name 2>&1
    $resultStr = "$result"

    if ($resultStr -match "diverging changes") {
        $diverged += "https://github.com/$name"
    } elseif ($resultStr -match "403" -or $resultStr -match "archived") {
        $archived += "https://github.com/$name"
    } elseif ($resultStr -match "500" -or $resultStr -match "error" -or $resultStr -match "HTTP") {
        $skipped += "https://github.com/$name  ($resultStr)"
    } else {
        $updated += "https://github.com/$name"
    }
}

$total = $updated.Count + $diverged.Count + $archived.Count + $skipped.Count

$lines = @()
$lines += "=== SCAN SUMMARY ==="
$lines += "  Total repos scanned: $total"
$lines += "  Updated:  $($updated.Count)"
$lines += "  Diverged: $($diverged.Count)"
$lines += "  Archived: $($archived.Count)"
$lines += "  Errors:   $($skipped.Count)"
$lines += ""
$lines += "=== UPDATED ($($updated.Count)) ==="
$updated | ForEach-Object { $lines += "  + $_" }
$lines += ""
$lines += "=== DIVERGED - needs manual merge ($($diverged.Count)) ==="
$diverged | ForEach-Object { $lines += "  ~ $_" }
$lines += ""
$lines += "=== ARCHIVED - read only ($($archived.Count)) ==="
$archived | ForEach-Object { $lines += "  # $_" }
$lines += ""
$lines += "=== OTHER ERRORS ($($skipped.Count)) ==="
$skipped | ForEach-Object { $lines += "  ! $_" }

$outputFile = "sync-results.txt"
$lines | Out-File -FilePath $outputFile -Encoding utf8

Write-Host ""
Write-Host "Done! Scanned $total repos. Results saved to $outputFile"