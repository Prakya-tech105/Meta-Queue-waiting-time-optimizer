git remote remove space 2>$null
git remote add space https://huggingface.co/spaces/Prakya/Queue-Waiting-Time-Optimizer-V3
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
"cache_bust_$timestamp" | Out-File -FilePath ".huggingface_cache_bust" -Encoding utf8
git add -A
git commit -m "force-redeploy: $timestamp" --allow-empty
git push origin main --force
git push space main --force
Write-Host "DONE. Wait 4 minutes then run verify_space_windows.ps1" -ForegroundColor Green
