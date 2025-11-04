$oldPath = "C:\BOWEP\"
$newPath = "E:\Other Games\Microsoft Entertainment Pack\"
$shortcuts = Get-ChildItem "C:\Users\Dan\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Microsoft Entertainment Pack\" -Filter *.lnk

foreach ($shortcut in $shortcuts) {
    $shell = New-Object -ComObject WScript.Shell
    $sc = $shell.CreateShortcut($shortcut.FullName)

    $updated = $false

    if ($sc.TargetPath -like "$oldPath*") {
        $sc.TargetPath = $sc.TargetPath -replace [regex]::Escape($oldPath), $newPath
        $updated = $true
    }

    if ($sc.WorkingDirectory -like "$oldPath*") {
        $sc.WorkingDirectory = $sc.WorkingDirectory -replace [regex]::Escape($oldPath), $newPath
        $updated = $true
    } else {
        $sc.WorkingDirectory = $newPath
        $updated = $true
    }

    if ($sc.IconLocation -like "$oldPath*") {
        $sc.IconLocation = $sc.IconLocation -replace [regex]::Escape($oldPath), $newPath
        $updated = $true
    }

    if ($updated) {
        $sc.Save()
        Write-Host "Updated: $($shortcut.Name)"
    }
}
