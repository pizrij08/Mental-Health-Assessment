@echo off
echo Starting Flutter app on Chrome with fixed port 8080...
echo.
echo Checking if port 8080 is available...
netstat -ano | findstr :8080 >nul
if %errorlevel% == 0 (
    echo WARNING: Port 8080 may be in use. Please check and close the application using it.
    echo.
)
echo.
flutter run -d chrome --web-port=8080 --web-hostname=127.0.0.1
pause
