@echo off
chcp 65001 >nul
title Instalador de Dependências - Olhar das Máquinas

echo ======================================================================
echo           OLHAR DAS MÁQUINAS - INSTALADOR DE DEPENDÊNCIAS PYTHON
echo ======================================================================
echo.
echo Verificando se o Python está instalado no seu computador...
echo.

set PY_CMD=
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set PY_CMD=python
    goto :PYTHON_ENCONTRADO
)

py --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set PY_CMD=py
    goto :PYTHON_ENCONTRADO
)

echo [ERRO] O Python não foi encontrado no seu computador!
echo.
echo Para executar as partes em Python deste projeto, você precisa instalar o Python:
echo 1. Baixe o instalador no site oficial: https://www.python.org/downloads/
echo 2. ATENÇÃO: Na tela inicial da instalação, marque a caixinha:
echo    "[X] Add Python to PATH" (Adicionar Python às variáveis de ambiente).
echo.
echo Pressione qualquer tecla para abrir o site oficial do Python no navegador...
pause >nul
start https://www.python.org/downloads/
exit /b 1

:PYTHON_ENCONTRADO
echo [OK] Python detectado com sucesso!
%PY_CMD% --version
echo.
echo ----------------------------------------------------------------------
echo [1/3] Atualizando o gerenciador de pacotes pip...
echo ----------------------------------------------------------------------
%PY_CMD% -m pip install --upgrade pip --quiet

echo.
echo ----------------------------------------------------------------------
echo [2/3] Instalando bibliotecas do projeto (opencv-python, numpy)...
echo ----------------------------------------------------------------------
%PY_CMD% -m pip install -r requirements.txt

echo.
echo ----------------------------------------------------------------------
echo [3/3] Verificando integridade das bibliotecas instaladas...
echo ----------------------------------------------------------------------
%PY_CMD% -c "import cv2, numpy; print('>> OpenCV versao:', cv2.__version__); print('>> NumPy versao :', numpy.__version__); print('>> STATUS: Todas as bibliotecas essenciais estao prontas para uso!')"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [AVISO] Ocorreu uma falha ao validar os módulos instalados.
    echo Tente executar este instalador como Administrador.
    pause
    exit /b 1
)

echo.
echo ======================================================================
echo           INSTALAÇÃO CONCLUÍDA COM SUCESSO!
echo ======================================================================
echo.
echo O sistema está pronto para ser executado em qualquer máquina!
echo Para iniciar, basta dar dois cliques em: index.bat ou INICIAR_PROJETO.bat
echo.
pause
