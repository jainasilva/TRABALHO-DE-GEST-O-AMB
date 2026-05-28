@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Abrir App Bracell (Modo Fixo)

set "PYTHON_EXE=python"
where python >nul 2>&1
if errorlevel 1 (
    if exist "%LocalAppData%\Programs\Python\Python313\python.exe" (
        set "PYTHON_EXE=%LocalAppData%\Programs\Python\Python313\python.exe"
    ) else (
        echo ERRO: Python nao encontrado.
        pause
        exit /b 1
    )
)

set "PORT="
for %%P in (8501 8502 8503) do (
    netstat -ano | findstr /R /C:":%%P .*LISTENING" >nul 2>&1
    if errorlevel 1 (
        set "PORT=%%P"
        goto :port_ok
    )
)

echo Nenhuma porta livre entre 8501, 8502 e 8503.
echo Feche aplicativos antigos e tente novamente.
pause
exit /b 1

:port_ok
start "BracellStreamlit" /min "%PYTHON_EXE%" -m streamlit run streamlit_app.py --server.port !PORT! --server.address 127.0.0.1 --server.fileWatcherType none
timeout /t 6 >nul

netstat -ano | findstr /R /C:":!PORT! .*LISTENING" >nul 2>&1
if errorlevel 1 (
    echo Falha ao iniciar o servidor.
    echo Tente executar ABRIR_APP_DIAGNOSTICO.bat para gerar o log detalhado.
    pause
    exit /b 1
)

set "LINK=http://127.0.0.1:!PORT!"
echo Aplicativo iniciado com sucesso: !LINK!
start "" "!LINK!"
echo.
echo Pode fechar esta janela. O servidor continuara em segundo plano.
pause
