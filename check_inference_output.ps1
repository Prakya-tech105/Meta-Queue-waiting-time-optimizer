$output = python inference.py 2>&1
$output | ForEach-Object { Write-Host $_ }
$endLines = $output | Where-Object { $_ -match "^\[END\]" }
$scoreLines = $output | Where-Object { $_ -match "^\[END\]" -and $_ -match "score" }
$badScores = $output | Where-Object { $_ -match "^\[END\]" -and $_ -match '"score": (0\.0|1\.0)' }
Write-Host "END lines: $($endLines.Count)"
Write-Host "Score lines: $($scoreLines.Count)"
if ($endLines.Count -lt 3) { Write-Host "FAIL: less than 3 END lines" -ForegroundColor Red; exit 1 }
if ($scoreLines.Count -lt 3) { Write-Host "FAIL: less than 3 score lines" -ForegroundColor Red; exit 1 }
if ($badScores.Count -gt 0) { Write-Host "FAIL: bad score found" -ForegroundColor Red; exit 1 }
Write-Host "PASS: inference.py output is valid" -ForegroundColor Green
