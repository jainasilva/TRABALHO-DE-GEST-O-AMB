@echo off
cd /d "%~dp0"
title Aplicativo Bracell - Streamlit
echo Iniciando aplicativo atualizado da Bracell...
echo.
echo NAO FECHE ESTA JANELA enquanto estiver usando o aplicativo.

set "PYTHON_EXE=python"
where python >nul 2>&1
if errorlevel 1 (
    if exist "%LocalAppData%\Programs\Python\Python313\python.exe" (
        set "PYTHON_EXE=%LocalAppData%\Programs\Python\Python313\python.exe"
    ) else (
        echo ERRO: Python nao encontrado.
        echo Instale o Python ou ajuste o PATH e tente novamente.
        pause
        exit /b 1
    )
)

set "PORT=8501"
netstat -ano | findstr /R /C:":8501 .*LISTENING" >nul 2>&1
if not errorlevel 1 (
    set "PORT=8502"
    netstat -ano | findstr /R /C:":8502 .*LISTENING" >nul 2>&1
    if not errorlevel 1 (
        set "PORT=8503"
    )
)

echo Link correto: http://127.0.0.1:%PORT%
echo.
echo Aguarde alguns segundos para o servidor iniciar...
start "" "http://127.0.0.1:%PORT%"
"%PYTHON_EXE%" -m streamlit run streamlit_app.py --server.port %PORT% --server.address 127.0.0.1 --server.fileWatcherType none
echo.
echo O servidor foi encerrado. Se aparecer algum erro acima, envie uma foto desta janela.
pause
