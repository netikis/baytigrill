@echo off
chcp 65001 >nul
title BAYTIGRILL - Editar link do caixa

if not exist "%~dp0url-caixa.txt" (
    echo https://SEU-USUARIO.github.io/SEU-REPO/index.html?estacao_impressao=1> "%~dp0url-caixa.txt"
)

echo Abrindo url-caixa.txt no Bloco de Notas...
echo.
echo Troque o link pela URL do seu site no GitHub.
echo Salve (Ctrl+S) e feche o Bloco de Notas.
echo.
notepad "%~dp0url-caixa.txt"
exit /b 0
