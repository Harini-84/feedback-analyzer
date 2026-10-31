@echo off
title InsightFlow Launcher
echo ========================================================
echo       Starting InsightFlow Services
echo ========================================================
echo.

set "ROOT_DIR=%~dp0"

echo [1/3] Launching FastAPI ML Service (Port 8001)...
start "InsightFlow - ML Service (:8001)" cmd /k "cd /d "%ROOT_DIR%services\ml-service" && "%ROOT_DIR%.venv\Scripts\uvicorn.exe" app.main:app --host 127.0.0.1 --port 8001"

ping 127.0.0.1 -n 3 >nul

echo [2/3] Launching Django API (Port 8000)...
start "InsightFlow - Django API (:8000)" cmd /k "cd /d "%ROOT_DIR%services\django-api" && "%ROOT_DIR%.venv\Scripts\python.exe" manage.py runserver 127.0.0.1:8000"

ping 127.0.0.1 -n 3 >nul

echo [3/3] Launching Next.js Frontend (Port 3000)...
start "InsightFlow - Next.js Frontend (:3000)" cmd /k "cd /d "%ROOT_DIR%frontend" && npm run dev"

echo.
echo ========================================================
echo  All 3 services have been launched in separate windows!
echo  - ML Service: http://127.0.0.1:8001/api/v1/health
echo  - Django API: http://127.0.0.1:8000/api/v1/health/
echo  - Frontend:   http://localhost:3000
echo ========================================================
echo.
