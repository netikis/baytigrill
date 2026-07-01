@echo off
chcp 65001 >nul
title BAYTIGRILL - Criar atalho na Area de Trabalho
cd /d "%~dp0"

echo.
echo ========================================
echo   BAYTIGRILL - Criar icone do Caixa
echo ========================================
echo.
echo Vai criar o atalho "BAYTIGRILL Caixa" na Area de Trabalho
echo com a logo do restaurante.
echo.
echo Faca isso UMA VEZ. Depois use sempre esse icone.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\criar-atalho-caixa.ps1" -Pasta "%~dp0"

echo.
pause
exit /b 0
