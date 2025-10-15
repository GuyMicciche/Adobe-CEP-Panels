@echo off
setlocal enabledelayedexpansion
echo ===============================================
echo   Setting up CEP Development Environment
echo ===============================================
echo.

:: Get solution name from user
set /p PROJECT_NAME="Enter your project name (default: app): "
if "%PROJECT_NAME%"=="" set PROJECT_NAME=app

:: Get project name from user
set /p PANEL_NAME="Enter your CEP panel name (default: Hello World): "
if "%PANEL_NAME%"=="" set PANEL_NAME=Hello World

:: Get project ID from user
set /p PROJECT_ID="Enter your unique ID (default: com.org.helloworld): "
if "%PROJECT_ID%"=="" set PROJECT_ID=com.org.helloworld

echo.
echo Creating CEP development environment...
echo Project: %PROJECT_NAME%
echo Panel: %PANEL_NAME%
echo ID: %PROJECT_ID%
echo Environment: %ENV_NAME%
echo.

:: Check if nvm command exists
nvm version >nul 2>&1
if errorlevel 1 (
    echo nvm is not installed or not in PATH
    echo Please install nvm from: https://github.com/coreybutler/nvm-windows
    echo Or continue with your current Node.js installation
    pause
) else (
    echo nvm found! Current nvm version:
    nvm version
    echo.
    
    REM Change Node version to 22.20.0
    echo Switching to Node.js version 22.20.0...
    nvm use 22.20.0
    
    if errorlevel 1 (
        echo Node.js 22.20.0 is not installed
        echo Installing Node.js 22.20.0...
        nvm install 22.20.0
        if errorlevel 1 (
            echo ERROR: Failed to install Node.js 22.20.0
            pause
        ) else (
            echo Successfully installed Node.js 22.20.0
            echo Switching to Node.js 22.20.0...
            nvm use 22.20.0
        )
    ) else (
        echo Successfully switched to Node.js 22.20.0
    )
    
    echo Current Node.js version:
    node --version
)

:: Update npm to latest version
echo [1/3] Updating npm...
call npm -g install npm@latest
if errorlevel 1 (
    echo WARNING: Failed to update npm, continuing with existing version...
)

:: Create the CEP project
echo [2/3] Creating CEP project...
call npx create-bolt-cep --displayName "%PANEL_NAME%" --id "%PROJECT_ID%" "%PROJECT_NAME%"
if errorlevel 1 (
    echo ERROR: Failed to create CEP project
    pause
    exit /b 1
)

:: Navigate to project directory
cd "%PROJECT_NAME%"
if errorlevel 1 (
    echo ERROR: Failed to navigate to app directory
    pause
    exit /b 1
)

:: Build and start dev
echo [3/3] Building project and starting development server...
call npm run build
if errorlevel 1 (
    echo ERROR: Failed to build project
    pause
    exit /b 1
)
call npm run dev
if errorlevel 1 (
    echo ERROR: Failed to start development server...
    pause
    exit /b 1
)