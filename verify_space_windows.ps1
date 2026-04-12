$SPACE_URL = "https://Prakya-Queue-Waiting-Time-Optimizer-V3.hf.space"
try {
    $root = Invoke-RestMethod -Uri "$SPACE_URL/" -Method GET
    Write-Host "Root OK: $($root | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Space not responding yet. Wait and retry." -ForegroundColor Red
    exit 1
}
try {
    $reset = Invoke-RestMethod -Uri "$SPACE_URL/reset" -Method POST -ContentType "application/json" -Body '{"session_id":"test-123"}'
    Write-Host "Reset OK: $($reset | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "FAIL: Reset endpoint not responding." -ForegroundColor Red
    exit 1
}
Write-Host "SPACE IS LIVE. Safe to resubmit." -ForegroundColor Green
