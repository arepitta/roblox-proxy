@echo off
cd /d C:\Users\arepita\Documents\roblox-proxy\api

echo ===============================
echo 🚀 Subiendo cambios a GitHub...
echo ===============================

:: Configurar identidad (solo primera vez, se guarda en git global)
git config --global user.name "arepitta"
git config --global user.email "hernandoarciniegas1@gmail.com"

:: Inicializa repo si no existe
if not exist ".git" (
    git init
    git branch -M main
)

:: Crea el repo en GitHub si no existe (no pedirá login otra vez si ya hiciste gh auth login)
gh repo view arepitta/roblox-proxy >nul 2>&1
if errorlevel 1 (
    echo 🏗️ Creando repo remoto en GitHub...
    gh repo create arepitta/roblox-proxy --public --source=. --remote=origin --push
) else (
    echo 🔄 Repo ya existe, haciendo push...
    git remote remove origin >nul 2>&1
    git remote add origin https://github.com/arepitta/roblox-proxy.git
    git add .
    git commit -m "commit automático desde script" || echo (sin cambios que commitear)
    git push -u origin main
)

echo ===============================
echo ✅ Todo listo. Revisa tu repo:
echo 👉 https://github.com/arepitta/roblox-proxy
echo ===============================

pause
