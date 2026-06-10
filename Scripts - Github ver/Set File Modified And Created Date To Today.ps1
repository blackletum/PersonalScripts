$folder = 'C:\FOLDERNAME\'
$now = Get-Date

Get-ChildItem -LiteralPath $folder -Recurse -File | ForEach-Object {
    try {
        # Strip read-only first
        Set-ItemProperty -LiteralPath $_.FullName -Name IsReadOnly -Value $false
        # Then update both timestamps
        [System.IO.File]::SetCreationTime($_.FullName, $now)
        [System.IO.File]::SetLastWriteTime($_.FullName, $now)
    } catch {
        Write-Host "FAILED: $($_.FullName) - $($_.Exception.Message)"
    }
}

Write-Host "Done! Verifying..."

$today = $now.Date
$missed = Get-ChildItem -LiteralPath $folder -Recurse -File | Where-Object {
    $_.LastWriteTime.Date -ne $today
}

if ($missed) {
    Write-Host "Still not updated:"
    $missed | Select-Object FullName, CreationTime, LastWriteTime | Format-Table
} else {
    Write-Host "All files successfully updated!"
}