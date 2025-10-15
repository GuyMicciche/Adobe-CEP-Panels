@echo off
setlocal enabledelayedexpansion
echo ===============================================
echo   Setting up CEP Development Environment
echo ===============================================
echo.

:: Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.10+ from python.org
    pause
    exit /b 1
)

:: Get solution name from user
set /p PROJECT_NAME="Enter your project name (default: app): "
if "%PROJECT_NAME%"=="" set PROJECT_NAME=app

:: Get project name from user
set /p PANEL_NAME="Enter your CEP panel name (default: Hello World): "
if "%PANEL_NAME%"=="" set PANEL_NAME=Hello World

:: Get project ID from user
set /p PROJECT_ID="Enter your unique ID (default: com.org.helloworld): "
if "%PROJECT_ID%"=="" set PROJECT_ID=com.org.helloworld

:: Get environment name
set /p ENV_NAME="Enter nodeenv name (default: cep-env): "
if "%ENV_NAME%"=="" set ENV_NAME=cep-env

echo.
echo Creating CEP development environment...
echo Project: %PROJECT_NAME%
echo ID: %PROJECT_ID%
echo Environment: %ENV_NAME%
echo.

:: Install nodeenv if not installed
echo [1/7] Installing nodeenv...
python -m pip install nodeenv
if errorlevel 1 (
    echo ERROR: Failed to install nodeenv
    pause
    exit /b 1
)

:: Create nodeenv with latest Node.js
echo [2/7] Creating nodeenv with Node.js...
python -m nodeenv --node=22.20.0 %ENV_NAME%
if errorlevel 1 (
    echo ERROR: Failed to create nodeenv
    pause
    exit /b 1
)

:: Activate the environment
echo [3/7] Activating nodeenv...
call %ENV_NAME%\Scripts\Activate
if errorlevel 1 (
    echo ERROR: Failed to activate nodeenv
    pause
    exit /b 1
)

:: Update npm to latest version
echo [4/7] Updating npm...
call npm install -g npm@latest
if errorlevel 1 (
    echo WARNING: Failed to update npm, continuing with existing version...
)

:: Install create-bolt-cep globally in the environment
echo [5/7] Installing create-bolt-cep...
call npm install -g create-bolt-cep
if errorlevel 1 (
    echo ERROR: Failed to install create-bolt-cep
    pause
    exit /b 1
)

:: Create the CEP project
echo [6/7] Creating CEP project...
call create-bolt-cep --displayName "%PANEL_NAME%" --id "%PROJECT_ID%" "%PROJECT_NAME%"
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
echo [7/7] Building project and starting development server...
call npm -g run build
if errorlevel 1 (
    echo ERROR: Failed to build project
    pause
    exit /b 1
)
call npm -g run dev
if errorlevel 1 (
    echo ERROR: Failed to start development server...
    pause
    exit /b 1
)

echo.
echo ===============================================
echo   Setup Complete!
echo ===============================================
echo.
echo Environment: %ENV_NAME%
echo Project: %PROJECT_NAME%
echo Panel: %PANEL_NAME%
echo ID: %PROJECT_ID%
echo Location: %cd%
echo.
echo To reactivate the environment later, run:
echo   %ENV_NAME%\Scripts\Activate
echo.
echo Happy coding!
pause