$inputFile = Read-Host "Enter the full path to the file to split"
$outputFolder = Read-Host "Enter the full path to the output folder"

$baseName = [System.IO.Path]::GetFileName($inputFile)
$chunkSize = 1073741824
$buffer = New-Object byte[] $chunkSize
$reader = [System.IO.File]::OpenRead($inputFile)
$i = 0

try {
    while (($bytesRead = $reader.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $outFile = Join-Path $outputFolder "$baseName.part$i"
        $writer = [System.IO.File]::OpenWrite($outFile)
        try {
            $writer.Write($buffer, 0, $bytesRead)
        } finally {
            $writer.Close()
        }
        Write-Host "Written part $i ($bytesRead bytes)"
        $i++
    }
} finally {
    $reader.Close()
}

Write-Host "Done. $i parts created."