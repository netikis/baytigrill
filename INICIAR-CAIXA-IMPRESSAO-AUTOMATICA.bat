@echo off
chcp 65001 >nul
title BAYTIGRILL - Caixa com impressao automatica
cd /d "%~dp0"

REM Link do site fica em url-caixa.txt (edite com EDITAR-LINK-DO-CAIXA.bat)
set "SITE_URL="
if exist "url-caixa.txt" set /p SITE_URL=<"url-caixa.txt"

REM Remove espacos no inicio e fim
for /f "tokens=* delims= " %%a in ("%SITE_URL%") do set "SITE_URL=%%a"

if "%SITE_URL%"=="" (
    echo.
    echo [ERRO] Arquivo url-caixa.txt vazio ou nao encontrado.
    echo Execute EDITAR-LINK-DO-CAIXA.bat para colocar o link do site.
    echo.
    pause
    exit /b 1
)

echo %SITE_URL%| findstr /i "https:// http://" >nul
if errorlevel 1 (
    echo.
    echo [ERRO] O link em url-caixa.txt deve comecar com https://
    echo Execute EDITAR-LINK-DO-CAIXA.bat e corrija.
    echo.
    pause
    exit /b 1
)

set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"

if not exist "%CHROME%" (
    echo.
    echo [ERRO] Google Chrome nao encontrado.
    echo Instale o Chrome e execute este arquivo de novo.
    echo.
    pause
    exit /b 1
)

echo.
echo BAYTIGRILL - Abrindo caixa com impressao automatica...
echo Link: %SITE_URL%
echo.
echo - KNUP IM607 = impressora PADRAO do Windows
echo - Garcom lanca no celular e o cupom sai sozinho aqui
echo.

start "" "%CHROME%" --kiosk-printing --disable-print-preview --app="%SITE_URL%"

exit /b 0
