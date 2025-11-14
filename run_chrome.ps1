Write-Host "Starting Flutter app on Chrome with fixed port 8080..." -ForegroundColor Green
Write-Host ""

# Check if port 8080 is in use
$portInUse = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "WARNING: Port 8080 may be in use. Please check and close the application using it." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Launching Flutter app..." -ForegroundColor Cyan
flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1



