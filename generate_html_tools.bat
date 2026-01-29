@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   HTML Tools Data Generator
echo ========================================
echo.

REM Set paths
set "TOOLS_DIR=html_tools"
set "OUTPUT_FILE=tools_list.json"

echo [INFO] Scanning: %TOOLS_DIR%
echo [INFO] Output: %OUTPUT_FILE%
echo.

REM Check directory
if not exist "%TOOLS_DIR%" (
    echo [ERROR] Directory not found: %TOOLS_DIR%
    echo Creating directory...
    mkdir "%TOOLS_DIR%"
    echo Put HTML files in %TOOLS_DIR% and run again
    pause
    exit /b
)

REM Initialize JSON file
echo [ > "%OUTPUT_FILE%"

set "FIRST=1"
set "COUNT=0"

REM Process each HTML file
for %%f in ("%TOOLS_DIR%\*.html") do (
    set /a COUNT+=1
    
    REM Get filename without extension
    set "FILENAME=%%~nf"
    
    REM Create display name
    set "DISPLAY_NAME=!FILENAME!"
    set "DISPLAY_NAME=!DISPLAY_NAME:_= !"
    set "DISPLAY_NAME=!DISPLAY_NAME:-= !"
    
    REM Create description based on filename
    set "DESCRIPTION=A useful HTML tool"
    echo !FILENAME! | findstr /i "color" >nul && set "DESCRIPTION=Color selection tool"
    echo !FILENAME! | findstr /i "css" >nul && set "DESCRIPTION=CSS utility"
    echo !FILENAME! | findstr /i "html" >nul && set "DESCRIPTION=HTML formatter"
    echo !FILENAME! | findstr /i "js" >nul && set "DESCRIPTION=JavaScript tool"
    echo !FILENAME! | findstr /i "form" >nul && set "DESCRIPTION=Form generator"
    echo !FILENAME! | findstr /i "calc" >nul && set "DESCRIPTION=Calculator"
    
    REM Set path
    set "RELATIVE_PATH=html_tools/%%~nxf"
    
    REM Write to JSON
    if !FIRST! equ 1 (
        echo   { >> "%OUTPUT_FILE%"
        set "FIRST=0"
    ) else (
        echo   },{ >> "%OUTPUT_FILE%"
    )
    
    echo     "name": "!DISPLAY_NAME!", >> "%OUTPUT_FILE%"
    echo     "path": "!RELATIVE_PATH!", >> "%OUTPUT_FILE%"
    echo     "description": "!DESCRIPTION!" >> "%OUTPUT_FILE%"
    
    echo [!COUNT!] Processed: %%f
)

REM Close JSON array
if %COUNT% gtr 0 (
    echo   } >> "%OUTPUT_FILE%"
)
echo ] >> "%OUTPUT_FILE%"

echo.
echo ========================================
echo SUCCESS: Generated %COUNT% tools
echo File: %OUTPUT_FILE%
echo ========================================
echo.
echo HOW TO IMPORT:
echo 1. Open tools_navigation.html
echo 2. Click "Batch Import"
echo 3. Copy content from %OUTPUT_FILE%
echo 4. Paste into import dialog
echo ========================================
echo.

REM Show content
set /p SHOW="Show generated file? (Y/N): "
if /i "!SHOW!"=="Y" (
    echo.
    echo ===== %OUTPUT_FILE% =====
    type "%OUTPUT_FILE%"
    echo =========================
)

echo.
pause
goto :eof