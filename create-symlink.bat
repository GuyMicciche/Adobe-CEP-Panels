@echo off

REM Get the parent directory name (project folder name)
for %%I in ("%~dp0.") do set "PROJECT_NAME=%%~nxI"

set "DIST_PATH=%~dp0dist\cep"
set "CEP_PATH=%USERPROFILE%\AppData\Roaming\Adobe\CEP\extensions\%PROJECT_NAME%"

echo Creating symlink for %PROJECT_NAME%...

if exist "%CEP_PATH%" (
    echo Removing existing symlink...
    rmdir "%CEP_PATH%"
)

mklink /D "%CEP_PATH%" "%DIST_PATH%"

if %errorlevel% == 0 (
    echo ✅ Adobe CEP symlink created successfully!
    echo From: %DIST_PATH%
    echo To: %CEP_PATH%
) else (
    echo ⚠️  Failed to create symlink. Run as Administrator.
    echo Manual command: mklink /D "%CEP_PATH%" "%DIST_PATH%"
)

pause
