@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Generate and set the secret key
echo Generating secret key...
FOR /F "tokens=* USEBACKQ" %%F IN (`C:\Users\M92AX\AppData\Local\Programs\Python\Python312\python.exe -c "import secrets; print(secrets.token_urlsafe(16))"`) DO (
    SET SECRET_KEY=%%F
)
REM echo Secret Key: %SECRET_KEY%

REM Check if uvicorn is already running
SET uvicornRunning=0
FOR /F "tokens=1" %%i IN ('tasklist ^| findstr /i "uvicorn"') DO (
    IF "%%i"=="uvicorn.exe" SET uvicornRunning=1
)

REM If uvicorn is not running, start it
if !uvicornRunning! == 0 (
    if not "%minimized%"=="" goto :minimized
    set minimized=true
    start /min cmd /C "%~dpnx0"
    goto :EOF
    :minimized
    cd "C:\Users\M92AX\Documents\ble_smart_wrench_desktop"
    call venv\Scripts\activate
    SET "SECRET_KEY=%SECRET_KEY%"
    start "BLE SMART WRENCH" /b uvicorn main:app --reload
    timeout /t 5 /nobreak > nul
)

REM Open the browser with the loader page
start "" "%~dp0templates\loader.html"
