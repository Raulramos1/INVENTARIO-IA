@echo off
:: run_from_github.bat
:: Edite REPO_URL, REPO_DIR, BRANCH, RUN_CMD y OPEN_IN_VSCODE.
:: Ejecucion: doble clic o desde CMD.

setlocal EnableExtensions EnableDelayedExpansion

REM === Variables ===
set "REPO_URL=https://github.com/USUARIO/REPO.git"
set "REPO_DIR=%USERPROFILE%\Projects\REPO"
set "BRANCH=main"
set "RUN_CMD="
set "OPEN_IN_VSCODE=true"

REM === Log temporal ===
set "TEMP_LOG=%TEMP%\run_from_github_%RANDOM%.log"
call :MAIN >>"%TEMP_LOG%" 2>&1
set "RET=%ERRORLEVEL%"
type "%TEMP_LOG%"
if exist "%REPO_DIR%" (
    if not exist "%REPO_DIR%\logs" mkdir "%REPO_DIR%\logs"
    move /y "%TEMP_LOG%" "%REPO_DIR%\logs\last_run.log" >nul
) else (
    del "%TEMP_LOG%" >nul 2>&1
)
exit /b %RET%

:MAIN
where git >nul 2>&1 || (
    >&2 echo Git no esta instalado. Descargalo de https://git-scm.com/download/win
    goto :err
)

if not exist "%REPO_DIR%\.git" (
    if exist "%REPO_DIR%" (
        >&2 echo La ruta "%REPO_DIR%" existe pero no es un repositorio Git.
        goto :err
    )
    git clone "%REPO_URL%" "%REPO_DIR%" || (
        >&2 echo Error al clonar el repositorio.
        goto :err
    )
) else (
    pushd "%REPO_DIR%" || goto :err
    git fetch --all --prune || goto :err
    git checkout "%BRANCH%" || goto :err
    git pull --ff-only || goto :err
    popd
)

cd /d "%REPO_DIR%" || goto :err

set "HAS_REQ=0"
set "HAS_NODE_LOCK=0"
set "HAS_PACKAGE=0"
set "HAS_DOCKER=0"
if exist "requirements.txt" set HAS_REQ=1
if exist "package-lock.json" set HAS_NODE_LOCK=1
if exist "npm-shrinkwrap.json" set HAS_NODE_LOCK=1
if exist "package.json" set HAS_PACKAGE=1
if exist "docker-compose.yml" set HAS_DOCKER=1

if %HAS_REQ%==1 (
    where py >nul 2>&1 || where python >nul 2>&1 || (
        >&2 echo Python no esta instalado. Descargalo de https://www.python.org
        goto :err
    )
)
if %HAS_PACKAGE%==1 (
    where npm >nul 2>&1 || (
        >&2 echo Node.js/npm no esta instalado. Descargalo de https://nodejs.org
        goto :err
    )
)
if %HAS_DOCKER%==1 (
    where docker >nul 2>&1 || (
        >&2 echo Docker no esta instalado. Descargalo de https://www.docker.com/get-started
        goto :err
    )
)

if %HAS_REQ%==1 (
    if not exist ".venv\Scripts\activate.bat" (
        py -m venv .venv || python -m venv .venv || (
            >&2 echo No se pudo crear el entorno virtual .venv
            goto :err
        )
    )
    call ".venv\Scripts\activate.bat" || goto :err
    python -m pip install --upgrade pip || goto :err
    pip install -r requirements.txt || goto :err
)

if %HAS_PACKAGE%==1 (
    if %HAS_NODE_LOCK%==1 (
        npm ci || goto :err
    ) else (
        npm install || goto :err
    )
)

if %HAS_DOCKER%==1 (
    docker compose up -d || (
        where docker-compose >nul 2>&1 && docker-compose up -d || (
            >&2 echo No se pudo iniciar docker compose
            goto :err
        )
    )
)

if defined RUN_CMD (
    echo Ejecutando comando personalizado: %RUN_CMD%
    call %RUN_CMD% || goto :err
) else (
    if exist "main.py" (
        if %HAS_REQ%==0 (
            where py >nul 2>&1 || where python >nul 2>&1 || (
                >&2 echo Python no esta instalado. Descargalo de https://www.python.org
                goto :err
            )
        )
        if exist ".venv\Scripts\activate.bat" call ".venv\Scripts\activate.bat"
        python main.py || goto :err
    ) else if %HAS_PACKAGE%==1 (
        npm start || goto :err
    ) else if %HAS_DOCKER%==1 (
        docker compose ps || (where docker-compose >nul 2>&1 && docker-compose ps)
        echo Servicios docker levantados en "%REPO_DIR%"
    ) else (
        echo Repositorio actualizado en "%REPO_DIR%"
    )
)

if /I "%OPEN_IN_VSCODE%"=="true" (
    where code >nul 2>&1 && start "" code "%REPO_DIR%"
)

goto :end

:err
exit /b 1

:end
exit /b 0

