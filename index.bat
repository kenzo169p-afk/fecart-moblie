@echo off
chcp 65001 >nul
title Olhar das Máquinas - Inicializador Universal
cd /d "%~dp0"

echo ======================================================================
echo           OLHAR DAS MÁQUINAS - SISTEMA DE VIGILÂNCIA E IA
echo ======================================================================
echo.

:: 1. Detecta se o Python está disponível
set PY_CMD=
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set PY_CMD=python
    goto :PYTHON_OK
)

py --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set PY_CMD=py
    goto :PYTHON_OK
)

:: Caso a máquina não tenha Python instalado:
echo [AVISO] Python não encontrado nesta máquina.
echo Abrindo o painel Web 'index.html' diretamente no navegador...
echo.
echo * DICA: Para que as webcams funcionem sem restrições de segurança do navegador,
echo   recomenda-se instalar o Python (https://www.python.org/downloads).
echo.
start "" "index.html"
pause
exit /b 0

:PYTHON_OK
:: 2. Verifica se as bibliotecas essenciais estão instaladas
%PY_CMD% -c "import cv2, numpy" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Primeira execução detectada! Instalando dependências automaticamente...
    echo Aguarde alguns instantes...
    echo.
    %PY_CMD% -m pip install -r requirements.txt
    echo.
)

:: 3. Menu de Execução
echo Selecione como deseja iniciar o sistema:
echo.
echo  [1] Iniciar Painel Web Completo no Navegador (Recomendado - Suporte Total a Câmeras)
echo  [2] Iniciar Motor de IA Facial Nativo Python (OpenCV / gemini-code-1788908867217.py)
echo  [3] Iniciar Ambos (Painel Web no Navegador + Motor OpenCV em paralelo)
echo  [4] Instalar / Atualizar Bibliotecas Python
echo.
set /p OPCAO="Digite a opção desejada (1, 2, 3 ou 4) [Padrão: 1]: "

if "%OPCAO%"=="" set OPCAO=1
if "%OPCAO%"=="1" goto :OPCAO_WEB
if "%OPCAO%"=="2" goto :OPCAO_PYTHON
if "%OPCAO%"=="3" goto :OPCAO_AMBOS
if "%OPCAO%"=="4" goto :OPCAO_INSTALAR

:OPCAO_WEB
echo.
echo Iniciando servidor local e abrindo o navegador em http://localhost:8000 ...
%PY_CMD% servidor_local.py
pause
exit /b 0

:OPCAO_PYTHON
echo.
echo Iniciando motor de IA nativo com OpenCV...
%PY_CMD% "gemini-code-1788908867217.py"
pause
exit /b 0

:OPCAO_AMBOS
echo.
echo Iniciando Servidor Web e Motor Python em paralelo...
start "Olhar das Máquinas - Servidor Web Local" %PY_CMD% servidor_local.py
timeout /t 2 >nul
%PY_CMD% "gemini-code-1788908867217.py"
pause
exit /b 0

:OPCAO_INSTALAR
call instalar_dependencias.bat
exit /b 0
