@echo off
setlocal
cd /d "%~dp0"
title Diagnostico - App Bracell

set "LOG=%~dp0erro_inicializacao.log"
if exist "%LOG%" del /f /q "%LOG%" >nul 2>&1

set "PYTHON_EXE=python"
where python >nul 2>&1
if errorlevel 1 (
    if exist "%LocalAppData%\Programs\Python\Python313\python.exe" (
        set "PYTHON_EXE=%LocalAppData%\Programs\Python\Python313\python.exe"
    ) else (
        echo ERRO: Python nao encontrado.>"%LOG%"
        echo Instale o Python ou ajuste o PATH e tente novamente.
        echo Log salvo em: %LOG%
        pause
        exit /b 1
    )
)

set "PORT=8501"
netstat -ano | findstr /R /C:":8501 .*LISTENING" >nul 2>&1
if not errorlevel 1 set "PORT=8502"
netstat -ano | findstr /R /C:":8502 .*LISTENING" >nul 2>&1
if not errorlevel 1 if "%PORT%"=="8502" set "PORT=8503"

echo Iniciando aplicativo na porta %PORT%...
echo Link: http://127.0.0.1:%PORT%
echo.
echo Iniciando aplicativo na porta %PORT%...>"%LOG%"
echo Python: %PYTHON_EXE%>>"%LOG%"
echo Pasta: %CD%>>"%LOG%"
echo Link: http://127.0.0.1:%PORT%>>"%LOG%"
echo.>>"%LOG%"

start "" "http://127.0.0.1:%PORT%"
"%PYTHON_EXE%" -m streamlit run streamlit_app.py --server.port %PORT% --server.address 127.0.0.1 --server.fileWatcherType none >>"%LOG%" 2>&1

echo.
echo O servidor foi encerrado.
echo Veja o log em: %LOG%
pause
